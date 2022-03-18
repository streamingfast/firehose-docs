---
weight: 30
title: Data Flow
---

What follows is a brief overview of the data flow within the Firehose system. We'll then dive deeper 
with a detailed explanation of the various components involved.

---

![firehose](/img/firehose-architecture.svg)

---

At a high level, the Firehose is constituted by:

- An instrumented version of the native node process, which streams pieces of block data in a custom text-based protocol.
- The `Extractor`, reading from that stream, reassembles the chunks into a Firehose block, writing it to persistent storage and broadcasting downstream.
- The `Merger` bundles the Firehose blocks together in batches of 100 merged blocks, and stores them to an object store or to disk.
- The `Relayer` reads the broadcasted blocks to provide a live source of blocks from multiple `Extractor` instances.
- The `Firehose` service receives blocks from either a file source (merged blocks) or a live source (relayer), and 
provides them in a “joined” manner to the consumers, through a gRPC connection.

In deeper detail, how it’s stored and moved around within the various components 
that form the Firehose stack. We will go from the very low level up to the gRPC streaming layer, 
talking along the way about the tradeoffs and benefits of the various elements.

---

## Extractor

Our pipeline begins with an instrumented version of the process used to sync the target blockchain. 
The patch (which we internally baptized `Deep Mind`), is built directly in the node’s source code, where we manually 
instrument critical block and transaction processing code paths. We currently have such a patch for 
Geth (and a few of its derivatives), for OpenEthereum, for Solana and for another high-throughput chain 
(which was merged in the upstream repository).

The instrumented code actually outputs small chunks of data using a simple text based protocol over the standard 
output pipe, for simplicity, performance and reliability. The messages sent can be seen as small events like 
`START BLOCK`, `START TRANSACTION`, `RECORD STATE CHANGE`, `RECORD LOG`, `STOP TRANSACTION`, `STOP BLOCK`. 
Each message contains the specific payload for the event like block number and block hash for the start block.

The instrumented output look like this for an example Ethereum client:

```sh
DMLOG BEGIN_BLOCK 33
DMLOG BEGIN_APPLY_TRX 52e3ea8d63f66bfa65a5c9e5ba3f03fd80c5cf8f0b3fcbb2aa2ddb8328825141 1baa897024ee45b5e2f2de32a2a3f3067fe0a840 0de0b6b3a7640000 0bfa f219f658459a2533c5a5c918d95ba1e761fc84e6d35991a45ed8c5204bb5a61a 43ff7909bb4049c77bd72750d74498cfa3032c859e2cc0864d744876aeba3221 21040 01 32 .
DMLOG TRX_FROM ea143138dab9a14e11d1ae91e669851e6cc72131
DMLOG BALANCE_CHANGE 0 ea143138dab9a14e11d1ae91e669851e6cc72131 ffffffffffffffffffffffffffffffffffffffffffffffd65ddbe509d1bbf1 ffffffffffff        ffffffffffffffffffffffffffffffffffd65ddbe509d169c1 gas_buy
DMLOG GAS_CHANGE 0 21040 40 intrinsic_gas
DMLOG NONCE_CHANGE 0 ea143138dab9a14e11d1ae91e669851e6cc72131 32 33
DMLOG EVM_RUN_CALL CALL 1
DMLOG BALANCE_CHANGE 1 ea143138dab9a14e11d1ae91e669851e6cc72131 ffffffffffffffffffffffffffffffffffffffffffffffd65ddbe509d169c1 ffffffffffffffffffffffffffffffffffffffffffffffc87d2531626d69c1 transfer
DMLOG BALANCE_CHANGE 1 1baa897024ee45b5e2f2de32a2a3f3067fe0a840 . 0de0b6b3a7640000 transfer
DMLOG EVM_PARAM CALL 1 ea143138dab9a14e11d1ae91e669851e6cc72131 1baa897024ee45b5e2f2de32a2a3f3067fe0a840 0de0b6b3a7640000 40 .
DMLOG EVM_END_CALL 1 0 .
DMLOG BALANCE_CHANGE 0 ea143138dab9a14e11d1ae91e669851e6cc72131 ffffffffffffffffffffffffffffffffffffffffffffffc87d2531626d69c1 ffffffffffffffffffffffffffffffffffffffffffffffc87d2531626dbbf1 reward_transaction_fee
DMLOG END_APPLY_TRX 21040 . 21040 00...00 []
DMLOG FINALIZE_BLOCK 33
DMLOG END_BLOCK 33 717 {"header":{"parentHash":"0x538473df2d1a762473cf9f8f6c69e6526e3030f4c2450c8fa5f0df8ab18bf156","sha3Uncles":"0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347","miner":"0x0000000000000000000000000000000000000000","stateRoot":"0xf7293dc5f7d868e03da71aa8ce8cf70cfe4e481ede1e8c37dabb723192acebb5","transactionsRoot":"0x8b89cee82fae3c1b51dccc5aa2d50d127ce265ed2de753000452f125b2921050","receiptsRoot":"0xa5d9213276fa6b513343456f2cad9c9dae28d7cd1c58df338695b747cb70327d","logsBloom":"0x00...00","difficulty":"0x2","number":"0x21","gasLimit":"0x59a5380","gasUsed":"0x5230","timestamp":"0x5ddfd179","extraData":"0xd983010908846765746888676f312e31332e318664617277696e000000000000e584572f63ccfbda7a871f6ad0bab9473001cb60597fa7693b7c103c0607d5ef3705d84f79e0a4cc9186c65f573b5b6e98011b3c26df20c368f99bcd7ab6d1d601","mixHash":"0x0000000000000000000000000000000000000000000000000000000000000000","nonce":"0x0000000000000000","hash":"0x38daac54143e832715197781503b5a6e8068065cc273b64f65ea10d1ec5ee41d"},"uncles":[]}
```

Those messages are then read by the `Extractor` component. It's responsible for launching the instrumented process, 
connecting to its standard output pipe and reading the `DMLOG` messages. It collects and organizes the various 
small chunks, assembling state changes, calls and transactions forming a fully-fledged block for a specific protocol. 

The assembled block is actually a protocol buffer generated object, taken from our protocol buffer definitions. 
Once a block has been formed, it is then serialized in binary format, stored into a persistent storage, and 
at the same time broadcast to all listeners using gRPC streaming. 

By storing a persistent version of the block, we enable historical access to all blocks of the chain without 
relying on the native node process. And by having them easily accessible, we are able to create highly parallelized 
reprocessing tools to slice and dice different sections of the chain at will.

---

## Merger

The `Merger` is responsible for creating bundles of blocks (100 per bundle) from persisted one-block files. 

This is done to improve performance, and helps reduce storage costs through better compression, as well as more 
efficient metered network access to a single 100 blocks bundle, as opposed to a single element. 

The bundled blocks become the "file source" (a.k.a historical source) of blocks for all components.

---

## Relayer

A multiplexer called the `Relayer` connects to multiple `Extractor` instances, and receives live blocks from them. 

Multiple connections enable redundancy in case the `Extractor` crashes or needs maintenance. 
It deduplicates incoming blocks, so will serve its own clients at the speed of the fastest `Extractor`. 

We like to say that they race to push data to consumers! 

The relayer then becomes the "live source" of blocks in the system, as it serves the same interface as the extractor in a simple (non-HA) setup.

---

## Firehose

Finally, the last component that serves the actual stream of blocks to the consumer is the `Firehose` service. 

The `Firehose` connects to both a file source and a live source, and starts serving blocks to the consumer. 
The sources are joined together using an intelligent "joining source" that knows when to switch over from the file source 
to the live source. 

As such, if a consumer’s request is for historical blocks, they are simply fetched from persistent storage, 
passed inside a `ForkDB` (more info about that below), and sent to the consumer with a cursor which uniquely identifies 
the block as well as its position in the chain. In so doing, we can resume even from forked blocks, as they are all preserved.

The `Firehose` component also has the responsibility of filtering a block’s content according to the request’s 
filter expression. The filter expression uses CEL syntax and while the syntax is common to all supported chains, 
the actual languages and available variables vary on a chain by chain basis. 

Filtering is applied usually on the smallest execution unit (EVM call on Ethereum, Instruction on Solana). 
Transactions that have no matching unit are removed from the block and execution units are flagged as matching/not 
matching the filter expression. Block metadata is always sent, even with no matches, to guarantee sequentiality on the receiving end.

---

## `bstream`

The underlying library that powers all of the components above is `bstream` (for Block Stream) 
available [on our Github organization](https://github.com/dfuse-io/bstream/blob/develop/README.md). 

It is the core code within our stack which abstracts away the files and the streaming of blocks from 
an instrumented blockchain node, to present to the user an extremely simple interface that deals with all reorgs. 
The library was built, tweaked and enhanced over several years with high speed and fast throughput in mind. 
For example, the file source has features like downloading multiple files in parallel, decoding multiple blocks in 
parallel, inline filtering, etc.

Inside `bstream`, one of the most important elements for proper blockchain linearity is the `ForkDB`, a graph-based 
data structure that mimics the forking logic used by the native node. `ForkDB` receives all blocks and orders them 
based on the parent-child relationship defined by the chain, keeping around active forked branches and reorgs that 
happen in the chain. 

When a branch of blocks becomes the longest chain of blocks, the `ForkDB` will switch to it, emitting a series of 
events for proper handling of forks (like `new 1b`, `new 2b`, `undo 2b`, `new 2a`, `new 3a`, etc.). Active forks are 
kept until a certain level of confirmation is achieved (exact rules can be configured for specific chain), and 
when block(s) become final (a.k.a irreversible). Specific irreversibility events are emitted by the `ForkDB` instance.

Each event emitted contains the step’s type (either `new`, `undo`, or `irreversible`), the block it relates to, 
and a cursor. The cursor contains information required to reconstruct an equivalent instance of the `ForkDB` 
in the correct branch, forked or canonical, enabling a perfect resume of the stream of events where the 
consumer left off. To visualize, the cursor points to a specific position in the stream of events emitted by `ForkDB` 
and as such, the blockchain itself.

The `bstream` library is chain-agnostic, and is only concerned about the concept of a `Block`, containing the minimal 
required metadata to maintain the consistency of the chain. `Block` carries a protocol buffer bytes payload which is 
decoded by the consumer to one of the supported chain-specific `Block` definitions, such as `sf.ethereum.codec.v1.Block`.

---

We now have seen everything required to stream blocks using Firehose, from data acquisition to a consumable stream of blocks.

---
weight: 30
title: Data Flow
description: StreamingFast Firehose data flow documentation
---

# Data Flow

The path and process of data flow through the Firehose system are important facets to understand when using the software.

The Firehose components are discussed in detail on the Components page in the documentation.&#x20;

Blockchain data flows from instrumented nodes to the gRPC server through the Firehose system.&#x20;

Each Firehose component plays an important role as the blockchain data flows through it.

![firehose](../../drawings/general\_architecture.png)

***

* An instrumented version of the native blockchain node process streams pieces of block data in a custom StreamingFast text-based protocol.
* Firehose Extractor components read data streams from instrumented blockchain nodes.
* Extractor components will then write the data to persistent storage. The data is then broadcast to the rest of the components in the Firehose system.&#x20;
* The Relayer component reads block data provided by one or more Extractor components and provides a live data source for the other Firehose components.
* The Merger component combines blocks created by Extractor components into batches of one hundred individually merged blocks. The merged blocks are stored in an object store or written to disk.
* The Indexer component provides a targeted summary of the contents of each 100-blocks file that was created by the Merger component. The indexed 100-blocks files are tracked and cataloged in an index file created by the Indexer component.
* The IndexProvider component reads index files created by the Indexer component and provides fast responses about the contents of block data for filtering purposes.
* The Firehose gRPC server component receives blocks from either:&#x20;
  * a merged blocks file source.
  * live block data received through the Relayer component.
  * an indexed file source created through the collaboration between the Indexer and IndexProvider components.&#x20;
* The Firehose gRPC Server component then joins and returns the block data to its consumers.

Tradeoffs and benefits are presented for how data is stored and how it flows from the instrumented blockchain nodes through the Firehose system.&#x20;

### Extractor Data Flow

The first piece of the StreamingFast Firehose system is the instrumentation conducted on nodes for targeted blockchains.

The instrumentation itself is called StreamingFast Deepmind. With Deepmind, the target blockchain node's source code is augmented where the critical block and transaction processing occurs.&#x20;

StreamingFast Deepmind Instrumentation is currently available for Geth, OpenEthereum, Solana and a few other blockchains.

StreamingFast Deepmind Instrumentation outputs small chunks of data using a simple text-based protocol over the operating system's standard output pipe.&#x20;

The StreamingFast simple text-based protocol provides simplicity, performance boosts, and reliability.&#x20;

The Deepmind Instrumentation works with block data event messages. The six types of  block data event messages include:

* `START BLOCK`
* `START TRANSACTION`
* `RECORD STATE CHANGE`
* `RECORD LOG`
* `STOP TRANSACTION`
* `STOP BLOCK`

Each message contains the specific payload for the event. The start block for instance contains the block number and block hash.

Example block data event messages from a Deepmind instrumented Ethereum client:

```
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

The block data event messages provided by the Deepmind instrumentation are read by one or more Extractor components.

The Extractor components:&#x20;

* launch instrumented Deepmind processes.
* connect to the operating system's standard output pipe.
* read the block data event messages or, `DMLOG`, messages.&#x20;

Extractor components also collect and organize the various smaller chunks of data.&#x20;

Extractor components assemble state changes, calls and transactions into a complete Firehose data block for a specific blockchain protocol.

The fully assembled Firehose data block is a Protocol Buffer-based object generated from a custom StreamingFast protobuf definition.&#x20;

After a block has been formed, it is serialized into binary format, stored in persistent storage, and simultaneously broadcast to all gRPC streaming subscribers.

The persistent block enables historical access to all data in the blockchain without reliance on native node processes.

The easily accessible block data enables StreamingFast's highly parallelized reprocessing tools to read and manipulate different sections of the chain at the developer's convenience.

### Relayer

\------ CONTINUE HERE ---------

A multiplexer called the `Relayer` connects to multiple `Extractor` instances, and receives live blocks from them.

Multiple connections enable redundancy in case the `Extractor` crashes or needs maintenance. It deduplicates incoming blocks, so will serve its own clients at the speed of the fastest `Extractor`.

We like to say that they race to push data to consumers!

The relayer then becomes the "live source" of blocks in the system, as it serves the same interface as the extractor in a simple (non-HA) setup.

***

### Merger Data Flow

The `Merger` is responsible for creating bundles of blocks (100 per bundle) from persisted one-block files.

This is done to improve performance, and helps reduce storage costs through better compression, as well as more efficient metered network access to a single 100 blocks bundle, as opposed to a single element.

The bundled blocks become the "file source" (a.k.a historical source) of blocks for all components.

***

### Indexer Data Flow

The `Indexer` is a background process which digests the contents of merged blocks, and creates targeted summaries of their contents. It writes these summaries to object storage as index files.

The targeted summaries are variable in nature, and are generated when an incoming `Firehose` query contains optional `Transforms`, which in turn contain the desired properties of a series of blocks. The `Transforms` can be likened to filter expressions, and are represented by protobuf definitions.

***

### Index Provider Data Flow

The `Index Provider` is a chain-agnostic component, whose job it is to accept `Firehose` queries containing `Transforms`.

It will interpret these `Transforms` expressions according to their protobuf definitions, and pass them along to chain-specific filter functions that will apply the desired filtering to Blocks in the stream.

Indeed, the `Index Provider` delivers knowledge about the presence (or absence!) of specific data in large ranges of Block data. This helps us avoid unnecessary operations on merged block files.

***

### Firehose Data Flow

Finally, the last component that serves the actual stream of blocks to the consumer is the `Firehose` service.

The `Firehose` connects to both a file source and a live source, and starts serving blocks to the consumer. The sources are joined together using an intelligent "joining source" that knows when to switch over from the file source to the live source.

As such, if a consumer’s request is for historical blocks, they are simply fetched from persistent storage, passed inside a `ForkDB` (more info about that below), and sent to the consumer with a cursor which uniquely identifies the block as well as its position in the chain. In so doing, we can resume even from forked blocks, as they are all preserved.

The `Firehose` component also has the responsibility of filtering a block’s content according to the request’s filter expression, represented by a `Transform`. This filtering is achieved by querying the `Index Provider`.

Transactions that have no matching unit are removed from the block and execution units are flagged as matching/not matching the filter expression. Block metadata is always sent, even with no matches, to guarantee sequentiality on the receiving end.

***

### `bstream`

The underlying library that powers all of the components above is `bstream` (a portmanteau for Block Stream) available [on our Github organization](https://github.com/dfuse-io/bstream/blob/develop/README.md).

It is the core code within our stack which abstracts away the files and the streaming of blocks from an instrumented protocol node, to present to the user an extremely simple interface that deals with all reorgs. The library was built, tweaked and enhanced over several years with high speed and fast throughput in mind. For example, the file source has features like downloading multiple files in parallel, decoding multiple blocks in parallel, inline filtering, etc.

Inside `bstream`, one of the most important elements for proper blockchain linearity is the `ForkDB`, a graph-based data structure that mimics the forking logic used by the native node. `ForkDB` receives all blocks and orders them based on the parent-child relationship defined by the chain, keeping around active forked branches and reorgs that happen on-chain.

When a branch of blocks becomes the longest chain of blocks, the `ForkDB` will switch to it, emitting a series of events for proper handling of forks (like `new 1b`, `new 2b`, `undo 2b`, `new 2a`, `new 3a`, etc.). Active forks are kept until a certain level of confirmation is achieved (exact rules can be configured for specific chain), and when block(s) become final (a.k.a irreversible). Specific irreversibility events are emitted by the `ForkDB` instance.

Each event emitted contains the step’s type (either `new`, `undo`, or `irreversible`), the block it relates to, and a cursor. The cursor contains information required to reconstruct an equivalent instance of the `ForkDB` in the correct branch, forked or canonical, enabling a perfect resume of the stream of events where the consumer left off. To visualize, the cursor points to a specific position in the stream of events emitted by `ForkDB` and as such, the blockchain itself.

The `bstream` library is chain-agnostic, and is only concerned about the concept of a `Block`, containing the minimal required metadata to maintain the consistency of the chain. `Block` carries a protocol buffer bytes payload which is decoded by the consumer to one of the supported chain-specific `Block` definitions, such as `sf.ethereum.codec.v1.Block`.

***

We've now covered everything required to understand the `Firehose` data flow, from data acquisition to producing a consumable stream of blocks.

---
weight: 30
title: Data Flow
description: StreamingFast Firehose data flow documentation
---

# Data Flow

### Data Flow in Firehose

#### Data Flow in Detail

The path and process of how data flows through the Firehose component family are important facets to understand when using the application.&#x20;

Blockchain data flows from instrumented nodes to the gRPC server through the Firehose [component family](components.md).&#x20;

#### Data Flows Through Components

Each Firehose component plays an important role as the blockchain data flows through it.

![firehose](../../drawings/general\_architecture.png)

#### Data Flow Component Relationship

The StreamingFast Deepmind instrumentation feeds to Extractor components. The Extractor components feed the Relayer component. The Index and IndexProvider components work with data provided by the instrumentation through the Extractor through the Relayer. Finally, the Firehose gRPC Server component hands data back to any consumers of the Firehose system.

#### Data Flow & Components Key Points

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
* _Tradeoffs and benefits are presented for how data is stored and how it flows from the instrumented blockchain nodes through the Firehose system._&#x20;

### Extractor Data Flow

#### Deepmind Instrumentation

Firehose begins at the instrumentation conducted on nodes for targeted blockchains.

The instrumentation itself is called StreamingFast Deepmind. Deepmind is an augmentation to the target blockchain node's source code. The augmentation is placed at the points where the critical block and transaction processing occurs.&#x20;

StreamingFast Deepmind instrumentation is currently available for Geth, OpenEthereum, Solana, and a few other blockchains.

#### Deepmind Data Output

StreamingFast Deepmind Instrumentation outputs small chunks of data using a simple text-based protocol over the operating system's standard output pipe.&#x20;

The StreamingFast simple text-based protocol provides simplicity, performance boosts, and reliability.&#x20;

#### Deepmind Data Messages

The Deepmind Instrumentation works with block data event messages. The six types of  block data event messages include:

* `START BLOCK`
* `START TRANSACTION`
* `RECORD STATE CHANGE`
* `RECORD LOG`
* `STOP TRANSACTION`
* `STOP BLOCK`

Each message contains the specific payload for the event. The start block for instance contains the block number and block hash.

#### Example Deepmind Messages

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

#### Deepmind & Extractor Coordination

The block data event messages provided by the Deepmind instrumentation are read by one or more Extractor components.

The Extractor components:&#x20;

* launch instrumented Deepmind processes.
* connect to the operating system's standard output pipe.
* read the block data event messages or, `DMLOG`, messages.&#x20;

#### Data Collection & Formation

Extractor components also collect and organize the various smaller chunks of data.&#x20;

Extractor components assemble state changes, calls, and transactions into a complete Firehose data block for a specific blockchain protocol.

The fully assembled Firehose data block is a Protocol Buffer-based object generated from a custom StreamingFast protobuf definition.&#x20;

#### Data Broadcast

After a block has been formed, it is serialized into binary format, stored in persistent storage, and simultaneously broadcast to all gRPC streaming subscribers.

#### Historical Data Access

The persistent block enables historical access to all data in the blockchain without reliance on native node processes.

#### Convenient Data Manipulation

The easily accessible block data enables StreamingFast's highly parallelized reprocessing tools to read and manipulate different sections of the chain at the developer's convenience.

### Relayer Data Flow

#### Relayer Data Flow in Detail

The Relayer component is responsible for connecting to one or more Extractor components and receiving live block data from them.

#### Multiple Relayer Connections

The Relayer component uses multiple connections to provide data redundancy for scenarios where Extractor components have crashed or require maintenance. The Relayer also deduplicates incoming blocks resulting in speeds that match the fastest Extractor available to read data from.

#### Racing Relayer Data

The design of the Relayer component enables them to race to push data to consumers!

#### Live Data Through Relayer

The Relayer component can function as a live data source for blocks in the Firehose system.&#x20;

#### Relayer & Extractor Overlap

Relayer components serve the same interface as Extractor components in simple non-high availability setups.

### Merger Data Flow

#### Merger Data Flow in Detail

Merger components create bundles containing one hundred blocks per bundle. The Merger component utilizes persisted one-block files to create the one hundred blocks bundle.

#### Merger Data Flow Responsibilities

The Merger component assists with the reduction of storage costs, improved data compression, and more efficient metered network access to single 100 blocks bundles.

#### Historical Data Access

The blocks bundled by the Merger component become the file-based historical data source of blocks for all components in the Firehose system.

### Indexer Data Flow

#### Indexer Data Flow in Detail

The Indexer component runs as a background process digesting merged block files.&#x20;

#### Block Summary

The Indexer component consumes merged blocks files and provides a targeted summary of the blocks. The targeted summaries are written to object storage as index files.

#### Transforms

Target summaries are created when incoming Firehose queries contain StreamingFast Transforms.

Targeted summaries are variable in nature. &#x20;

#### Transforms & Protocol Buffers

StreamingFast Transforms are used to locate a specific series of blocks according to search criteria provided by Firehose consumers. Transforms are created using Protocol Buffer definitions.

### IndexProvider Data Flow

#### IndexProvider Data Flow in Detail

The IndexProvider component accepts queries made to the Firehose system that contain StreamingFast Transforms.

#### Chain Agnostic

The IndexProvider component is not specific to any particular blockchain's data format. The IndexProvider can be considered chain-agnostic for this reason.

#### IndexProvider & Transforms

The IndexProvider component interprets Transforms in accordance with their Protocol Buffer definitions.&#x20;

#### Data Filtering

The Transforms are handed off to chain-specific filter functions. The desired filtering is applied to the blocks in the data stream by the IndexProvider component to limit the results it supplies.

#### Specific Data in Large Ranges

The IndexProvider component using Transforms is able to provide knowledge about specific data in large ranges of block data. This includes the presence or absence of specific data contained within the blocks the component is filtering.

### gRPC Server Data Flow

#### gRPC Server Data Flow in Detail

The gRPC Server component is responsible for supplying the stream of block data to requesting consumers of Firehose. The gRPC Server can be thought of as the top most component in the Firehose architectural stack.

#### Persistent & Live Data

Firehose gRPC Server components connect to persisted and live block data sources to serve consumer data requests.

Firehose was designed to switch between the persistent and live data store as it's joining data to intelligently fulfill inbound requests from consumers.

#### Historical Data Requests

Consumer requests for historical blocks are fetched from persistent storage. The historical blocks are passed inside a `ForkDB` and sent with a cursor uniquely identifying the block and its position in the blockchain.

#### Fork Preservation

Firehose has the ability to resume from forked blocks because all forks are preserved during node data processing.

#### gRPC Data Filtering

The gRPC component will filter block content through Transforms passed to the IndexProvider component. The Transforms are used as filter expressions to isolate specific data points in the block data.

Transactions that do not match the filter criteria provided in Transforms are removed from the block and execution units are flagged as either matching or not matching.&#x20;

Block metadata is always sent to guarantee sequentiality on the receiving end; with or without matching Transforms criteria.

### `bstream`

#### bstream in Detail

The StreamingFast bstream package manages flows of blocks and forks in a blockchain through a handler-based interface, similar to Go's net/http package.

#### bstream Orchestration

The bstream package is responsible for collaboration between all other Firehose components.

The bstream package abstracts details surrounding files and block streaming from instrumented blockchain nodes.&#x20;

The bstream package presents an extremely powerful and simplified interface for dealing will all blockchain reorganizations.&#x20;

#### bstream Design & Motivation

StreamingFast built, refined, and enhanced the bstream package over the period of several years. Key design considerations for bstream included high speed for data transfers and fast data throughput. Capabilities include downloading multiple files in parallel, decoding multiple blocks in parallel, and inline filtering.

#### bstream & ForkDB

An extremely important element of proper blockchain linearity is the StreamingFast `ForkDB.` The `bstream` package utilizes the `ForkDB` data structure for data storage.&#x20;

#### ForkDB in Detail

The `ForkDB` is a graph-based data structure that mimics the forking logic used by the native blockchain node.&#x20;

`The ForkDB` receives all blocks and orders them based on the parent-child relationship defined by the chain. The ForkDB will keep around active forked branches and reorganizations that are occurring on-chain.

#### ForkDB Events

When a block branch becomes the longest block chain, the `ForkDB` will switch to it. The `ForkDB` will emit a series of events for proper handling of forks for example `new 1b`, `new 2b`, `undo 2b`, `new 2a`, `new 3a`, etc.&#x20;

#### Active Forks

Active forks are kept until a certain level of confirmation is achieved or when blocks become final or irreversible. The exact rules for the confirmation can be configured for specific blockchains.

#### ForkDB Irreversibility Events

Specific irreversibility events are emitted by the `ForkDB` instance.

Each event emitted by the ForkDB instance contains:

* the step’s type of `new`, `undo`, or `irreversible,`
* the block the step relates to,
* and a cursor.

#### ForkDB Cursor

The ForkDB cursor points to a specific position in the stream of events emitted by `ForkDB` and the blockchain itself.

The ForkDB cursor contains information that is required to reconstruct an equivalent forked or canonical instance of the `ForkDB`.&#x20;

#### Start & Stop Event Streaming

The ForkDB is created in the correct branch, enabling the ability to perfectly resume the event streaming where the consumer last stopped.&#x20;

#### Chain-agnostic ForkDB

The `bstream` library is chain-agnostic, and is only concerned about the concept of a `Block`.&#x20;

#### bstream Metadata

The `bstream` library contains the minimally required metadata to maintain the consistency of the chain.&#x20;

#### Block & Protocol Buffers

`Block` carries a payload of Protocol Buffer bytes. The payload can be decoded by the consumer in accordance with one of the supported chain-specific `Block` definitions, for example, `sf.ethereum.codec.v1.Block`.

#### Data Storage in Detail

Understanding the storage mechanisms and methodologies used for data in the Firehose system is another important topic. Additional details on Firehose [data storage](data-storage.md) are provided in the documentation.  &#x20;

---
description: StreamingFast Firehose new blockchains
---

# Integration overview

## Introduction

Firehose is blockchain agnostic. It requires two main elements:

* a method of data extraction, specific to the blockchain's core codebase
* a Protocol Buffers data model for the chain
* a Go-based Firehose implementation, specific to that chain, that reads that data model, and provides the Firehose features of streaming and flat files management. This is a relatively small piece of code, that loads the Firehose and Substreams libraries for the heavy-lifting.

## Methods of extraction

### Node instrumentation

The first and most powerful integration of Firehose was done through direct node instrumentation, often because the APIs of the nodes didn't expose sufficiently rich data for indexing purposes.

This allowed us to dig into state changes (which are _usually_ the bread and butter of databases), and have clarity on the total ordering of events (like the ordinals). This way, we can have a more reliable understanding of what is happening on-chain.

* Example: here is the patch for the Ethereum `go-ethereum` codebase, to support Firehose: [https://github.com/streamingfast/go-ethereum/compare/v1.9.10...streamingfast:go-ethereum:firehose-v2](https://github.com/streamingfast/go-ethereum/compare/v1.9.10...streamingfast:go-ethereum:firehose-v2)
  * Search `firehose.` in there to get a grasp of the integration, or skip to the `.go` files.
* Here is a diff required by the OpenEthereum stack in Rust: [https://github.com/openethereum/openethereum/compare/v3.0.1...streamingfast:openethereum:release/oe-3.0.x-dm](https://github.com/openethereum/openethereum/compare/v3.0.1...streamingfast:openethereum:release/oe-3.0.x-dm) . This gives an idea of what is needed for deep node instrumentation.

For EVM chains, this is the recommended method, as this would provide drop-in support for all the Substreams already built for Ethereum. Opting for reduced methods of extractions like the following would mean having "light" Ethereum blocks, with missing data where some is expected, therefore less compatibility with already existing Substreams modules and disappointed users.

### Indexing frameworks

Some blockchains, like NEAR, offer a native indexing framework: node extensions or libraries that allow you to tap into the native chain's codebase. The integration then transforms those indexing frameworks into the streaming + flat files structure of Firehose, and can then feed engines like [Substreams](http://localhost:5000/o/rLHDhggcHly9IAY4HRzU/s/erQrzMtqELZRGAdugCR2/) of the `graph-node` from The Graph.

The downside of this method is that often state changes, full ordering and deeper relational data is lost in transit (or never captured by these frameworks).

### RPC Poller (Arweave)

The Arweave integration, for example, uses a poller process that sits aside the node. Each time there's a new block, it uses the already available RPC service of the node, to pull all of the data,  builds a Firehose block, streams it out, and flushes it to those loveable flat files.

This method limits the data available to that which is available through the node's RPC, which is often lacking and less precise than what we could get being directly inside the node. For instance, obtaining state changes is nearly impossible as this is not usually something that is collected and saved by nodes. Relational data is usually very limited.

### Database puller (Solana)

Our latest Solana integration literally pulls from their Bigtable output mode. It adds a bit of latency but greatly simplifies the integration. (Solana also has a more native indexing framework, but it doesn't work across history, thus we reverted to the simplest data model that is available across history).

This method is less than ideal but has the merit of being very simple.

## Protobuf Data Modeling

Designing the protobuf structures for your given blockchain is one of the most important steps in an integrator's journey.

Please review the [Naming Conventions](../references/naming-conventions.md) and the [different blockchain's data models](../references/protobuf-schemas.md), especially the Ethereum one which is thorough and well documented.

{% hint style="warning" %}
**Important**_: It's imperative that the data structures in the protobuf's of the custom integration are represented as precisely as possible._
{% endhint %}

## Go-based Firehose implementation

StreamingFast provides a Firehose starter that serves as a starting point to create the required chain-specific code and files. See the [Firehose Acme](firehose-starter.md) page for details.&#x20;


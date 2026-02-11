---
description: StreamingFast Firehose new blockchains
---

# Integration overview

## Introduction

Firehose is blockchain agnostic. It requires two main elements:

* **Node instrumentation**: The blockchain node must output [Firehose Logs](../architecture/data-flow.md#firehose-logs) — a unified, chain-agnostic protocol consisting of `FIRE INIT` and `FIRE BLOCK` messages
* **Protocol Buffers data model**: A protobuf schema defining your chain's block structure

The Firehose Logs protocol is intentionally simple: the node outputs block data as base64-encoded protobuf, and `firehose-core` handles everything else (parsing, storage, streaming, flat files management). No chain-specific Go code is required for the core functionality.

## Methods of extraction

### Node instrumentation

The recommended method of extraction is direct node instrumentation, where the blockchain node outputs the [Firehose Logs protocol](../architecture/data-flow.md#firehose-logs-protocol). This provides the richest data extraction, including state changes and total ordering of events.

The protocol is simple:
1. Output `FIRE INIT <version> <protobuf_type>` once at startup
2. Output `FIRE BLOCK <metadata> <base64_block>` for each block

See the [dummy-blockchain tracer](https://github.com/streamingfast/dummy-blockchain/tree/main/tracer) for a reference implementation.

**Examples of node instrumentation:**

* Ethereum `go-ethereum`: Uses Geth's [Live Tracing](https://geth.ethereum.org/docs/developers/evm-tracing/live-tracing) feature to extract block data. See the [go-ethereum Firehose integration](https://github.com/streamingfast/go-ethereum/blob/firehose-fh3.0/eth/tracers/firehose.go#L75) for the implementation.

For EVM chains, this is the recommended method, as this provides drop-in support for all the Substreams already built for Ethereum. Alternative extraction methods (below) result in "light" blocks with missing data, reducing compatibility with existing Substreams modules.

### Indexing frameworks

Some blockchains, like NEAR, offer a native indexing framework: node extensions or libraries that allow you to tap into the native chain's codebase. The integration then transforms those indexing frameworks into the streaming + flat files structure of Firehose, and can then feed engines like [Substreams](http://127.0.0.1:5000/o/rLHDhggcHly9IAY4HRzU/s/erQrzMtqELZRGAdugCR2/) of the `graph-node` from The Graph.

The downside of this method is that often state changes, full ordering and deeper relational data is lost in transit (or never captured by these frameworks).

### RPC Poller

For chains where direct node instrumentation is not feasible, an RPC poller can fetch block data from the node's RPC interface. The poller runs alongside the node, fetching each new block via RPC, assembling it into a Firehose block, and outputting it as Firehose Logs.

`firehose-core` provides a [blockpoller](https://github.com/streamingfast/firehose-core/tree/develop/blockpoller) library that handles the common polling logic. You implement the chain-specific RPC fetching, and the library manages cursor tracking, retries, and Firehose Logs output.

**Examples of RPC poller implementations:**

* [firehose-solana block fetcher](https://github.com/streamingfast/firehose-solana/tree/develop/block/fetcher)
* [firehose-ethereum block fetcher](https://github.com/streamingfast/firehose-ethereum/tree/develop/blockfetcher)

{% hint style="warning" %}
This method limits the data available to what the node's RPC exposes. State changes and deep relational data are typically unavailable, resulting in "lighter" blocks compared to direct instrumentation.
{% endhint %}

### Validator Plugins (Solana)

Some blockchains offer plugin architectures that allow tapping into the validator's internal data flow. For Solana, the [Firehose Geyser Plugin](https://github.com/streamingfast/firehose-geyser-plugin) implements Solana's Geyser plugin interface to extract both block data and account updates directly from the validator.

This approach provides richer data than RPC polling while avoiding the need to patch the node's source code.

## Protobuf Data Modeling

Designing the protobuf structures for your given blockchain is one of the most important steps in an integrator's journey.

Please review the [Naming Conventions](../references/naming-conventions.md) and the [different blockchain's data models](../references/protobuf-schemas.md), especially the Ethereum one which is thorough and well documented.

{% hint style="warning" %}
**Important**_: It's imperative that the data structures in the protobuf's of the custom integration are represented as precisely as possible._
{% endhint %}

## Firehose Implementation

Since the Firehose Logs protocol is unified and chain-agnostic, `firehose-core` handles parsing and processing out of the box. For most integrations, you only need:

1. Instrument your node to output Firehose Logs
2. Define your protobuf block schema

Optionally, you can create a `firehose-<chain>` wrapper around `firehose-core` for chain-specific CLI commands or tooling. StreamingFast provides a starter template for this — see the [Firehose Acme](firehose-starter.md) page for details.


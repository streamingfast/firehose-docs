---
description: StreamingFast Firehose core concepts and architecture documentation overview
---

# Concepts & Architecture

StreamingFast Firehose is best understood through gaining insight into the underlying design concepts and technical architecture of the product.

Components, flow of data, and method of data storage are important topics to understand for developers working with Firehose.


### Concepts & Architecture Overview

Core concepts for understanding Firehose concepts and architecture include:

* [components](components.md),
* the [flow of data](data-flow.md) through the system,
* how [data is stored](data-storage.md),
* and the underlying [design principles](design-principles.md).

### Top-level Overview

At the topmost level, Firehose extracts data from instrumented blockchain nodes and provides on-demand, data in real-time to consumers.

#### Firehose Data for Consumers

From the consumer standpoint, Firehose is simply a gRPC service.

#### Firehose Component Family

Behind that elegant simplicity is an orchestrated family of components working in harmony to provide _efficient_ blockchain data availability; in real-time.

#### Production Firehose

Setting up a production-grade Firehose system requires infrastructure and equipment.

To utilize Firehose, instrumentation must be integrated and enabled on a _full protocol node_ to serve data to consumers. Solutions are provided for working with [several blockchains](../integrate/firehose-setup.md) and a [starter project](../integrate-new-chains/firehose-starter.md) and full documentation is provided for working with [new blockchains](../integrate-new-chains/).

### High-availability Firehose

#### Highly-available by Design

Firehose was designed with high availability (HA), especially in mind, and is available with a few extra steps and components.

Firehose provides an ordered, _yet fork-aware_, stream of blocks consisting of rich blockchain data with _full and deep transaction history_.

### Firehose Blocks

#### Firehose Blocks in Detail

The Firehose blocks provide built-in cursoring enabling developers to stop and restart at the exact block needed; even for forked blocks. Firehose blocks contain details about consensus metadata, transactions, traces of transaction executions, and even blockchain state changes.

The StreamingFast vision is that Firehose blocks are sufficient as the single source of data for any possible blockchain API imaginable.

#### Resolve RPC Issues by Design

An important design goal for the Firehose system was to circumvent the need for ad-hoc RPC calls to protocol nodes that are brittle, slow, and inconsistent.

#### Firehose & Protocol Buffers

For each protocol, a strict and complete definition of its data structure is defined in carefully designed Protocol Buffer schemas.

<mark style="color:yellow;">\[LINK to Ethereum block models, and Solana block models, etc, etc.. or a pointer to our docs where we discuss those block models.</mark>

_<mark style="color:yellow;">**\[slm:] WHERE ARE THESE LINKS?**</mark>_<mark style="color:yellow;">]</mark>

The blocks flowing through Firehose are serialized Protocol Buffer messages.

#### Firehose Data in Detail

The Firehose system indexes and provides blockchain data that:

* is capable of handling high throughput chains,
* increases linear reprocessing performance,
* increases back-filling performance & maximizes data agility by enabling parallel processing,
* reduces the risk of non-deterministic output (by avoiding network roundtrips and issues, as well as complex node software failure or indeterminisms in such doing),
* improves testability and developer experience when iterating on blockchain data (the data being locally available, easily explored, and easily used in fixtures, etc.)
* simplifies an operator's reprocessing needs by relying on flat data files instead of live data processes.

#### Firehose Component Family

The Firehose system is split up into separate [components](components.md) that work together to extract, process, and store blockchain data from instrumented nodes.

#### Firehose Component in Detail

The next step is to learn about the individual Firehose [components](components.md) and how they work together.

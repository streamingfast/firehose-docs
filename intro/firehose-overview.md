---
description: StreamingFast Firehose overview
---

# Firehose Overview

### Purpose

#### What is it?

Firehose is a core component of StreamingFast’s suite of open-source blockchain technologies.

#### Streaming-first & Files-based

Firehose provides a files-based and streaming-first approach to processing blockchain data.&#x20;

#### Blockchain Data Extraction

Firehose is responsible for extracting data from blockchain nodes in a highly efficient manner. Firehose also consumes, processes, and streams blockchain data to consumers of nodes running Firehose-enabled, instrumented blockchain client software.

#### Speed Increases Across Blockchains

Firehose makes paramount improvements in the speed and performance of data availability for _any blockchain_.

The full [StreamingFast software suite](https://github.com/streamingfast) enables low-latency processing of real-time blockchain data in the form of binary data streams. [Substreams](https://substreams.streamingfast.io/) is another application in the suite that works with Firehose to execute massive operations on historical blockchain data, in an _extremely parallelized manner_.

### Benefits

Firehose is built using a component-based design. Data extraction is made possible through the family of Firehose components. The Firehose components include Firehose-enabled Blockchain Node, Reader, Merger, Relayer, and Firehose gRPC Server.

#### Cursors&#x20;

The Firehose cursor points to a specific position in the stream of events emitted by ForkDB and the blockchain itself. The ForkDB cursor contains information that is required to reconstruct an equivalent forked or canonical instance. Consumer requests for historical blocks are fetched from persistent Firehose storage. The historical blocks are passed inside a ForkDB and sent with a cursor uniquely identifying the block and its position in the blockchain.

#### Low Latency Racing Speed&#x20;

Placing multiple Reader components side by side, and fronted by one or more Relayers, allows for highly available setups. A Relayer connected to multiple Readers will deduplicate incoming streams, and push the first block downstream. Two Reader components will even race to push the data out first. Firehose is designed to leverage this racing Reader feature to the benefit of the end-user by producing the lowest latency possible.

### Motivation

#### Why does it exist?

Firehose was created to increase the speed and performance of blockchain data extraction from problems encountered in deployed, real-world applications.&#x20;

#### Firehose Prevents Downtime

Companies experienced up to three week-long periods of downtime due to the reprocessing of blockchain data in a linear fashion. Firehose was designed for highly efficient parallelized node data processing, at a massively large scale, circumventing these unwanted and problematic downtimes.

#### Unrivaled Blockchain Data Processing Speeds

Firehose was designed to process blockchain at speeds that were previously unseen and _thought to be impossible_.&#x20;

#### Resolving Slow JSON-RPC Responses

Another factor that heavily contributed to the design of Firehose is the brittleness and slow response times of, often inconsistent, JSON-RPC systems.

### Capabilities

#### How it works

The Firehose instrumentation service is added to a node for efficient capture and simple storage of blockchain data.&#x20;

#### Data Extraction, Storage, & Access

Firehose extracts, transforms and saves blockchain data in a highly performant file-based strategy. Blockchain developers can then access data extracted by Firehose through binary data streams.

#### Firehose Single Source of Truth (SSOT)

Firehose provides a single source of truth for developers looking to utilize blockchain data for their blockchain application development efforts.

#### The Graph & Firehose

Firehose is intended to stand as a replacement for The Graph’s original blockchain data extraction layer. [The Graph](https://thegraph.com/) is an indexing protocol used for the organization of blockchain data.

#### Technical Overview

To get started with Firehose, the first step is to learn about its core concepts and technical architecture, beginning with the [component family](https://firehose.streamingfast.io/concepts-and-architeceture/components).&#x20;

#### Existing Firehose Users

Experienced node operators can get up and running by using one of the pre-instrumented blockchain node codebases provided by StreamingFast. Look in the [Firehose Setup](https://firehose.streamingfast.io/firehose-setup/setup) section of the Firehose documentation for further information.

#### Custom Firehose Setups & New Chains

Lastly, developers can learn how to implement custom Firehose nodes in the [New Blockchains](https://firehose.streamingfast.io/integrate-new-chains/new-blockchains) section of the Firehose documentation.

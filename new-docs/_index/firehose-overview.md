---
description: StreamingFast Firehose technology overview page.
---

# Firehose Overview

### Purpose (What is it?)

Firehose is a core component of StreamingFast’s [suite](https://github.com/streamingfast) of open-source blockchain technologies.

Firehose provides a files-based and streaming-first approach to processing blockchain data.&#x20;

In basic terms, Firehose is responsible for extracting data from blockchain nodes in a highly efficient manner. Firehose also consumes, processes, and steams blockchain data to consumers of Firehose-enabled nodes.

Firehose makes paramount improvements in the speed and performance of data availability for any blockchain.

The full StreamingFast software suite enables low-latency processing of real-time blockchain data in the form of binary data streams. Another application in the suite that works with Firehose, known as [Substreams](https://substreams.streamingfast.io/), presents the ability to execute massive operations on historical blockchain data, in an extremely parallelized manner.

### Motivation (Why does it exist?)

Firehose was created to increase the speed and performance of blockchain data extraction from problems encountered in deployed, real-world applications.&#x20;

Companies experienced up to three week-long periods of downtime due to reprocessing blockchain data in a linear fashion. Firehose was designed for highly efficient parallelized node data processing, at a massively large scale, circumventing these unwanted and problematic downtimes.

Firehose was designed to process blockchain at speeds that were previously unseen and thought to be impossible.&#x20;

Another factor that heavily contributed to the design of Firehose is the brittleness and slow response times of, often, inconsistent JSON-RPC systems.

### Capabilities (How it works)

The Firehose instrumentation service is added to a node for efficient capture and simple storage of blockchain data. Firehose extracts, transforms and saves blockchain data in a highly performant file-based strategy. Blockchain developers can access data extracted by Firehose through binary data streams.

Firehose provides a single source of truth for developers looking to utilize blockchain data for their blockchain application development efforts.

Firehose is intended to stand as a replacement for The Graph’s original blockchain data extraction layer. [The Graph](https://thegraph.com/) is an indexing protocol used for the organization of blockchain data.

_**\<!-- INSERT\_TOC /-->**_

To get started with Firehose the first step is to learn about its core [concepts and technical architecture](../concepts/).&#x20;

Experienced node operators can get up and running by using one of the pre-instrumented blockchain node codebases provided by StreamingFast. Look in the [Firehose Setup ](../integrate/firehose-setup.md)section of the Firehose documentation for further information.

Lastly, developers who want to work with blockchains that don't have instrumented node codebases can learn how to implement their own in the [Integrate new chains](../integrate-new-chains/new-blockchains.md) section of the Firehose documentation.

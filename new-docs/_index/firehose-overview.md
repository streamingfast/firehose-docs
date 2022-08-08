---
description: StreamingFast Firehose technology overview page.
---

# Firehose Overview

### Introduction

The Firehose system, or just Firehose, is a core component of StreamingFast’s suite of open-source blockchain technologies.

In basic terms, Firehose is responsible for extracting data from blockchain nodes in a highly effecient manner.

Firehose makes paramount improvements in the speed and performance of blockchain data availability.

### Motivation

Firehose was created by StreamingFast to provide a files-based and streaming-first approach to processing blockchain data. Firehose is made available as part of the StreamingFast software suite.

The StreamingFast software suite enables low-latency processing of real-time blockchain data in the form of binary data streams. The StreamingFast suite also presents the ability to execute massive operations on historical blockchain data, in an extremely parallelized manner.

Firehose was created to increase the speed and performance of blockchain data extraction from problems encountered in deployed, real-world applications.&#x20;

### Capabilities

Firehose provides a single source of truth for developers looking to utilize blockchain data for their blockchain application development efforts. Part of the motivation behind creating Firehose was to remove the need for ad-hoc RPC calls to protocol nodes while populating data stores.

The Firehose instrumentation service is added to a node for efficient capture and simple storage of blockchain data. Firehose extracts, transforms and saves blockchain data in a highly performant file-based strategy. Blockchain developers can access data extracted by Firehose through binary data streams.

Firehose is intended to stand as a replacement for The Graph’s original blockchain data extraction layer. [The Graph](https://thegraph.com/) is an indexing protocol used for the organization of blockchain data.

To get started with Firehose the first step is to learn about its core concepts and technical architecture.&#x20;

A Firehose Demo is available that doesn't require an actual, full running blockchain node. It can be helpful to set up and investegate the demo to gain a better understanding of the system and all of its moving peices.

Experienced node operators can get up and running by using one of the pre-instrumented blockchain node codebases provided by StreamingFast. Look in the [Supported Blockchains](../integrate/node-instrumentation.md) section of the Firehose documentation for further information.

Lastly, developers who want to work with blockchains that don't have instrumented node codebases can learn how to implement their own in the [Unsupported Blockchains](../firehose-setup/unsupported-blockchains.md) section of the Firehose documentation.

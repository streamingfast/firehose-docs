---
description: StreamingFast Firehose technology overview page.
---

# Firehose Overview

### Welcome to Firehose&#x20;

Welcome to the product documentation for StreamingFast Firehose technology.&#x20;

This page serves as the primary entry point to the Firehose product documentation. Please submit a PR through GitHub with problems encountered in the documentation.

If you're new to Firehose, the[ Firehose Overview](firehose-overview.md) is the perfect place to start.&#x20;

If you already understand the core Firehose [concepts and architecture](broken-reference) please feel free to access the blockchain-specific documentation from the menu in [Firehose Setup](../setup/).&#x20;

The official GitHub repository for Firehose can be found in the official Github repository. [https://github.com/streamingfast/firehose](https://github.com/streamingfast/firehose)

### Purpose (What is it?)

#### StreamingFast Suite

Firehose is a core component of StreamingFast’s [suite](https://github.com/streamingfast) of open-source blockchain technologies.

#### Firehose Core Functionality

Firehose provides a files-based and streaming-first approach to processing blockchain data.&#x20;

#### Firehose Basics

In basic terms, Firehose is responsible for extracting data from blockchain nodes in a highly efficient manner. Firehose also consumes, processes, and steams blockchain data to consumers of Firehose-enabled nodes.

#### Firehose Advantages

Firehose makes paramount improvements in the speed and performance of data availability for _any blockchain_.

The full [StreamingFast software suite](https://github.com/streamingfast) enables low-latency processing of real-time blockchain data in the form of binary data streams. [Substreams](https://substreams.streamingfast.io/) is another application in the suite that works with Firehose to execute massive operations on historical blockchain data, in an _extremely parallelized manner_.

### Motivation (Why does it exist?)

#### Firehose Solves Real-world Problems

Firehose was created to increase the speed and performance of blockchain data extraction from problems encountered in deployed, real-world applications.&#x20;

#### Firehose Prevents Downtime

Companies experienced up to three week-long periods of downtime due to the reprocessing of blockchain data in a linear fashion. Firehose was designed for highly efficient parallelized node data processing, at a massively large scale, circumventing these unwanted and problematic downtimes.

#### Blockchain Data Processing Breakthroughs

Firehose was designed to process blockchain at speeds that were previously unseen and _thought to be impossible_.&#x20;

#### Resolving JSON-RPC Issues

Another factor that heavily contributed to the design of Firehose is the brittleness and slow response times of, often inconsistent, JSON-RPC systems.

### Capabilities (How it works)

#### Firehose Instrumentation

The Firehose instrumentation service is added to a node for efficient capture and simple storage of blockchain data.&#x20;

#### Data Extraction, Storage and Access

Firehose extracts, transforms, and saves blockchain data in a highly performant file-based strategy. Blockchain developers can then access data extracted by Firehose through binary data streams.

#### Firehose Single Source of Truth (SSOT)

Firehose provides a single source of truth for developers looking to utilize blockchain data for their blockchain application development efforts.

#### Firehose & The Graph

Firehose is intended to stand as a replacement for The Graph’s original blockchain data extraction layer. [The Graph](https://thegraph.com/) is an indexing protocol used for the organization of blockchain data.

_**\<!-- INSERT\_TOC /-->**_

#### Getting Started

To get started with Firehose the first step is to learn about its core [concepts and technical architecture](broken-reference).&#x20;

#### Existing Firehose Users

Experienced node operators can get up and running by using one of the pre-instrumented blockchain node codebases provided by StreamingFast. Look in the [Firehose Setup ](broken-reference)section of the Firehose documentation for further information.

#### Custom Firehose Setups & New Chains

Lastly, developers can learn how to implement custom Firehose nodes in the [Integrate new chains](../integrate-new-chains/new-blockchains.md) section of the Firehose documentation.

---
weight: 30
title: Concepts & Architecture
sideNavRoot: true
menu:
  operators:
    name: Concepts
    identifier: concepts
    weight: 10
description: StreamingFast Firehose core concepts and architecture documentation.
---

# Concepts & Architecture

TODO: List core concepts one by one. Introduce readers to this content and set them up to understand what's coming.

This section aims to be the best way to fully understand the power of the Firehose system, its architecture, the various components that it's made of, and how data flows through the Firehose stack up to the final consumer through the gRPC connection.

From the consumer standpoint, the `Firehose` is a gRPC service providing an ordered, yet fork-aware, stream of blocks with built-in cursoring, enabling you to stop and restart at the exact block you need, even on a forked block.

These blocks contain details about the consensus metadata, all transactions, and traces of their executions (including state changes).

Our vision is that these `Firehose` blocks are sufficient as the single source of data for any API that one would want to build on top of it, removing the need for ad-hoc RPC calls to a protocol node while populating a datastore.

For each protocol, a strict and complete definition of its data structure is defined in Protocol Buffer schemas. The blocks flowing through the `Firehose` are therefore messages that use those schemas (we call them blockchain `codecs`).

Ultimately, the `Firehose` provides a way to index and provide blockchain data which:

* is capable of handling high throughput chains (network bound)
* increases linear reprocessing performance
* increases back-filling performance & maximizes data agility by enabling parallel processing
* reduces the risk of non-deterministic output
* improves testability and developer experience when iterating on blockchain data
* simplifies an operator's reprocessing needs by relying on flat data files instead of live processes

***

In the following pages, we'll cover:

* [Principles and Approach](../../operate/concepts/principles/)
* [Data Flow](../../operate/concepts/data-flow/)
* [Components](../../operate/concepts/components/)
* [Data Stores and Artifacts](../../operate/concepts/data-storage/)

***

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

In basic terms, Firehose is responsible for extracting data from blockchain nodes. Firehose makes paramount improvements in the speed and performance of blockchain data availability.

From the consumer standpoint, Firehose is simply a gRPC service. Behind that elegant simplicity is an orchestrated family of components working in harmony to provide efficient blockchain data availability.

Setting up a production-grade Firehose system requires some infrastructure and equipment.

To utilize Firehose, instrumentation must be integrated and enabled on a full protocol node to serve data with the Firehose system.

Firehose was designed with high availability (HA) in mind and HA is available with a few extra steps and components.

Firehose provides an ordered, yet fork-aware, stream of blocks.&#x20;

The blocks provide built-in cursoring, enabling developers to stop and restart at the exact block needed; even for forked blocks.

Blocks contain details about consensus metadata, transactions, traces of transaction executions, and even the transaction state changes.

The StreamingFast vision is that Firehose blocks are sufficient as the single source of data for any API that one would want to build on top of it. The goal is to circumvent the need for ad-hoc RPC calls to a protocol node while simultaneously populating a datastore.

For each protocol, a strict and complete definition of its data structure is defined in carefully designed Protocol Buffer schemas.&#x20;

The blocks flowing through Firehose are messages using Protocol Buffer schemas. StreamingFast refers to the schemas as blockchain codecs.

The Firehose system indexes and provides blockchain data that:

* is capable of handling high throughput chains (network bound).
* increases linear reprocessing performance.
* increases back-filling performance & maximizes data agility by enabling parallel processing.
* reduces the risk of non-deterministic output.
* improves testability and developer experience when iterating on blockchain data.
* simplifies an operator's reprocessing needs by relying on flat data files instead of live data processes.

The Firehose system is split up into separate components that work together to extract, process, and store blockchain data from instrumented nodes. The next step is to learn about the Firehose components.

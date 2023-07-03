---
weight: 20
title: Design Principles
description: StreamingFast Firehose design principles
---

# Design Principles

Firehose was heavily inspired by large-scale data science machinery and other processes previously developed by the StreamingFast team.

## The Firehose "North Star"

Principles and assumptions:

* Flat files provide more efficiency than live running CPU and RAM-consuming and intensive processes.
* Fast iteration is preferred for data processes because data is inherently messy.
* Data agility is only achievable when data processes can be parallelized.
* Clear data contracts between tasks and processes including APIs, RPC query formats, and data model definitions, are critical
* Maximum precision is required for defining, referencing, and identifying concepts or data models. _Leave no stone unturned._
* The only guarantee in data science is that data processes change and evolve indefinitely.
* Migrating data is annoying, careful consideration must be taken for:
  * file formats,
  * forward and backward compatibility,
  * versioning,
  * and performance.

## Extraction

During the extraction phase, our goals are:

* All data captured should be deterministic, with the single exception of the block number at which the chain reaches finality (this number can vary depending on a node's relative topology to the network, and it could, for certain chains, not arrive at the same moment for all).
* Performance-wise, we want the impact to be minimal on the node that is usually doing write operations.

Deep data extraction is also one of the goals of our design, for the purposes of rich indexing downstream. For example:

* Extracting both the previous value, and the new value on balance changes, and state changes to accounts, storage locations, key/value stores, etc. This also helps with integrity checking (to know if any changes were missing, all  `prev -> new` pairs can be checked to match up, for a given storage key).
* Extracting all the relationships, between blocks and transactions, between transactions and single function/calls executions within a transaction, call trees, and a thing we call **total ordering**, meaning having an **ordinal** that can help order all things tracked (beginning/end of transactions, function calls, state changes, events emitted during execution, etc..) all relative to one another. For example, Ethereum has log indexes, allowing ordering of a log vs another log. But it doesn't allow for ordering a log versus a state change, or a log within a tree of calls (where perhaps the input of the call is what you're watching).
  * Some blockchains allow you to query state, and query events separately. Oftentime, it's not possible to link those things. We like to instrumented to be link changes to the source of events, to be able to build better downstream systems, and not lose relations between state and events.
  * Most indexing strategies hinge on events, but having state changes allows for new opportunities of indexing, triggering on the actual values being mutated. On certain chains, this allows you to avoid some gas costs by limiting the events, as you're able to trigger "virtual" events based on state changes.
  * Picking up on those changes can also avoid needing to (re-)design contracts when new data is needed, and wasn't thought of at first.

Also, when building an extractor is to **extract all the data necessary to recreate an archive node**. If nothing is missing, then someone indexing downstream should be satisfied.

Another principle is: like in any database, **transactions/calls are the true boundaries of state changes**, blocks exist only to facilitate and accelerate consensus (there would be great overhead if networks needed to agree on each individual transaction) but are as such an artificial boundary.

RPC nodes usually round up things to the block level, but with Firehose, data should be extracted in a way that makes the transaction, or even the individual smart contract calls, the unit of change. Concretely, this means state changes should be modeled at the lowest level.

## Pure Data, Files & Streams

### Flat Files

StreamingFast chose to utilize flat files instead of the traditional request and response model of data acquisition. Using flat files alleviates the challenges presented by querying pools of, generally load-balanced, nodes in some type of replication configuration.

### Simplification with Flat Files

The decision to rely on flat files assists with the reduction of massive consistency issues, retries, and incurred latency. In addition, using flat files greatly simplifies the task developers face writing code to interface with blockchain node data.

## Adhering to the Unix Philosophy

Flat-file and data stream abstractions adhere to the Unix philosophy of _writing programs that do one thing, do it well, and work together with other programs by handling streams of data as input and output._

## **State Transition Hierarchy**

StreamingFast uses state transitions scoped to calls, indexed within transactions, indexed within a block.

{% hint style="success" %}
**Tip**_: Blockchains typically “round up” state changes for all transactions into a block to facilitate consensus._
{% endhint %}

### Smart Contract Execution

The basic unit of execution always remains a single smart contract execution resulting in a single EVM call. However, calling another contract from within the first contract means a second execution will occur.

### Keeping Track of State

Contracts lose state precision when the state is changed in the middle of a transaction or block.

Attempting to locate the balance for calculations at the exact point needed, during the processing of a log event, for example, will result in receiving the balance value at the end of the block. The balance value may have changed state in a subsequent transaction after the transaction currently being indexed.

{% hint style="warning" %}
**Important**_: The process of querying nodes can cause substantial issues for developers wanting finite node data access._
{% endhint %}

### Blockchain Data Consumption

Consuming blockchain state is difficult and each blockchain presents its own issues.

[Solidity](https://docs.soliditylang.org/en/v0.8.16/), for example, uses `bytes32` => `bytes32` mapping, making such a data retrieval endeavour rather opaque and difficult to reason about. This data is available with additional effort, but not easily.

{% hint style="success" %}
**Tip**_: Developers having access to state data presents tremendous opportunities for indexing and application development._
{% endhint %}

### Protocol Buffers

Google's [Protocol Buffers version 3](https://developers.google.com/protocol-buffers/docs/proto3) met the requirements identified by StreamingFast for versioning, compatibility, and speed of file content.

Optional and required fields were removed in Google's Protocol Buffers version 3 simplifying the data extraction process.

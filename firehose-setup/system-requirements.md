---
description: StreamingFast Firehose System Requirements
---

# System Requirements

## System Requirements

### Network Flexibility

Firehose is extremely elastic and can support networks of varied sizes and shapes.

Ensure to gain a solid understanding of the different [data stores](../architecture/data-storage.md), artifacts, and databases required for operation.

Deployment efforts will match the size of history, and the density of the blockchain being consumed.

## Network shapes

Requirements for different shapes of networks are as follows.

### Persistent chains

In order to scale easily, components that run in a single process need to be decoupled.

The storage requirements will vary depending on the following metrics.

* _History length -_ The status of whether or not all the blocks are serving through Firehose.
* _Throughput in transactions and calls -_ Calls on Ethereum are the smallest units of execution to produce meaningful data, transaction overhead becomes negligible once you have two or three calls in a transaction. A simple ERC20 transfer generally has one call, or two calls when there is a proxy contract involved. Uniswap swap transactions, for instance, are usually composed of a few dozen of calls.

### Limiting Factors

The CPU/RAM requirements will depend on these factors:

* _High Availability -_ Highly available deployments will require _two, or more times the resources_ listed in the following examples, as a general rule.
* _Throughput of queries -_ Firehose is built for horizontal scalability. As the need for requests per second increase the deployment increases in size and more CPU/RAM is required in the deployment cluster.

### Instrumented Chain's Native Binary

Firehose requires native instrumentation of the binary of the chain you want to sync with, a vanilla binary of the chain without Firehose support built in it is not going to work. So you can only today synchronize with Firehose enabled chains.

{% hint style="success" %}
Other blockchains beyond the ones currently supported can be used with Firehose through the process of instrumentation. Information is provided for the instrumentation process of [_new blockchains_](../integrate-new-chains/integration-overview.md)
{% endhint %}

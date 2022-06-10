---
weight: 10
title: System Requirements
sideNavRoot: false
---

The **goal of this page** is to set expectations and get you to understand what is required to run `firehose-cosmos`.

The Firehose stack is extremely elastic, and supports handling networks of varied sizes and shapes. It is also heavy on data, so **make sure you have a good understanding** of the [different data stores, artifacts and databases]({{< ref "/operate/concepts/data-storage" >}}) required to run the Firehose stack.

The deployment efforts will be proportional to the size of history, and the density of the chain at hand.


## Network shapes

This document outlines requirements for different shapes of networks

### Persistent chains

In order to scale easily, you will want to decouple [components]({{< ref "/operate/concepts/components" >}}) that run in a single process.

The storage requirements will vary depending on these metrics:

* **The length of history**: whether or not you are serving all the blocks through the firehose

The CPU/RAM requirements will depend on these factors:

* **High Availability**: highly available deployments will require **2 times the resources** (or more) listed in the following examples, as a general rule.
* **Throughput of queries**: the Firehose stack is built for horizontal scalability, the more requests per second you want to fulfill, the larger the deployment, the more CPU/RAM you will need to allocate to your cluster.

#### Cosmoshub-4 Mainnet

`This section is incomplete.`

#### Osmosis-1 Mainnet

`This section is incomplete.`


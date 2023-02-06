---
description: StreamingFast Firehose Firehose-enabled node component
---

# Firehose-enabled Node

## Firehose-enabled Node in Detail

The Firehose-enabled Blockchain Node is a third-party blockchain node client, such as Ethereum, instrumented under StreamingFast practices to output data that will be read by the Firehose Reader component.

{% hint style="info" %}
**Note**_: The_ [_Reader_](reader.md) _component will consume the data produced by the Firehose-enabled Blockchain Node._
{% endhint %}

The Firehose-enabled Blockchain Node runs in tandem with the [Reader](reader.md) component. The two components are connected either through a UNIX pipe using `stdout`, or by having the [Reader](reader.md) component's process execute and fork the blockchain client. This is accomplished using the node-manager software included in Firehose.

Blockchain nodes used in this capacity require:

* very few features,
* no archive mode capability,
* no JSON-RPC service,
* and no indexed data will be queried.

The [Firehose-enabled Blockchain Node](firehose-enabled-node.md) is responsible for executing all transactions in an order respecting the consensus protocol of the blockchain.

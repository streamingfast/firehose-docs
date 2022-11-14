---
description: High availability for StreamingFast Firehose  components
---

# High Availability

## Firehose-enabled Blockchain Node

Coming soon.

## Reader

Placing multiple [Reader](reader.md) components side by side, and fronted by one or more Relayers, allows for highly available setups; a core attribute of the Firehose design.

A Relayer connected to multiple Readers will deduplicate the incoming stream and push the first block downstream.&#x20;

{% hint style="success" %}
_**Tip**: Two Reader components will even race to push the data first. The system is designed to leverage this racing_ [_Reader_](reader.md) _feature to the benefit of the end-user by producing the lowest latency possible._
{% endhint %}

### Data Aggregation

Firehose also aggregates any forked blocks that would be seen by a single Reader component, and not seen by any other [Reader](reader.md) components.

### Component Cooperation

Adding Reader components and dispersing each one geographically will result in the components actually racing to transfer blocks to the Relayer component. This cooperation between the [Reader](reader.md) and [Relayer](relayer.md) components _significantly_ increases the performance of Firehose.&#x20;

## Merger

A single [Merger](merger.md) component is required for Reader nodes in a highly available Firehose.&#x20;

Highly available systems usually connect to the [Relayer](relayer.md) component to receive real-time blocks. Merged blocked files are used when Relayer components can't provide the requested data or satisfy a range.

Restarts from other components can be sustained and time provided for [Merger](merger.md) components to be down when Relayer components provide 200 to 300 blocks in RAM.

{% hint style="info" %}
**Note**_: Merged blocks generally aren't read by other Firehose components in a running, live highly available system._
{% endhint %}

## Relayer

A [Relayer](relayer.md) component in a highly available Firehose will feed from all of the Reader nodes to gain a complete view of all possible forks.

{% hint style="success" %}
**Tip**_: Multiple_ [_Reader_](reader.md) _components will ensure blocks are flowing efficiently to the_ [_Relayer_](relayer.md) _component and throughout Firehose._
{% endhint %}

## Firehose gRPC Server

Firehose can be scaled horizontally to provide a highly available system.&#x20;

The network speed and data throughput between consumers and Firehose deployments will dictate the speed of data availability.&#x20;

{% hint style="info" %}
**Note**_: The network speed and data throughput between_ [_Relayer_](relayer.md) _components and_ [_Firehose gRPC Server_ ](grpc-server.md)_components will impact the speed of data availability._
{% endhint %}

Firehose [gRPC Server](grpc-server.md) components have the ability to connect to a subset of Relayer components or all Relayers available.

When the Firehose [gRPC Server](grpc-server.md) component is connected to all available Relayer components the probability that all forks will be viewed increases. Inbound requests made by consumers will be fulfilled with in-memory fork data.

Block navigation can be delayed when forked data isn't completely communicated to the Firehose [gRPC Server](grpc-server.md) component.&#x20;

Understanding how data flows through Firehose is beneficial for harnessing its full power.&#x20;

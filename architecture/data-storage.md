---
weight: 70
title: Data Storage
description: StreamingFast Firehose data storage
---

# Data Storage

## Data Storage in Firehose

### Data Storage in Detail

Data and the locations where it is stored are important facets of Firehose deployment and operation.&#x20;

Key Firehose data storage topics include [Data Stores](data-storage.md#data-stores), [Merged blocks files](data-storage.md#merged-blocks-files), [serialization](data-storage.md#serialization), [one block files](data-storage.md#one-block-files), and [100-blocks files](data-storage.md#one-hundred-blocks-files).

## Data Stores

Firehose Stores are abstractions sitting on top of Object Storage.

{% hint style="info" %}
**Note**_:_ _Object Storage is a data storage technique that manages data as objects in opposition to other data storage architectures like hierarchical file systems._
{% endhint %}

### Abstraction Library

Stores utilize the Firehose [dstore abstraction library](https://github.com/streamingfast/dstore) to provide support for local file systems, [Azure](https://www.google.com/aclk?sa=l\&ai=DChcSEwjr3Yqr9r75AhVuH60GHaPqCPAYABAAGgJwdg\&sig=AOD64\_1oS9RVQu923fWqHBIH9TUq9RxM\_w\&q\&adurl\&ved=2ahUKEwjZ\_4Or9r75AhXjKX0KHR\_eBJYQ0Qx6BAgDEAE), [Google Cloud](https://cloud.google.com/), [Amazon S3](https://www.google.com/aclk?sa=l\&ai=DChcSEwiitIe\_9r75AhXMwsIEHaRvBvsYABAAGgJwdg\&sig=AOD64\_0zvgrb2ySU8puRmtykCtCNbLSHQw\&q\&adurl\&ved=2ahUKEwiqpoC\_9r75AhWjKn0KHbOGDaYQ0Qx6BAgDEAE), and other Amazon S3 API compatible object storage solutions such as [MinIO](https://min.io/) or [Ceph](https://ceph.com/en/).

### Production Environments

For production deployments outside of cloud providers, StreamingFast recommends [Ceph](https://ceph.com/en/) as the distributed storage instead of its compatible Amazon S3 API system.

## Serialization

Firehose primarily utilizes [Protocol Buffers version 3](https://developers.google.com/protocol-buffers) for serialization.

## Merged Blocks Files

### Merged Blocks in Detail

Merged blocks files are also referred to as `100-blocks files`, and merged bundles. These terms are all used interchangeably within Firehose.

Merged blocks are binary files that use the [dbin](https://github.com/streamingfast/dbin) packing format to store a series of [bstream block objects](https://github.com/streamingfast/proto/blob/develop/sf/bstream/v1/bstream.proto), serialized as [protocol buffers](https://developers.google.com/protocol-buffers).

### Merged Block Creation

Firehose uses [Firehose-enabled node](components/firehose-enabled-node.md) components that have been set with a special flag to work in _catch-up_ mode to create merged blocks.

### Highly-available Merged Blocks

In [high-availability](components/high-availability.md) Firehose configurations, merged blocks will be created by the [Merger](components/merger.md) component. The [Firehose-enabled node](components/firehose-enabled-node.md) component will provide the Merger component with one-block files.

### Block Bundles

The [Merger](components/merger.md) component will also collate all of the one-block files into a single bundle of blocks.

### One Hundred Blocks Files

Up to one hundred blocks can be contained within a single 100-blocks file.&#x20;

The 100-blocks files can include multiple versions such as a fork block or a given block number, ensuring continuity through the previous block link.

### Blocks Files Consumption & Use

Nearly all components in Firehose rely on or utilize 100-blocks files. The bstream library consumes 100-blocks files for example.

Protocol-specific decoded block objects, like Ethereum, are what circulate amongst all processes that work with executed block data in Firehose.

## One Block Files

### One Block Files in Detail

In [high availability](components/high-availability.md) configurations, one-block files are transient and ensure the [Merger](components/merger.md) component gathers all visible forks from any [Firehose-enabled Node](components/firehose-enabled-node.md) components.

{% hint style="warning" %}
**Important**_: One-block files contain only one `bstream.Block` as a serialized protocol buffer._
{% endhint %}

### One-block File Consumption & Use

One-block files are consumed by the `Merger` component, bundled in executed __ 100-blocks files. The one-block files are then stored to `dstore` storage and consumed by most of the other Firehose processes.

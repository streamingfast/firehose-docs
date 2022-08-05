---
weight: 70
title: Data Storage
description: StreamingFast Firehose data storage documentation
---

# Data Storage

Data and the locations where it is stored are important facets of Firehose system deployment and operation.&#x20;

Key Firehose data storage topics include Stores, Merged blocks files, serialization, one block files, and 100-blocks files.

#### Stores

Simply defined, StreamingFast Firehose Stores are abstractions sitting on top of Object Storage.

Object Storage is a data storage technique that manages data as objects in opposition to other data storage architectures like hierarchical file systems.

Stores utilize the `Firehose` [dstore abstraction library](https://github.com/streamingfast/dstore) to provide support for local file systems, Azure, GCP, S3, and other S3 API compatible object storage solutions such as [minio](https://min.io/) or [ceph](https://ceph.com/en/).

For production deployments outside of cloud providers, StreamingFast recommends [ceph](https://ceph.com/en/) as the distributed storage instead of its compatible S3 API system.

#### Serialization

The `Firehose` system primarily utilizes [Protocol Buffers version 3](https://developers.google.com/protocol-buffers) for serialization.

#### Merged Blocks Files

Merged blocks files are also referred to as `100-blocks files`, and merged bundles. These terms are all used interchangeably within the StreamingFast Firehose system.

Merged blocks are binary files that use the [dbin](https://github.com/streamingfast/dbin) packing format to store a series of [bstream Block objects](https://github.com/streamingfast/proto/blob/develop/sf/bstream/v1/bstream.proto), serialized as [Protocol Buffers](https://developers.google.com/protocol-buffers).

Typical Firehose systems use Extractor components that have been set by a special flag to work in catch-up mode to create merged blocks.

In high-availability Firehose system configurations, merged blocks will be created by the Merger component. The Extractor component will provide the Merger component with one-block files.

The Merger component will also collate all of the one-block files into a single bundle of blocks.

Over one hundred blocks can be contained within a single 100-blocks file.&#x20;

The 100-blocks files can include multiple versions such as a fork block or a given block number, ensuring continuity through the previous block link.

Nearly all components in the Firehose system rely on or utilize 100-blocks files. The bstream library consumes 100-blocks files for example.

Protocol-specific decoded block objects. like [Ethereum](https://github.com/streamingfast/proto-ethereum/blob/develop/sf/ethereum/codec/v1/codec.proto), are what circulate amongst all processes that work with executed block data in the Firehose system.

#### One Block Files

For high availability configurations, one-block files are transient and ensure the `Merger` component gathers all visible forks from any `Extractor` components.

One-block files contain only one `bstream.Block` as a serialized Protocol Buffer.

One-block files are concumed by the `Merger` component, bundled in executed __ 100-blocks files. The one-block files are then stored to `dstore` storage and consumed by most of the other Firehose system processes.

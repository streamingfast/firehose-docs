---
weight: 70
title: Data Storage
---

# Data Storage

The data and locations where the data is stored are important details of the Firehose system deployment.

### Stores

Simply defined, StreamingFast Stores are abstractions on top of Object Storage used by the Firehose system.&#x20;

Object Storage is a data storage technique that manages data as objects in opposition to other data storage architectures like hierarchical file systems or sector and track-based block storage.

Stores utilize the `Firehose` [dstore abstraction library](https://github.com/streamingfast/dstore) to provide support for local files systems, Azure, GCP, S3, and S3 API compatible object storage solutions such as [minio](https://min.io/) or [ceph](https://ceph.com/en/).

#### Note

For production deployments outside of cloud providers, StreamingFast recommends [ceph](https://ceph.com/en/) as the distributed storage over its compatible S3 API system.

### Artifacts

The `Firehose` system primarily utilizes [Protocol Buffers version 3](https://developers.google.com/protocol-buffers) for serialization.

#### Merged Blocks Files

Merged blocks files are also referred to as `100-blocks files`, and merged bundles. These terms are all used interchangeably.

The merged blocks are binary files that use the [dbin](https://github.com/streamingfast/dbin) packing format to store a series of [bstream Block objects](https://github.com/streamingfast/proto/blob/develop/sf/bstream/v1/bstream.proto), serialized as [Protocol Buffers](https://developers.google.com/protocol-buffers).

Typical Firehose systems use Extractor components that have been set by a special flag to work in catch-up mode to create merged blocks.

In high-availability Firehose system configurations, merged blocks will be created by the Merger component. In HA, the Extractor component will contribute _one-block files_ to the Merger component. The Merger component will then collate all of the one-block files into a single bundle of blocks.

\---- CONTINUE HERE ----

These `100-blocks files` can contain **more than 100 blocks** (because they can include multiple versions (e.g. **fork block**) of a given block number), ensuring continuity through the previous block link.

They are consumed by the [bstream](https://github.com/streamingfast/bstream) library, used by almost all \[components]\(\{{< ref "./components" >\}}).

The protocol specific decoded block objects (for [Ethereum](https://github.com/streamingfast/proto-ethereum/blob/develop/sf/ethereum/codec/v1/codec.proto) as an example) are what circulate amongst all processes that work with executed block data.

#### One Block Files

These are transient files, destined to ensure that the `Merger` gathers all visible forks from the `Extractor` instances, in an HA setup.

They contain one `bstream.Block`, as serialized Protobuf (see links above).

The `Merger` will consume them, bundle them in _executed blocks files_ (100-blocks files) and store them to `dstore` storage, for consumption by most other processes.

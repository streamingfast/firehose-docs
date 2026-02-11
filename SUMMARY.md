# Table of contents

* [Firehose](README.md)

## Introduction

* [Firehose Overview](intro/firehose-overview.md)
* [Prerequisites](intro/prerequisites.md)

## Firehose

* [Architecture](architecture/README.md)
  * [Components](architecture/components/README.md)
    * [Reader Node](architecture/components/reader.md)
    * [Merger](architecture/components/merger.md)
    * [Relayer](architecture/components/relayer.md)
    * [gRPC Server](architecture/components/grpc-server.md)
    * [Substreams](architecture/components/substreams.md)
    * [High Availability](architecture/components/high-availability.md)
  * [Data Flow](architecture/data-flow.md)
  * [Data Storage](architecture/data-storage.md)
* [Deployment Guide](firehose-setup/overview.md)
  * [Single Machine Deployment](firehose-setup/single-machine-deployment.md)
  * [Distributed Deployment](firehose-setup/distributed-deployment.md)
  * [Ethereum](firehose-setup/ethereum/README.md)
  * [Solana](firehose-setup/solana/README.md)
  * [NEAR](firehose-setup/near/README.md)
  * [Injective](firehose-setup/injective/README.md)

## Integrate New Chains

* [Benefits](integrate-new-chains/benefits.md)
* [Integration Overview](integrate-new-chains/integration-overview.md)
* [Design Principles](integrate-new-chains/design-principles.md)
* [Firehose Acme](integrate-new-chains/firehose-starter.md)

## References

* [CLI Reference](references/cli-reference.md)
* [Supported Protocols](references/repositories.md)
* [Naming Conventions](references/naming-conventions.md)
* [Schemas](references/protobuf-schemas.md)
* [Indexing](references/indexing.md)
* [FAQ](references/faq.md)

## Release Notes

* [Change logs](release-notes/change-logs/README.md)
  * [Nov 8th 2023 Polygon Update](release-notes/change-logs/nov-8th-2023-polygon-update.md)

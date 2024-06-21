# Table of contents

* [Firehose](README.md)

## Introduction

* [Firehose Overview](intro/firehose-overview.md)
* [Prerequisites](intro/prerequisites.md)

## Architecture

* [Components](architecture/components/README.md)
  * [Firehose-enabled Node](architecture/components/firehose-enabled-node.md)
  * [Reader](architecture/components/reader.md)
  * [Merger](architecture/components/merger.md)
  * [Relayer](architecture/components/relayer.md)
  * [gRPC Server](architecture/components/grpc-server.md)
  * [High Availability](architecture/components/high-availability.md)
* [Data Flow](architecture/data-flow.md)
* [Data Storage](architecture/data-storage.md)

## Firehose Setup

* [Overview](firehose-setup/overview.md)
* [Ethereum](setup/ethereum/README.md)
  * [Installation](firehose-setup/ethereum/installation.md)
  * [Single-Machine Deployment](firehose-setup/ethereum/local-deployment.md)
  * [Reprocessing history](setup/ethereum/reprocessing-history.md)
  * [Synchronization](setup/ethereum/synchronization.md)
* [Injective](firehose-setup/injective/README.md)
  *[Single-Machine Deployment](firehose-setup/injective/single-machine-deployment.md)
* [NEAR](firehose-setup/near/README.md)
  * [Single-Machine Deployment](firehose-setup/near/installation.md)
* [System Requirements](firehose-setup/system-requirements.md)

## Community Integrations
* [Starknet](community-integrations/starknet/README.md)
  * [Networks and nodes](community-integrations/starknet/networks-and-nodes.md)
  * [Local deployment with Docker](community-integrations/starknet/local-deployment-with-docker.md)
  * [Local deployment without Docker](community-integrations/starknet/local-deployment-without-docker.md)

## Integrate New Chains

* [Benefits](integrate-new-chains/benefits.md)
* [Integration overview](integrate-new-chains/integration-overview.md)
* [Design Principles](integrate-new-chains/design-principles.md)
* [Firehose Acme](integrate-new-chains/firehose-starter.md)

## References

* [Supported Protocols](references/repositories.md)
* [Naming Conventions](references/naming-conventions.md)
* [Schemas](references/protobuf-schemas.md)
* [Indexing](references/indexing.md)
* [FAQ](references/faq.md)

## Release Notes

* [Change logs](release-notes/change-logs/README.md)
  * [Nov 8th 2023 Polygon Update](release-notes/change-logs/nov-8th-2023-polygon-update.md)

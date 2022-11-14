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

* [Overview](setup/README.md)
* [Ethereum](setup/ethereum/README.md)
  * [Installation](firehose-setup/ethereum/installation.md)
  * [Local Deployment](<firehose-setup/ethereum/installation (1).md>)
  * [Reprocessing history](setup/ethereum/reprocessing-history.md)
  * [Synchronization](setup/ethereum/synchronization.md)
* [Cosmos](setup/cosmos/README.md)
  * [Synchronization](setup/cosmos/synchronization.md)
* [System Requirements](firehose-setup/system-requirements.md)
* [Substreams](firehose-setup/substreams.md)

## Integrate New Chains

* [New Blockchains](integrate-new-chains/new-blockchains.md)
* [Firehose ACME](integrate-new-chains/firehose-starter.md)
* [Design Principles](integrate-new-chains/design-principles.md)
* [Why Integrate the Firehose](integrate-new-chains/why-integrate-the-firehose.md)

## References

* [Naming Conventions](references/naming-conventions.md)
* [Schemas](references/protobuf-schemas.md)
* [Repositories](references/repositories.md)
* [Indexing](references/indexing.md)
* [FAQ](references/faq.md)

## Release Notes

* [Change Log](https://github.com/streamingfast/firehose-ethereum/blob/develop/CHANGELOG.md)

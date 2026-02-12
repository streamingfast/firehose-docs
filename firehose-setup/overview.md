# Deployment Guide

This deployment guide provides **chain-agnostic** instructions for deploying Firehose. The concepts, commands, and deployment patterns shown here can be applied to any blockchain that has Firehose support.

{% hint style="info" %}
We use [dummy-blockchain](https://github.com/streamingfast/dummy-blockchain) as our example throughout this guide. This is a simple test blockchain that demonstrates all Firehose concepts without the complexity of a real blockchain.
{% endhint %}

## Prerequisites

Before starting, you'll need:

1. **Firecore binary**: Download from [firehose-core releases](https://github.com/streamingfast/firehose-core/releases)
2. **Dummy blockchain binary**: Install the example blockchain client

### Installing Dummy Blockchain

```bash
# Install the dummy blockchain binary
go install github.com/streamingfast/dummy-blockchain@latest

# Verify installation
dummy-blockchain --help
```

The dummy blockchain can be run standalone with:
```bash
dummy-blockchain start --store-dir=<data-dir> --block-rate=180
```

## Deployment Options

Choose your deployment approach based on your needs:

### 🏠 [Single Machine Deployment](single-machine-deployment.md)
**Recommended for**: Development, testing, small-scale production

- All components run on one machine
- Shared local storage between components
- Simpler setup and management
- Lower resource requirements

### 🏢 [Distributed Deployment](distributed-deployment.md) 
**Recommended for**: Production, high-availability, scalability

- Components run as separate processes/services
- Shared object storage (cloud storage)
- Horizontal scalability
- Production-ready architecture

## Architecture Overview

Both deployment patterns use the same core [Firehose architecture](../architecture/README.md):

1. **Reader**: Manages the blockchain node and extracts block data
2. **Merger**: Combines one-block files into merged block files
3. **Relayer**: Streams live blocks to consumers
4. **Firehose**: Serves historical and live block data via gRPC
5. **Substreams Tier 1**: Handles consumer requests and coordinates parallel processing
6. **Substreams Tier 2**: Executes WASM modules for parallel historical data transformation

{% hint style="info" %}
**About Substreams**: Substreams is a high-performance parallel data transformation engine that runs alongside Firehose. It enables users to define custom data pipelines in Rust/WASM that execute directly within your infrastructure. Running Substreams adds significant value for users while reusing the same block storage as Firehose. See [Substreams Component](../architecture/components/substreams.md) for details.
{% endhint %}

{% hint style="info" %}
For detailed information about each component, see the [Architecture Components](../architecture/components/README.md) documentation.
{% endhint %}

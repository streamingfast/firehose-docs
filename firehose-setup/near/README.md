---
description: Firehose chain-specific configuration for NEAR
---

# NEAR

This page provides NEAR-specific configuration for Firehose. For general deployment instructions, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="info" %}
This guide covers only the chain-specific Reader Node configuration. For general Firehose architecture and deployment patterns, refer to the main deployment guides.
{% endhint %}

{% hint style="warning" %}
This guide does not cover how to run a NEAR node. For node setup, hardware requirements, and network configuration, refer to the [official NEAR documentation](https://docs.near.org/).
{% endhint %}

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-near](https://github.com/streamingfast/firehose-near) | `firenear` |

Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-near/releases).

## Supported Approaches

NEAR Firehose supports two data extraction methods:

| Method | Description | Use Case |
|--------|-------------|----------|
| Firehose-enabled Node | NEAR node with Firehose patches | Best performance, full data |
| Lake Indexer | Reads from NEAR Lake (S3) | Easier setup, historical data |

## Reader Node Configuration

### Using Firehose-Enabled NEAR Node

```bash
firenear start reader-node \
  --reader-node-path="neard" \
  --reader-node-arguments="--home={node-data-dir} run --firehose-enabled" \
  --reader-node-data-dir="./data/near"
```

### Using NEAR Lake

NEAR Lake is a data availability layer that stores NEAR blockchain data in S3-compatible storage.

```bash
firenear start reader-node \
  --reader-node-path="firenear" \
  --reader-node-arguments="lake --bucket=near-lake-data-mainnet --region=eu-central-1 --start-block=0" \
  --reader-node-data-dir="./data/near"
```

### Full Stack Example

```bash
firenear start reader-node merger relayer firehose \
  --reader-node-path="neard" \
  --reader-node-arguments="--home={node-data-dir} run --firehose-enabled" \
  --reader-node-data-dir="./data/near" \
  --common-first-streamable-block=0
```

## Advertise Configuration

| Network | Chain Name | Block ID Encoding |
|---------|------------|-------------------|
| NEAR Mainnet | `near-mainnet` | `base58` |
| NEAR Testnet | `near-testnet` | `base58` |

```bash
--advertise-chain-name="near-mainnet" \
--advertise-block-id-encoding="base58"
```

## Resources

- [firehose-near GitHub](https://github.com/streamingfast/firehose-near)
- [NEAR Documentation](https://docs.near.org/)
- [NEAR Lake Framework](https://github.com/near/near-lake-framework)

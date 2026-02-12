---
description: Firehose chain-specific configuration for NEAR
---

# NEAR

This page covers Reader Node configuration specific to NEAR. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
This guide does not cover how to run a NEAR node. For node setup, hardware requirements, and network configuration, refer to the [official NEAR documentation](https://docs.near.org/).
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/near-firehose-indexer:<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/near-firehose-indexer/pkgs/container/near-firehose-indexer)

The image contains both the Firehose-patched NEAR indexer binary and `firenear`.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-near](https://github.com/streamingfast/firehose-near) | `firenear` |
| NEAR Indexer | [near-firehose-indexer](https://github.com/streamingfast/near-firehose-indexer) | `near-firehose-indexer` |

Download releases from the GitHub releases pages.

## Networks

| Network | Chain Name |
|---------|------------|
| NEAR Mainnet | `near-mainnet` |
| NEAR Testnet | `near-testnet` |

## Reader Node Configuration

NEAR Firehose uses a custom indexer binary (`near-firehose-indexer`) that wraps the NEAR node with Firehose instrumentation.

### NEAR Mainnet

```bash
firenear start reader-node <apps> \
  --advertise-chain-name="near-mainnet" \
  --reader-node-path="near-firehose-indexer" \
  --reader-node-config-file=/path/to/config.json \
  --reader-node-genesis-file=/path/to/genesis.json \
  --reader-node-key-file=/path/to/node_key.json \
  --reader-node-arguments="--home={node-data-dir} run" \
  <other_flags...>
```

### NEAR Testnet

```bash
firenear start reader-node <apps> \
  --advertise-chain-name="near-testnet" \
  --reader-node-path="near-firehose-indexer" \
  --reader-node-config-file=/path/to/config.json \
  --reader-node-genesis-file=/path/to/genesis.json \
  --reader-node-key-file=/path/to/node_key.json \
  --reader-node-arguments="--home={node-data-dir} run" \
  <other_flags...>
```

## Key Configuration Files

NEAR requires several configuration files:

| File | Description |
|------|-------------|
| `config.json` | NEAR node configuration |
| `genesis.json` | Network genesis file |
| `node_key.json` | Node identity key |

Download network-specific configuration files from the [NEAR documentation](https://docs.near.org/).

## Key Reader Node Flags

| Flag | Description |
|------|-------------|
| `--reader-node-config-file` | Path to NEAR config.json |
| `--reader-node-genesis-file` | Path to NEAR genesis.json |
| `--reader-node-key-file` | Path to NEAR node_key.json |
| `--home` | Node data directory (use `{node-data-dir}` template) |

## Resources

- [firehose-near GitHub](https://github.com/streamingfast/firehose-near)
- [near-firehose-indexer GitHub](https://github.com/streamingfast/near-firehose-indexer)
- [NEAR Documentation](https://docs.near.org/)

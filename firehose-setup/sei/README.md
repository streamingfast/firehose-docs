---
description: Firehose chain-specific configuration for Sei
---

# Sei

This page covers Reader Node configuration specific to Sei. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
This guide does not cover how to run a Sei node. For node setup, hardware requirements, and network configuration, refer to the [official Sei documentation](https://www.sei.io/developers).
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/sei-chain:<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/sei-chain/pkgs/container/sei-chain)

The image contains both the Firehose-patched Sei binary and `fireeth`.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-ethereum](https://github.com/streamingfast/firehose-ethereum) | `fireeth` |
| Sei (Firehose-patched) | [streamingfast/sei-chain](https://github.com/streamingfast/sei-chain) | `seid` |

Download releases from the GitHub releases pages.

## Networks

| Network | Chain Name |
|---------|------------|
| Sei Mainnet (Pacific-1) | `sei-mainnet` |
| Sei Testnet (Atlantic-2) | `sei-testnet` |

## Architecture

Sei is a Cosmos SDK-based blockchain with an integrated EVM layer. Firehose extracts EVM execution traces from the Sei node.

## Reader Node Configuration

### Sei Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="sei-mainnet" \
  --reader-node-path="seid" \
  --reader-node-arguments="start --home={node-data-dir} --trace --chain-id=pacific-1" \
  <other_flags...>
```

### Sei Testnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="sei-testnet" \
  --reader-node-path="seid" \
  --reader-node-arguments="start --home={node-data-dir} --trace --chain-id=atlantic-2" \
  <other_flags...>
```

## Key Sei Flags

| Flag | Description |
|------|-------------|
| `start` | Sei subcommand to start the node |
| `--trace` | **Required.** Enables Firehose Protocol output |
| `--chain-id` | Chain ID (`pacific-1` for mainnet, `atlantic-2` for testnet) |
| `--home` | Node data directory (use `{node-data-dir}` template) |

## Resources

- [Sei Documentation](https://www.sei.io/developers)
- [streamingfast/sei-chain](https://github.com/streamingfast/sei-chain)

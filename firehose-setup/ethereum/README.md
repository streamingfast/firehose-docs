---
description: Firehose chain-specific configuration for Ethereum and EVM chains
---

# Ethereum

This page covers Reader Node configuration for Ethereum and EVM-compatible chains. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
This guide does not cover how to sync an Ethereum node. For node synchronization, storage requirements, and network configuration, refer to the official documentation of your chosen client.
{% endhint %}

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-ethereum](https://github.com/streamingfast/firehose-ethereum) | `fireeth` |

The `fireeth` binary includes all `firecore` functionality plus Ethereum-specific features and commands. Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-ethereum/releases).

## Supported Networks

Firehose for Ethereum supports **Geth and Geth forks**. Each network requires a Firehose-patched version of its client:

| Network | Guide |
|---------|-------|
| Ethereum Mainnet, Sepolia, Hoodi | [Ethereum Mainnet](mainnet.md) |
| Arbitrum One, Nova | [Arbitrum](arbitrum.md) |
| Base Mainnet, Sepolia | [Base](base.md) |
| BNB Smart Chain | [BNB Smart Chain](bsc.md) |
| Katana | [Katana](katana.md) |
| Optimism Mainnet, Sepolia | [Optimism](optimism.md) |
| Polygon PoS | [Polygon](polygon.md) |
| Unichain | [Unichain](unichain.md) |
| Worldchain | [Worldchain](worldchain.md) |

## Common Configuration

All Ethereum-based networks share these characteristics:

### Chain Name (The Graph Network Registry)

Only `--advertise-chain-name` needs to be specified. All other advertise fields (block ID encoding, chain aliases, etc.) are automatically derived from [The Graph Network Registry](https://thegraph.com/networks/).

```bash
--advertise-chain-name="<chain-name>"
```

### VM Trace Flag

The Firehose-patched Geth (and forks) require the `--vmtrace=firehose` flag to emit Firehose Protocol logs to stdout.

### Basic Reader Node Pattern

```bash
fireeth start reader-node <apps> \
  --reader-node-path="<path-to-geth-binary>" \
  --reader-node-arguments="--vmtrace=firehose --datadir={node-data-dir} <network-flags>" \
  --advertise-chain-name="<chain-name>" \
  <other_flags...>
```

## Resources

- [firehose-ethereum GitHub](https://github.com/streamingfast/firehose-ethereum)
- [The Graph Network Registry](https://thegraph.com/networks/)
- [Geth Documentation](https://geth.ethereum.org/docs)

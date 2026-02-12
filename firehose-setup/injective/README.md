---
description: Firehose chain-specific configuration for Injective
---

# Injective

This page covers Reader Node configuration specific to Injective. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
Firehose for Injective uses an RPC poller approach. You can either run your own Injective node or use an RPC provider. For node setup, refer to the [official Injective documentation](https://docs.injective.network/).
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/firehose-cosmos:<version>
```

[View available versions on GitHub Packages](https://github.com/streamingfast/firehose-cosmos/pkgs/container/firehose-cosmos)

The image contains the `firecore` and `fireinjective` binaries.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-cosmos](https://github.com/streamingfast/firehose-cosmos) | `firecore`, `fireinjective` |

Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-cosmos/releases).

## Networks

| Network | Chain Name |
|---------|------------|
| Injective Mainnet | `injective-mainnet` |
| Injective Testnet | `injective-testnet` |

## Architecture

Firehose for Injective uses an **RPC poller** approach. The poller fetches blocks from Injective RPC endpoints and converts them to Firehose format.

```
┌──────────────────┐     RPC      ┌──────────────────┐     stdout    ┌──────────────┐
│  Injective RPC   │◄────────────│ fireinjective    │──────────────►│  Reader Node │
│    Endpoint      │              │   poller         │               │  (Firehose)  │
└──────────────────┘              └──────────────────┘               └──────────────┘
```

## Reader Node Configuration

### Injective Mainnet

```bash
firecore start reader-node <apps> \
  --advertise-chain-name="injective-mainnet" \
  --common-first-streamable-block=<start-block> \
  --reader-node-path="fireinjective" \
  --reader-node-arguments="fetch rpc {first-streamable-block} --state-dir={node-data-dir}/poller/states --block-fetch-batch-size=4 --endpoints=<rpc-endpoint>" \
  <other_flags...>
```

### Injective Testnet

```bash
firecore start reader-node <apps> \
  --reader-node-path="fireinjective" \
  --reader-node-arguments="fetch rpc {first-streamable-block} --state-dir={node-data-dir}/poller/states --block-fetch-batch-size=1 --endpoints=<rpc-endpoint>" \
  --common-first-streamable-block=<start-block> \
  --advertise-chain-name="injective-testnet" \
  <other_flags...>
```

## Key Poller Flags

| Flag | Description |
|------|-------------|
| `fetch rpc` | Subcommand to run the RPC poller |
| `{first-streamable-block}` | Variable substituted from `--common-first-streamable-block` |
| `--state-dir` | Directory to store poller state |
| `--block-fetch-batch-size` | Number of blocks to fetch in parallel |
| `--endpoints` | Injective RPC endpoint URL(s), can be specified multiple times |

## Resources

- [Injective Documentation](https://docs.injective.network/)
- [firehose-cosmos GitHub](https://github.com/streamingfast/firehose-cosmos)

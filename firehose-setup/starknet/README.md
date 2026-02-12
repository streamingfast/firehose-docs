---
description: Firehose chain-specific configuration for Starknet
---

# Starknet

This page covers Reader Node configuration specific to Starknet. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
Firehose for Starknet uses an RPC poller approach. You can either run your own Starknet node or use an RPC provider. For node setup, refer to the [official Starknet documentation](https://docs.starknet.io/).
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/firehose-starknet:<version>
```

[View available versions on GitHub Packages](https://github.com/streamingfast/firehose-starknet/pkgs/container/firehose-starknet)

The image contains the `firecore` and `firestarknet` binaries.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-starknet](https://github.com/streamingfast/firehose-starknet) | `firecore`, `firestarknet` |

Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-starknet/releases).

## Networks

| Network | Chain Name |
|---------|------------|
| Starknet Mainnet | `starknet-mainnet` |
| Starknet Sepolia | `starknet-sepolia` |

## Architecture

Firehose for Starknet uses an **RPC poller** approach. The poller fetches blocks from Starknet RPC endpoints and converts them to Firehose format. It also requires an Ethereum L1 endpoint for finality information.

```
┌──────────────────┐     RPC      ┌──────────────────┐     stdout    ┌──────────────┐
│  Starknet RPC    │◄────────────│  firestarknet    │──────────────►│  Reader Node │
│    Endpoint      │              │    poller        │               │  (Firehose)  │
└──────────────────┘              └──────────────────┘               └──────────────┘
         ▲                               │
         │                               │
┌──────────────────┐                     │
│  Ethereum L1     │◄────────────────────┘
│    Endpoint      │   (for finality)
└──────────────────┘
```

## Reader Node Configuration

### Starknet Mainnet

```bash
firecore start reader-node <apps> \
  --advertise-chain-name="starknet-mainnet" \
  --common-first-streamable-block=<start-block> \
  --reader-node-path="firestarknet" \
  --reader-node-arguments="fetch {first-streamable-block} --state-dir={node-data-dir}/poller/states --starknet-endpoints=<starknet-rpc> --eth-endpoints=<ethereum-rpc>" \
  <other_flags...>
```

### Starknet Sepolia

```bash
firecore start reader-node <apps> \
  --advertise-chain-name="starknet-sepolia" \
  --common-first-streamable-block=<start-block> \
  --reader-node-path="firestarknet" \
  --reader-node-arguments="fetch {first-streamable-block} --state-dir={node-data-dir}/poller/states --starknet-endpoints=<starknet-rpc> --eth-endpoints=<ethereum-sepolia-rpc>" \
  <other_flags...>
```

## Key Poller Flags

| Flag | Description |
|------|-------------|
| `fetch` | Subcommand to run the RPC poller |
| `{first-streamable-block}` | Variable substituted from `--common-first-streamable-block` |
| `--state-dir` | Directory to store poller state |
| `--starknet-endpoints` | Starknet RPC endpoint URL |
| `--eth-endpoints` | Ethereum L1 RPC endpoint for finality |
| `--block-fetch-batch-size` | Number of blocks to fetch in parallel |
| `--interval-between-fetch` | Delay between fetch cycles |

## Resources

- [Starknet Documentation](https://docs.starknet.io/)
- [firehose-starknet GitHub](https://github.com/streamingfast/firehose-starknet)

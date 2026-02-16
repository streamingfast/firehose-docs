---
description: Firehose chain-specific configuration for Avalanche C-Chain
---

# Avalanche

This page covers Reader Node configuration specific to Avalanche C-Chain. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
Firehose for Avalanche uses an RPC poller approach. You can either run your own Avalanche node or use an RPC provider. For node setup, refer to the [official Avalanche documentation](https://docs.avax.network/).
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:geth-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

The image contains the `fireeth` binary with the RPC poller.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-ethereum](https://github.com/streamingfast/firehose-ethereum) | `fireeth` |

Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-ethereum/releases).

## Networks

| Network | Chain Name |
|---------|------------|
| Avalanche C-Chain | `avalanche-mainnet` |

## Architecture

Firehose for Avalanche uses an **RPC poller** approach. The poller fetches blocks from Avalanche C-Chain RPC endpoints (which are EVM-compatible) and converts them to Firehose format.

```
┌──────────────────┐     RPC      ┌──────────────────┐     stdout    ┌──────────────┐
│  Avalanche RPC   │◄────────────│     fireeth      │──────────────►│  Reader Node │
│    Endpoint      │              │     poller       │               │  (Firehose)  │
└──────────────────┘              └──────────────────┘               └──────────────┘
```

## Reader Node Configuration

### Avalanche C-Chain Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="avalanche-mainnet" \
  --common-first-streamable-block=<start-block> \
  --reader-node-path="fireeth" \
  --reader-node-arguments="tools poller optimism <rpc-endpoint> {first-streamable-block}" \
  <other_flags...>
```

## Key Poller Flags

| Flag | Description |
|------|-------------|
| `tools poller optimism` | Subcommand to run the EVM RPC poller |
| `<rpc-endpoint>` | Avalanche C-Chain RPC endpoint URL |
| `{first-streamable-block}` | Variable substituted from `--common-first-streamable-block` |

## Resources

- [Avalanche Documentation](https://docs.avax.network/)
- [Avalanche C-Chain RPC](https://docs.avax.network/apis/avalanchego/apis/c-chain)
- [firehose-ethereum GitHub](https://github.com/streamingfast/firehose-ethereum)

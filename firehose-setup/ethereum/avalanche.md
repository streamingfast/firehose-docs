---
description: Firehose configuration for Avalanche C-Chain
---

# Avalanche

This page provides Avalanche C-Chain specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/firehose-ethereum:<version>
```

[View available versions on GitHub Packages](https://github.com/streamingfast/firehose-ethereum/pkgs/container/firehose-ethereum)

The image contains the `fireeth` binary with RPC poller support.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-ethereum](https://github.com/streamingfast/firehose-ethereum) | `fireeth` |

## Networks

| Network | Chain Name |
|---------|------------|
| Avalanche C-Chain | `avalanche-mainnet` |

## Architecture

Firehose for Avalanche C-Chain uses an **RPC poller** approach. The poller fetches blocks from an Avalanche RPC endpoint and converts them to Firehose format.

```
┌──────────────────┐     RPC      ┌──────────────────┐     stdout    ┌──────────────┐
│  Avalanche RPC   │◄────────────│  fireeth poller  │──────────────►│  Reader Node │
│    Endpoint      │              │                  │               │  (Firehose)  │
└──────────────────┘              └──────────────────┘               └──────────────┘
```

## Reader Node Configuration

### Avalanche C-Chain Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="avalanche-mainnet" \
  --reader-node-path="fireeth" \
  --reader-node-arguments="tools poller optimism <rpc-endpoint> <start-block>" \
  <other_flags...>
```

## Key Poller Flags

| Flag | Description |
|------|-------------|
| `tools poller optimism` | Subcommand to run the Optimism-compatible RPC poller |
| `<rpc-endpoint>` | Avalanche C-Chain RPC endpoint URL |
| `<start-block>` | Block number to start polling from |

## Resources

- [Avalanche Documentation](https://docs.avax.network/)
- [firehose-ethereum GitHub](https://github.com/streamingfast/firehose-ethereum)

---
description: Firehose chain-specific configuration for Solana
---

# Solana

This page covers Reader Node configuration specific to Solana. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
This guide does not cover how to run a Solana validator. For validator setup, hardware requirements, and network configuration, refer to the [official Solana documentation](https://docs.solana.com/).
{% endhint %}

## Architecture

Firehose for Solana uses a **Geyser plugin** approach. The plugin hooks into the Solana validator and emits Firehose Protocol data through a gRPC interface.

```
┌──────────────────────────────────────────────────────┐
│                  Solana Validator                    │
│  ┌────────────────────────────────────────────────┐  │
│  │           Firehose Geyser Plugin               │  │
│  │  (emits blocks via gRPC on port 10015)         │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
                         │
                         ▼ gRPC
┌──────────────────────────────────────────────────────┐
│    firesolana (reader-node-firehose mode)            │
│    Consumes blocks and produces one-block files      │
└──────────────────────────────────────────────────────┘
```

## Docker Image

```
ghcr.io/streamingfast/firehose-geyser-plugin:<version>
```

[View available versions on GitHub Packages](https://github.com/streamingfast/firehose-geyser-plugin/pkgs/container/firehose-geyser-plugin)

The image contains the Solana validator with the Firehose Geyser plugin pre-installed.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-solana](https://github.com/streamingfast/firehose-solana) | `firesolana` |
| Geyser Plugin | [firehose-geyser-plugin](https://github.com/streamingfast/firehose-geyser-plugin) | Shared library |

Download releases from the GitHub releases pages.

## Networks

| Network | Chain Name |
|---------|------------|
| Solana Mainnet | `solana-mainnet-beta` |
| Solana Devnet | `solana-devnet` |
| Solana Testnet | `solana-testnet` |

## Reader Node Configuration

Solana Firehose uses `reader-node-firehose` mode, which connects to the Geyser plugin's gRPC endpoint instead of spawning a subprocess.

### Reader Node (Firehose Mode)

```bash
firesolana start reader-node-firehose <apps> \
  --reader-node-firehose-grpc-listen-addr=<geyser-plugin-grpc-addr> \
  --advertise-chain-name="solana-mainnet-beta" \
  <other_flags...>
```

## Geyser Plugin Configuration

The Geyser plugin is configured via a JSON file passed to the Solana validator. The plugin emits Firehose data on a gRPC endpoint.

### Example Plugin Configuration

```json
{
  "libpath": "/path/to/libfirehose_geyser_plugin.so",
  "blocks_grpc_listen_addr": "0.0.0.0:10015",
  "accounts_grpc_listen_addr": "0.0.0.0:10016"
}
```

### Starting the Validator

```bash
solana-validator \
  --geyser-plugin-config /path/to/firehose-geyser-config.json \
  <other_validator_flags...>
```

## Resources

- [firehose-solana GitHub](https://github.com/streamingfast/firehose-solana)
- [firehose-geyser-plugin GitHub](https://github.com/streamingfast/firehose-geyser-plugin)
- [Solana Documentation](https://docs.solana.com/)
- [Solana Geyser Plugin Interface](https://docs.solana.com/developing/plugins/geyser-plugins)

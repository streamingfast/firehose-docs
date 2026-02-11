---
description: Firehose chain-specific configuration for Injective
---

# Injective

This page provides Injective-specific configuration for Firehose. For general deployment instructions, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="info" %}
This guide covers only the chain-specific Reader Node configuration. For general Firehose architecture and deployment patterns, refer to the main deployment guides.
{% endhint %}

{% hint style="warning" %}
This guide does not cover how to run an Injective node. For node setup, hardware requirements, and network configuration, refer to the [official Injective documentation](https://docs.injective.network/).
{% endhint %}

## Architecture

Firehose for Injective uses an **RPC poller** approach. The poller connects to an Injective RPC endpoint and converts the data into Firehose Protocol format.

```
┌──────────────────┐     RPC      ┌──────────────┐     stdout    ┌──────────────┐
│  Injective RPC   │◄────────────│  RPC Poller  │──────────────►│  Reader Node │
│    Endpoint      │              │   Binary     │               │  (Firehose)  │
└──────────────────┘              └──────────────┘               └──────────────┘
```

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-cosmos](https://github.com/streamingfast/firehose-cosmos) | `firecosmos` |

Injective is built on Cosmos SDK, so it uses the `firecosmos` binary. Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-cosmos/releases).

## Reader Node Configuration

### RPC Endpoint Requirements

The Injective RPC endpoint must support:
- Block queries with full transaction data
- Historical block access for the range you need

### Basic Configuration

```bash
firecosmos start reader-node \
  --reader-node-path="firecosmos" \
  --reader-node-arguments="poller --rpc-endpoint=https://sentry.tm.injective.network:443" \
  --reader-node-data-dir="./data/injective"
```

### Full Stack Example

```bash
firecosmos start reader-node merger relayer firehose \
  --reader-node-path="firecosmos" \
  --reader-node-arguments="poller --rpc-endpoint=${INJECTIVE_RPC_ENDPOINT} --chain-id=injective-1" \
  --reader-node-data-dir="./data/injective" \
  --common-first-streamable-block=1
```

### Key Poller Flags

| Flag | Description |
|------|-------------|
| `--rpc-endpoint` | Injective RPC endpoint URL |
| `--chain-id` | Chain ID (e.g., `injective-1` for mainnet) |
| `--start-block` | Starting block height |
| `--stop-block` | Stop at this block |

## Advertise Configuration

| Network | Chain Name | Block ID Encoding |
|---------|------------|-------------------|
| Injective Mainnet | `injective-mainnet` | `hex` |
| Injective Testnet | `injective-testnet` | `hex` |

```bash
--advertise-chain-name="injective-mainnet" \
--advertise-block-id-encoding="hex"
```

## Performance Considerations

- RPC polling is slower than native Firehose instrumentation
- Use a dedicated RPC endpoint for better performance
- Consider running your own Injective node for best results

## Resources

- [firehose-cosmos GitHub](https://github.com/streamingfast/firehose-cosmos)
- [Injective Documentation](https://docs.injective.network/)
- [Injective GitHub](https://github.com/InjectiveLabs)

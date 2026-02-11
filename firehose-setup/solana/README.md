---
description: Firehose chain-specific configuration for Solana
---

# Solana

This page provides Solana-specific configuration for Firehose. For general deployment instructions, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="info" %}
This guide covers only the chain-specific Reader Node configuration. For general Firehose architecture and deployment patterns, refer to the main deployment guides.
{% endhint %}

{% hint style="warning" %}
This guide does not cover how to run a Solana validator or RPC node. For node setup, hardware requirements, and network configuration, refer to the [official Solana documentation](https://docs.solana.com/).
{% endhint %}

## Architecture

Firehose for Solana uses an **RPC poller** approach rather than a Firehose-enabled node. The poller connects to a Solana RPC endpoint and converts the data into Firehose Protocol format.

```
┌──────────────┐     RPC      ┌──────────────┐     stdout    ┌──────────────┐
│  Solana RPC  │◄────────────│  RPC Poller  │──────────────►│  Reader Node │
│   Endpoint   │              │   Binary     │               │  (Firehose)  │
└──────────────┘              └──────────────┘               └──────────────┘
```

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-solana](https://github.com/streamingfast/firehose-solana) | `firesolana` |

Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-solana/releases).

## Reader Node Configuration

### RPC Endpoint Requirements

The Solana RPC endpoint must support:
- `getBlock` with full transaction details
- `getSlot` for current slot
- Historical block access for the range you need

### Basic Configuration

```bash
firesolana start reader-node \
  --reader-node-path="firesolana" \
  --reader-node-arguments="poller --rpc-endpoint=https://api.mainnet-beta.solana.com" \
  --reader-node-data-dir="./data/solana"
```

### Full Stack Example

```bash
firesolana start reader-node merger relayer firehose \
  --reader-node-path="firesolana" \
  --reader-node-arguments="poller --rpc-endpoint=${SOLANA_RPC_ENDPOINT}" \
  --reader-node-data-dir="./data/solana" \
  --common-first-streamable-block=0
```

### Key Poller Flags

| Flag | Description |
|------|-------------|
| `--rpc-endpoint` | Solana RPC endpoint URL |
| `--start-slot` | Starting slot number |
| `--stop-slot` | Stop at this slot |

## Advertise Configuration

| Network | Chain Name | Block ID Encoding |
|---------|------------|-------------------|
| Solana Mainnet | `sol-mainnet` | `base58` |
| Solana Devnet | `sol-devnet` | `base58` |

```bash
--advertise-chain-name="sol-mainnet" \
--advertise-block-id-encoding="base58"
```

## Performance Considerations

- RPC polling is slower than native Firehose instrumentation
- Use a dedicated RPC endpoint for better performance
- Consider rate limits on public RPC endpoints

## Resources

- [firehose-solana GitHub](https://github.com/streamingfast/firehose-solana)
- [Solana Documentation](https://docs.solana.com/)
- [Solana RPC API](https://docs.solana.com/api)

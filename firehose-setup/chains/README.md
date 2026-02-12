---
description: Chain-specific Firehose configuration guides
---

# Chain Specific

This section contains chain-specific configuration guides for Firehose. Each guide covers the Reader Node configuration required to extract blockchain data for that particular chain.

Before reading these guides, ensure you understand the general deployment concepts from:
- [Single Machine Deployment](../single-machine-deployment.md) - For development or small-scale deployments
- [Distributed Deployment](../distributed-deployment.md) - For production deployments

## Supported Chains

### EVM Chains

Ethereum and EVM-compatible chains use `fireeth` and share similar configuration patterns:

| Chain | Type | Notes |
|-------|------|-------|
| [Ethereum](../ethereum/README.md) | Native Firehose | Mainnet, Sepolia, Hoodi |
| [Arbitrum](../ethereum/arbitrum.md) | Native Firehose | Requires L1 connection |
| [Base](../ethereum/base.md) | Native Firehose | OP Stack, requires OP Node |
| [BNB Smart Chain](../ethereum/bsc.md) | Native Firehose | BSC Geth fork |
| [Katana](../ethereum/katana.md) | Native Firehose | OP Stack |
| [Optimism](../ethereum/optimism.md) | Native Firehose | OP Stack, requires OP Node |
| [Polygon](../ethereum/polygon.md) | Native Firehose | Bor client |
| [Unichain](../ethereum/unichain.md) | Native Firehose | OP Stack |
| [Worldchain](../ethereum/worldchain.md) | Native Firehose | OP Stack |
| [Avalanche](../avalanche/README.md) | RPC Poller | C-Chain via RPC |
| [Sei](../sei/README.md) | Native Firehose | Cosmos SDK + EVM |

### Non-EVM Chains

These chains use `firecore` with chain-specific binaries:

| Chain | Type | Notes |
|-------|------|-------|
| [Injective](../injective/README.md) | RPC Poller | Cosmos SDK chain |
| [NEAR](../near/README.md) | Native Firehose | NEAR Protocol |
| [Solana](../solana/README.md) | Geyser Plugin | Solana validator plugin |
| [Starknet](../starknet/README.md) | RPC Poller | Requires Ethereum L1 RPC |
| [Stellar](../stellar/README.md) | RPC Poller | Soroban RPC |
| [Tron](../tron/README.md) | RPC Poller | Native and EVM formats |

## Integration Types

### Native Firehose

Chains with native Firehose instrumentation have a patched blockchain client that outputs block data in Firehose format. This provides the most complete data extraction.

### RPC Poller

For chains without native instrumentation, an RPC poller fetches blocks from standard RPC endpoints. You can use your own node or an RPC provider.

### Geyser Plugin

Solana uses a Geyser plugin that hooks into the validator to extract block data.

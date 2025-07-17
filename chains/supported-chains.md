---
description: Overview of blockchain networks supported by Firehose
---

# Supported Chains

## Overview

Firehose supports a wide range of blockchain networks through a combination of universal components and chain-specific reader implementations. This page provides an overview of all supported chains and their specific characteristics.

## Chain Categories

### Production Ready

These chains have mature Firehose implementations with full production support:

#### Ethereum and EVM-Compatible Chains
- **[Ethereum](ethereum/README.md)** - Uses specialized `fireeth` binary
- **Polygon** - EVM-compatible, uses `firecore`
- **Binance Smart Chain (BSC)** - EVM-compatible, uses `firecore`
- **Avalanche C-Chain** - EVM-compatible, uses `firecore`

#### Layer 1 Blockchains
- **[Solana](solana/README.md)** - High-performance blockchain
- **[NEAR](near/README.md)** - Sharded proof-of-stake blockchain
- **[Cosmos Hub](cosmos/README.md)** - Cosmos SDK-based chain

#### Cosmos Ecosystem
- **[Injective](injective/README.md)** - Decentralized exchange protocol
- **Osmosis** - AMM protocol in Cosmos
- **Juno** - Smart contract platform

### Community Supported

These chains are maintained by the community with StreamingFast guidance:

- **[Starknet](../community-integrations/starknet/README.md)** - Layer 2 scaling solution
- **Aptos** - Move-based blockchain
- **Sui** - Move-based blockchain

### Experimental/Beta

These chains have basic support but may require additional development:

- **Bitcoin** - Basic block streaming support
- **Tron** - TRON network support
- **Stellar** - Stellar network support

## Binary Usage by Chain

### firecore (Universal Binary)

Most chains use the universal `firecore` binary:

```bash
# Standard usage for most chains
firecore start reader-node --reader-node-path=/path/to/node
```

**Chains using firecore:**
- Solana
- NEAR
- Cosmos Hub
- Injective
- Polygon
- BSC
- Avalanche
- Most other supported chains

### fireeth (Ethereum-Specific Binary)

Ethereum and some EVM chains use the specialized `fireeth` binary:

```bash
# Ethereum-specific usage
fireeth start reader-node --reader-node-path=/path/to/geth
```

**Chains using fireeth:**
- Ethereum Mainnet
- Ethereum Testnets (Goerli, Sepolia)
- Some EVM-compatible chains (check chain-specific docs)

## Chain-Specific Differences

While 90% of Firehose functionality is universal, chains differ in these areas:

### Reader Node Configuration
- **Node binary path** - Each chain uses different node software
- **Node arguments** - Chain-specific flags and configuration
- **Data extraction method** - How blocks are read from the node

### Block Structure
- **Block format** - Native block structure varies by chain
- **Transaction format** - Different transaction types and fields
- **Event/Log format** - Chain-specific event structures

### Network Configuration
- **Genesis block** - Chain initialization parameters
- **Consensus mechanism** - Proof-of-work, proof-of-stake, etc.
- **Block time** - Average time between blocks

## Getting Started by Chain

### For Ethereum
1. Install `fireeth` binary
2. Set up Geth or other Ethereum client
3. Follow [Ethereum Deployment Guide](ethereum/deployment.md)

### For Other Chains
1. Install `firecore` binary
2. Set up the chain's node software
3. Follow the chain-specific deployment guide
4. Configure chain-specific reader arguments

## Node Requirements by Chain

| Chain | Node Software | Minimum Version | Special Requirements |
|-------|---------------|-----------------|---------------------|
| Ethereum | Geth, Erigon, Nethermind | Geth 1.10+ | Archive node recommended |
| Solana | Solana Labs | 1.14+ | RPC enabled |
| NEAR | nearcore | 1.28+ | Archival node |
| Cosmos Hub | Gaiad | 7.0+ | Tendermint instrumentation |
| Injective | Injective Core | 1.10+ | Cosmos SDK instrumentation |

## Storage Requirements

Storage needs vary significantly by chain:

### High-Volume Chains
- **Ethereum**: ~500GB/month for merged blocks
- **Solana**: ~1TB/month for merged blocks
- **Polygon**: ~200GB/month for merged blocks

### Medium-Volume Chains
- **NEAR**: ~100GB/month for merged blocks
- **Cosmos Hub**: ~50GB/month for merged blocks
- **Injective**: ~30GB/month for merged blocks

### Low-Volume Chains
- **Most Cosmos chains**: ~10-50GB/month for merged blocks

## Performance Characteristics

### Block Processing Speed
- **Ethereum**: ~15 blocks/minute
- **Solana**: ~150 blocks/minute
- **NEAR**: ~60 blocks/minute
- **Cosmos chains**: ~300 blocks/minute

### Typical Latency
- **Real-time streaming**: 100-500ms behind chain head
- **Historical data**: Depends on storage backend
- **Merged block availability**: 2-10 minutes after block production

## Integration Status

### ✅ Fully Supported
- Complete Firehose integration
- Production-ready
- Full documentation
- Active maintenance

### 🔄 In Development
- Basic functionality working
- Documentation in progress
- May have limitations
- Community contributions welcome

### 📋 Planned
- Integration planned
- Community interest expressed
- Seeking maintainers

## Adding New Chains

Interested in adding support for a new blockchain? See:

- [Integration Overview](../integrate-new-chains/integration-overview.md)
- [Integration Template](../integrate-new-chains/integration-template.md)
- [Firehose Acme Example](../integrate-new-chains/firehose-starter.md)

## Support and Community

- **Discord**: [StreamingFast Discord](https://discord.gg/jZwqxJAvRs)
- **GitHub**: [Firehose Core](https://github.com/streamingfast/firehose-core)
- **Documentation**: Chain-specific guides in this section

## Next Steps

1. Choose your blockchain from the list above
2. Follow the chain-specific setup guide
3. Review the [Core Deployment Guide](../core/deployment-guide.md)
4. Join the community for support and updates

---
description: Firehose implementation for Ethereum blockchain
---

# Ethereum

## Overview

Ethereum is the first blockchain to receive Firehose support and has a specialized implementation using the `fireeth` binary. This binary extends the universal `firecore` functionality with Ethereum-specific features and optimizations.

## Key Differences from Other Chains

### Specialized Binary
- Uses `fireeth` instead of `firecore`
- Includes Ethereum-specific block processing
- Optimized for EVM transaction and log handling
- Enhanced support for Ethereum's uncle blocks and reorgs

### Supported Node Clients
- **Geth** (Go Ethereum) - Primary support
- **Erigon** - Full support
- **Nethermind** - Supported
- **Besu** - Basic support

## Quick Start

### 1. Install fireeth Binary

```bash
# Download latest release
wget https://github.com/streamingfast/firehose-ethereum/releases/latest/download/fireeth
chmod +x fireeth
sudo mv fireeth /usr/local/bin/
```

### 2. Set Up Ethereum Node

```bash
# Example with Geth
geth --datadir=/var/ethereum-data \
     --http \
     --http.api=eth,net,web3 \
     --ws \
     --ws.api=eth,net,web3 \
     --syncmode=full
```

### 3. Configure Firehose

```yaml
# ethereum-firehose.yaml
start:
  args:
    - reader-node
  flags:
    data-dir: /var/firehose-data
    reader-node-path: /usr/local/bin/geth
    reader-node-arguments: "--datadir=/var/ethereum-data --firehose-enabled"
```

### 4. Start Firehose

```bash
fireeth start reader-node --config-file=ethereum-firehose.yaml
```

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Geth Node     │    │   fireeth       │    │   Storage       │
│                 │    │   Components    │    │                 │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │ Blockchain  │ │    │ │   Reader    │ │    │ │ Block Files │ │
│ │ Processing  │─┼────┼─│   Merger    │─┼────┼─│ (Ethereum   │ │
│ │             │ │    │ │   Relayer   │ │    │ │  Format)    │ │
│ │ Firehose    │ │    │ │ gRPC Server │ │    │ │             │ │
│ │ Hooks       │ │    │ └─────────────┘ │    │ └─────────────┘ │
│ └─────────────┘ │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Ethereum-Specific Features

### Enhanced Block Processing
- Full EVM transaction trace support
- Uncle block handling
- Reorg detection and management
- Gas usage tracking

### Transaction Analysis
- Contract creation detection
- Internal transaction tracking
- Event log parsing
- ERC token transfer detection

### Performance Optimizations
- Parallel block processing
- Efficient storage for Ethereum data structures
- Optimized for high transaction throughput

## Configuration

See the following sections for detailed configuration:

- **[fireeth Binary](fireeth-binary.md)** - Complete CLI reference
- **[Ethereum-Specific Flags](flags.md)** - Additional flags beyond firecore
- **[Node Configuration](node-configuration.md)** - Setting up Ethereum nodes
- **[Deployment Guide](deployment.md)** - Production deployment

## Storage Requirements

### Mainnet
- **One-block files**: ~2GB/day
- **Merged blocks**: ~50GB/month
- **Full archive**: ~2TB/year

### Testnets
- **Goerli**: ~10GB/month
- **Sepolia**: ~5GB/month

## Performance Characteristics

### Block Processing
- **Average block time**: 12 seconds
- **Processing latency**: <1 second
- **Throughput**: ~7,000 transactions/block

### Resource Usage
- **CPU**: 2-4 cores recommended
- **Memory**: 8GB minimum, 16GB recommended
- **Storage**: SSD required for optimal performance
- **Network**: 100Mbps+ for real-time sync

## Common Use Cases

### DeFi Applications
- DEX transaction monitoring
- Lending protocol analysis
- Yield farming tracking
- Arbitrage opportunity detection

### NFT Platforms
- Mint event tracking
- Transfer monitoring
- Marketplace analysis
- Rarity calculation

### Infrastructure
- Block explorer backends
- Wallet transaction history
- Analytics platforms
- Compliance monitoring

## Troubleshooting

### Common Issues

#### Node Sync Problems
```bash
# Check node sync status
fireeth tools check-node-sync --node-url=http://localhost:8545
```

#### Block Processing Delays
```bash
# Monitor processing pipeline
fireeth tools monitor-pipeline --data-dir=/var/firehose-data
```

#### Storage Issues
```bash
# Verify block file integrity
fireeth tools verify-blocks --start-block=1000000 --stop-block=1001000
```

## Migration from Other Systems

### From Graph Node
- Export existing subgraph mappings
- Convert to Substreams modules
- Test with historical data
- Deploy to production

### From Custom Indexers
- Identify data extraction patterns
- Map to Firehose block structure
- Implement using Substreams
- Validate data consistency

## Next Steps

1. Follow the [Deployment Guide](deployment.md) for production setup
2. Learn about [Ethereum-Specific Flags](flags.md)
3. Configure your [Node Setup](node-configuration.md)
4. Explore the [fireeth Binary](fireeth-binary.md) reference

## Support

- **Ethereum-specific issues**: [firehose-ethereum repository](https://github.com/streamingfast/firehose-ethereum)
- **General Firehose support**: [StreamingFast Discord](https://discord.gg/jZwqxJAvRs)
- **Documentation feedback**: [firehose-docs repository](https://github.com/streamingfast/firehose-docs)

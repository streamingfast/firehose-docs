---
description: Quick start guide for getting Firehose up and running
---

# Quick Start Guide

## Overview

This guide will get you up and running with Firehose in under 30 minutes. We'll set up a basic Firehose deployment that can stream blockchain data from your chosen network.

## Prerequisites

Before starting, ensure you have:

- A supported blockchain node running and synced
- At least 4GB RAM and 2 CPU cores available
- 100GB+ free disk space for data storage
- Basic familiarity with command-line tools

## Step 1: Choose Your Blockchain

Select the blockchain you want to work with:

### Ethereum
- **Binary**: `fireeth`
- **Node**: Geth, Erigon, or Nethermind
- **Special requirements**: Archive node recommended

### Solana
- **Binary**: `firecore`
- **Node**: Solana Labs validator
- **Special requirements**: RPC enabled

### NEAR
- **Binary**: `firecore`
- **Node**: nearcore
- **Special requirements**: Archival node

### Cosmos Chains
- **Binary**: `firecore`
- **Node**: Chain-specific (gaiad, injective-core, etc.)
- **Special requirements**: Tendermint instrumentation

## Step 2: Install Firehose Binary

### For Ethereum
```bash
wget https://github.com/streamingfast/firehose-ethereum/releases/latest/download/fireeth
chmod +x fireeth
sudo mv fireeth /usr/local/bin/
```

### For Other Chains
```bash
wget https://github.com/streamingfast/firehose-core/releases/latest/download/firecore
chmod +x firecore
sudo mv firecore /usr/local/bin/
```

## Step 3: Prepare Your Node

Ensure your blockchain node is running with the correct configuration:

### Ethereum (Geth example)
```bash
geth --datadir=/var/ethereum-data \
     --http \
     --http.api=eth,net,web3 \
     --ws \
     --ws.api=eth,net,web3 \
     --syncmode=full
```

### Solana
```bash
solana-validator --ledger /var/solana-data \
                 --rpc-port 8899 \
                 --enable-rpc-transaction-history \
                 --enable-extended-tx-metadata-storage
```

### NEAR
```bash
nearcore --home-dir /var/near-data \
         --archive \
         --rpc-addr 0.0.0.0:3030
```

## Step 4: Create Configuration

Create a basic configuration file:

### Ethereum
```yaml
# ethereum-firehose.yaml
start:
  args:
    - reader-node
  flags:
    data-dir: /var/firehose-data
    reader-node-path: /usr/local/bin/geth
    reader-node-arguments: "--datadir=/var/ethereum-data --firehose-enabled"
    common-one-block-store-url: file:///var/firehose-data/one-blocks
    common-merged-blocks-store-url: file:///var/firehose-data/merged-blocks
```

### Other Chains
```yaml
# firehose.yaml
start:
  args:
    - reader-node
  flags:
    data-dir: /var/firehose-data
    reader-node-path: /usr/local/bin/your-node-binary
    reader-node-arguments: "--your-node-flags"
    common-one-block-store-url: file:///var/firehose-data/one-blocks
    common-merged-blocks-store-url: file:///var/firehose-data/merged-blocks
```

## Step 5: Start Firehose Components

Start the components in order:

### 1. Start Reader Node
```bash
# For Ethereum
fireeth start reader-node --config-file=ethereum-firehose.yaml

# For other chains
firecore start reader-node --config-file=firehose.yaml
```

### 2. Start Merger (in a new terminal)
```bash
# For Ethereum
fireeth start merger --config-file=ethereum-firehose.yaml

# For other chains
firecore start merger --config-file=firehose.yaml
```

### 3. Start Relayer (in a new terminal)
```bash
# For Ethereum
fireeth start relayer --config-file=ethereum-firehose.yaml

# For other chains
firecore start relayer --config-file=firehose.yaml
```

### 4. Start gRPC Server (in a new terminal)
```bash
# For Ethereum
fireeth start firehose --config-file=ethereum-firehose.yaml

# For other chains
firecore start firehose --config-file=firehose.yaml
```

## Step 6: Verify Installation

Test that Firehose is working:

### Check Component Status
```bash
# Check if components are running
ps aux | grep fire

# Check logs
tail -f /var/firehose-data/firehose.log
```

### Test gRPC Endpoint
```bash
# Install grpcurl if not available
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# Test the endpoint
grpcurl -plaintext localhost:13042 sf.firehose.v2.Stream/Blocks
```

### Monitor Metrics
```bash
# Check Prometheus metrics
curl http://localhost:9102/metrics
```

## Step 7: Stream Some Blocks

Create a simple test to stream blocks:

```bash
# Stream the latest 10 blocks
grpcurl -plaintext -d '{
  "start_block_num": -10,
  "stop_block_num": 0
}' localhost:13042 sf.firehose.v2.Stream/Blocks
```

## What's Next?

Now that you have Firehose running:

### For Development
1. **Explore the API**: Learn about the gRPC streaming interface
2. **Build a Substream**: Create custom data processing logic
3. **Integrate with your app**: Connect your application to Firehose

### For Production
1. **Review [Production Deployment](../core/deployment/production.md)**: Scale for production use
2. **Set up monitoring**: Implement proper observability
3. **Configure storage**: Move to cloud storage for scalability

### Learn More
- **[Core Architecture](../core/architecture.md)**: Understand how Firehose works
- **[CLI Reference](../core/cli-reference.md)**: Learn all available commands
- **[Chain-Specific Guides](../chains/supported-chains.md)**: Deep dive into your blockchain

## Troubleshooting

### Common Issues

#### Reader Node Won't Start
- Verify your blockchain node is running and accessible
- Check the node path and arguments in your configuration
- Ensure the node has the required APIs enabled

#### No Blocks Being Processed
- Check that your blockchain node is synced
- Verify the reader node can connect to your blockchain node
- Monitor the logs for error messages

#### gRPC Server Not Responding
- Ensure all components are running (reader, merger, relayer)
- Check that the gRPC port (13042) is not blocked
- Verify the merged blocks store has data

#### High Resource Usage
- Monitor disk I/O and available space
- Consider using SSD storage for better performance
- Adjust component resource limits if needed

## Getting Help

- **Documentation**: Continue reading the detailed guides in this documentation
- **Discord**: Join the [StreamingFast Discord](https://discord.gg/jZwqxJAvRs) for community support
- **GitHub**: Report issues on the relevant repository
- **Examples**: Check out example configurations and code samples

Congratulations! You now have Firehose running and streaming blockchain data. 🎉

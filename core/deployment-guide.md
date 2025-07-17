---
description: Comprehensive deployment guide for Firehose operators
---

# Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying Firehose in production environments. It covers the universal deployment patterns that apply to all blockchain implementations.

## Prerequisites

Before deploying Firehose, ensure you have:

- A supported blockchain node (see [Chain-Specific Implementations](../chains/supported-chains.md))
- Adequate system resources (see [System Requirements](deployment/system-requirements.md))
- Storage infrastructure (local, cloud, or distributed)
- Monitoring and observability tools

## Deployment Architecture

### Single-Machine Deployment

For development, testing, or small-scale operations:

```
┌─────────────────────────────────────────┐
│              Single Machine             │
├─────────────────────────────────────────┤
│  Blockchain Node  │  Firehose Stack    │
│  ┌─────────────┐   │  ┌──────────────┐  │
│  │   Node      │   │  │ Reader       │  │
│  │   Process   │───┼──│ Merger       │  │
│  │             │   │  │ Relayer      │  │
│  └─────────────┘   │  │ gRPC Server  │  │
│                    │  └──────────────┘  │
└─────────────────────────────────────────┘
```

### Production Deployment

For high availability and scalability:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Blockchain     │    │   Firehose      │    │   Storage &     │
│  Nodes          │    │   Processing    │    │   Serving       │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │   Node 1    │ │    │ │  Reader 1   │ │    │ │   Storage   │ │
│ │   Node 2    │─┼────┼─│  Reader 2   │─┼────┼─│   (Cloud)   │ │
│ │   Node 3    │ │    │ │   Merger    │ │    │ │             │ │
│ └─────────────┘ │    │ │   Relayer   │ │    │ └─────────────┘ │
│                 │    │ └─────────────┘ │    │ ┌─────────────┐ │
│                 │    │                 │    │ │ gRPC Server │ │
│                 │    │                 │    │ │  (Load Bal) │ │
│                 │    │                 │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Quick Start

### 1. Install Firehose Binary

Download the appropriate binary for your blockchain:

```bash
# For most chains (replace with your chain's binary)
wget https://github.com/streamingfast/firehose-core/releases/latest/download/firecore
chmod +x firecore

# For Ethereum
wget https://github.com/streamingfast/firehose-ethereum/releases/latest/download/fireeth
chmod +x fireeth
```

### 2. Prepare Configuration

Create a basic configuration file:

```yaml
# firehose.yaml
start:
  args:
    - reader-node
  flags:
    data-dir: /var/firehose-data
    common-one-block-store-url: file:///var/firehose-data/storage/one-blocks
    common-merged-blocks-store-url: file:///var/firehose-data/storage/merged-blocks
    reader-node-path: /usr/local/bin/your-node-binary
    reader-node-arguments: "--your-node-flags"
```

### 3. Start Reader Node

Begin extracting blockchain data:

```bash
firecore start reader-node --config-file=firehose.yaml
```

### 4. Start Additional Components

In separate terminals or as services:

```bash
# Start merger (combines block files)
firecore start merger --config-file=firehose.yaml

# Start relayer (real-time streaming)
firecore start relayer --config-file=firehose.yaml

# Start gRPC server (API endpoint)
firecore start firehose --config-file=firehose.yaml
```

## Component Deployment Order

Deploy components in this recommended order:

1. **Reader Node** - Start data extraction first
2. **Merger** - Begin combining block files
3. **Relayer** - Enable real-time streaming
4. **gRPC Server** - Expose API endpoints
5. **Substreams** (optional) - Add processing capabilities

## Storage Configuration

### Local Storage

For development or single-machine deployments:

```yaml
common-one-block-store-url: file:///var/firehose-data/one-blocks
common-merged-blocks-store-url: file:///var/firehose-data/merged-blocks
```

### Cloud Storage

For production deployments:

```yaml
# Google Cloud Storage
common-one-block-store-url: gs://your-bucket/one-blocks
common-merged-blocks-store-url: gs://your-bucket/merged-blocks

# AWS S3
common-one-block-store-url: s3://your-bucket/one-blocks
common-merged-blocks-store-url: s3://your-bucket/merged-blocks

# Azure Blob Storage
common-one-block-store-url: az://your-container/one-blocks
common-merged-blocks-store-url: az://your-container/merged-blocks
```

## High Availability Setup

### Multiple Readers

Run multiple reader instances for redundancy:

```yaml
# Reader 1
reader-node-grpc-listen-addr: :13010
reader-node-manager-api-addr: :13011

# Reader 2  
reader-node-grpc-listen-addr: :13020
reader-node-manager-api-addr: :13021
```

### Load Balancing

Configure relayer to connect to multiple readers:

```yaml
relayer-source: reader1:13010,reader2:13020
```

## Security Considerations

### Network Security
- Use TLS for gRPC connections in production
- Implement proper firewall rules
- Consider VPN or private networks for internal communication

### Authentication
- Configure authentication for gRPC endpoints
- Use service accounts for cloud storage access
- Implement proper access controls

### Data Protection
- Encrypt data at rest in cloud storage
- Use encrypted connections for data transfer
- Implement backup and disaster recovery procedures

## Monitoring and Observability

### Metrics

Firehose exposes Prometheus metrics on port 9102 by default:

```yaml
metrics-listen-addr: :9102
```

Key metrics to monitor:
- Block processing rate
- Storage usage
- Component health status
- gRPC request latency

### Logging

Configure structured logging:

```yaml
log-format: stackdriver  # For cloud environments
log-to-file: true
log-verbosity: 1
```

### Health Checks

Implement health checks for each component:
- Reader node connectivity
- Storage accessibility
- gRPC server responsiveness

## Troubleshooting

Common issues and solutions:

### Reader Node Issues
- Verify blockchain node is running and accessible
- Check reader node path and arguments
- Monitor disk space and I/O performance

### Storage Issues
- Verify storage URLs and credentials
- Check network connectivity to storage
- Monitor storage quotas and limits

### Performance Issues
- Scale horizontally with multiple readers
- Optimize storage configuration
- Monitor system resources

## Next Steps

- Review [System Requirements](deployment/system-requirements.md) for detailed specifications
- Learn about [Infrastructure Setup](deployment/infrastructure.md) for cloud deployments
- Explore [Production Deployment](deployment/production.md) best practices
- Set up [Monitoring & Observability](deployment/monitoring.md)
- Check [Troubleshooting](deployment/troubleshooting.md) for common issues

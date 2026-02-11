---
description: Firehose architecture overview and core concepts
---

# Architecture

## Overview

Firehose is a distributed system designed to extract, process, and serve blockchain data at scale. This section covers the core architectural concepts that apply to all blockchain implementations.

## Core Principles

### Chain-Agnostic Design
- **90% Universal**: Core components work across all blockchains
- **10% Chain-Specific**: Only reader nodes differ between chains
- **Consistent Interface**: Same gRPC API regardless of blockchain

### Scalable Architecture
- **Horizontal Scaling**: Add more components as needed
- **Component Isolation**: Each service can be scaled independently
- **Storage Flexibility**: Support for local, cloud, and distributed storage

### Real-Time Processing
- **Live Streaming**: Sub-second latency for new blocks
- **Historical Access**: Efficient querying of past data
- **Fault Tolerance**: Automatic recovery from failures

## System Components

The Firehose system consists of several key components that work together to provide a complete blockchain data pipeline:

### [Components Overview](components/README.md)
Detailed information about each component in the Firehose stack:
- **[Reader Node](components/reader.md)** - Wraps blockchain nodes and extracts block data
- **[Merger](components/merger.md)** - Combines individual blocks into larger files
- **[Relayer](components/relayer.md)** - Provides real-time streaming and high availability
- **[gRPC Server](components/grpc-server.md)** - Serves the Firehose API to clients
- **[Substreams](components/substreams.md)** - High-performance parallel data transformation engine
- **[High Availability](components/high-availability.md)** - Redundancy and failover strategies

### [Data Flow](data-flow.md)
Understanding how data moves through the Firehose system from blockchain nodes to client applications.

### [Data Storage](data-storage.md)
Storage patterns, formats, and strategies used by Firehose for different types of blockchain data.

## Deployment Patterns

### Single-Machine Deployment
All components running on one machine for development or small-scale use:

```
┌─────────────────────────────────────────┐
│              Single Machine             │
├─────────────────────────────────────────┤
│  Reader Process    │  Firehose Stack    │
│  ┌─────────────┐   │  ┌──────────────┐  │
│  │   Node      │   │  │ Reader       │  │
│  │ (subprocess)│───┼──│ Merger       │  │
│  │             │   │  │ Relayer      │  │
│  └─────────────┘   │  │ Firehose &   │  │
│                    │  │ Substreams   │  │
│                    │  └──────────────┘  │
└─────────────────────────────────────────┘
```

{% hint style="info" %}
The blockchain node runs as a subprocess of the Reader component, which manages the node's lifecycle and extracts block data.
{% endhint %}

### Distributed Deployment
Components spread across multiple machines for production scale:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Reader         │    │   Firehose      │    │   Storage &     │
│  Processes      │    │   Processing    │    │   Serving       │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │Node1(subproc│ │    │ │  Reader 1   │ │    │ │   Storage   │ │
│ │Node2(subproc│─┼────┼─│  Reader 2   │─┼────┼─│   (Cloud)   │ │
│ │Node3(subproc│ │    │ │   Merger    │ │    │ │             │ │
│ └─────────────┘ │    │ │   Relayer   │ │    │ └─────────────┘ │
│                 │    │ └─────────────┘ │    │ ┌─────────────┐ │
│                 │    │                 │    │ │ Firehose &  │ │
│                 │    │                 │    │ │ Substreams  │ │
│                 │    │                 │    │ │ (via gRPC)  │ │
│                 │    │                 │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Key Features

### Universal Block Format
- Consistent protobuf schemas across chains
- Rich metadata and transaction details
- Efficient binary serialization

### Streaming API
- gRPC-based streaming interface
- Real-time and historical data access
- Fork-aware streaming with automatic reorg handling
- Cursor-based resumption for reliable data delivery
- Filtering and transformation capabilities

### Storage Efficiency
- Compressed block files
- Incremental merging strategy
- Cloud storage integration

### Operational Excellence
- Comprehensive metrics and monitoring
- Automated recovery mechanisms
- Horizontal scaling capabilities

## Next Steps

- **[Components](components/README.md)**: Learn about individual system components
- **[Data Flow](data-flow.md)**: Understand how data moves through the system
- **[Data Storage](data-storage.md)**: Explore storage patterns and formats
- **[CLI Reference](../core/cli-reference.md)**: Learn how to operate Firehose
- **[Deployment Guide](../core/deployment-guide.md)**: Deploy Firehose in production

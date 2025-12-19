# Distributed Deployment

This guide shows how to deploy Firehose components as separate processes using shared object storage. This approach is recommended for production environments where you need scalability, high availability, and proper service isolation.

## Overview

In this deployment, each component (`reader-node`, `merger`, `relayer`, `firehose`, `substreams-tier1`, `substreams-tier2`) runs as a separate process. Components communicate through shared object storage and gRPC endpoints.

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Reader         │    │   Processing    │    │   Serving       │
│  Process        │    │   Components    │    │   Components    │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │dummy-blockchain│    │ │   Merger    │ │    │ │  Firehose   │ │
│ │ (subprocess)│ │    │ │   Relayer   │ │    │ │ Substreams  │ │
│ │   Reader    │ │    │ │             │ │    │ │ (Tier1&2)   │ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ Shared Object   │
                    │ Storage         │
                    │ (Cloud Storage) │
                    └─────────────────┘
```

{% hint style="info" %}
While this guide shows all components running on a single machine for simplicity, in production you would typically deploy these across multiple machines with proper ingress, DNS, and service discovery.
{% endhint %}

## Prerequisites

1. **Shared Object Storage**: Set up cloud storage (AWS S3, Google Cloud Storage, etc.)
2. **Binaries**: Install `firecore` and `dummy-blockchain` as described in [Prerequisites](overview.md#prerequisites)

## Storage Configuration

First, configure your shared object storage. For this example, we'll use a local filesystem path that simulates cloud storage:

```bash
# Create shared storage directory (in production, this would be cloud storage)
mkdir -p /shared-storage/firehose-data
export SHARED_STORAGE_URL="file:///shared-storage/firehose-data"

# For cloud storage, you would use URLs like:
# export SHARED_STORAGE_URL="gs://your-bucket/firehose-data"
# export SHARED_STORAGE_URL="s3://your-bucket/firehose-data"
```

## Component 1: Reader Node

The Reader manages the blockchain node and extracts block data.

```bash
# Terminal 1: Start the Reader
firecore start reader-node \
  --config-file="" \
  --data-dir="./reader-data" \
  --advertise-block-id-encoding="hex" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --reader-node-path="dummy-blockchain" \
  --reader-node-data-dir="./reader-data/node" \
  --reader-node-arguments="start --tracer=firehose --store-dir=./reader-data/node --block-rate=120 --genesis-height=0 --genesis-block-burst=100" \
  --common-one-block-store-url="${SHARED_STORAGE_URL}/one-blocks" \
  --reader-node-grpc-listen-addr=":10010"
```

{% hint style="info" %}
The Reader runs the `dummy-blockchain` as a subprocess and extracts block data to shared storage. See [Reader Component](../architecture/components/reader.md) for details.
{% endhint %}

### Verify Reader Operation

```bash
# Check that one-block files are being created
ls /shared-storage/firehose-data/one-blocks/

# Inspect a one-block file
firecore tools print one-block /shared-storage/firehose-data/one-blocks 1 --output=text
```

## Component 2: Merger

The Merger combines one-block files into merged block files for efficient storage.

```bash
# Terminal 2: Start the Merger
firecore start merger \
  --config-file="" \
  --data-dir="./merger-data" \
  --advertise-block-id-encoding="hex" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --common-one-block-store-url="${SHARED_STORAGE_URL}/one-blocks" \
  --common-merged-blocks-store-url="${SHARED_STORAGE_URL}/merged-blocks" \
  --merger-grpc-listen-addr=":10011"
```

{% hint style="info" %}
The Merger processes one-block files from shared storage and creates optimized merged block files. Learn more about [Merger Component](../architecture/components/merger.md).
{% endhint %}

### Verify Merger Operation

```bash
# Check that merged block files are being created
ls /shared-storage/firehose-data/merged-blocks/

# Inspect a merged block file
firecore tools print merged-blocks /shared-storage/firehose-data/merged-blocks 100 --output=text
```

## Component 3: Relayer

The Relayer provides live block streaming capabilities.

```bash
# Terminal 3: Start the Relayer
firecore start relayer \
  --config-file="" \
  --data-dir="./relayer-data" \
  --advertise-block-id-encoding="hex" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --common-one-block-store-url="${SHARED_STORAGE_URL}/one-blocks" \
  --relayer-grpc-listen-addr=":10012" \
  --relayer-source="reader-node:localhost:10010"
```

{% hint style="info" %}
The Relayer connects to the Reader to stream live blocks and provides real-time data access. See [Relayer Component](../architecture/components/relayer.md) for more details.
{% endhint %}

### Verify Relayer Operation

```bash
# Stream live blocks from the relayer
firecore tools relayer stream localhost:10012 -o text +3
```

## Component 4: Firehose

The Firehose component serves historical and live block data via gRPC.

```bash
# Terminal 4: Start Firehose
firecore start firehose \
  --config-file="" \
  --data-dir="./firehose-data" \
  --advertise-block-id-encoding="hex" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --common-one-block-store-url="${SHARED_STORAGE_URL}/one-blocks" \
  --common-merged-blocks-store-url="${SHARED_STORAGE_URL}/merged-blocks" \
  --firehose-grpc-listen-addr=":10015" \
  --relayer-addr="localhost:10012"
```

### Verify Firehose Operation

```bash
# Test the Firehose gRPC API
grpcurl -plaintext -d '{"start_block_num": 1, "stop_block_num": 5}' \
  localhost:10015 sf.firehose.v2.Stream/Blocks
```

## Component 5: Substreams Tier 1

Substreams Tier 1 handles data transformation and filtering.

```bash
# Terminal 5: Start Substreams Tier 1
firecore start substreams-tier1 \
  --config-file="" \
  --data-dir="./substreams-tier1-data" \
  --advertise-block-id-encoding="hex" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --common-one-block-store-url="${SHARED_STORAGE_URL}/one-blocks" \
  --common-merged-blocks-store-url="${SHARED_STORAGE_URL}/merged-blocks" \
  --substreams-tier1-grpc-listen-addr=":10016" \
  --relayer-addr="localhost:10012"
```

## Component 6: Substreams Tier 2

Substreams Tier 2 provides additional processing capabilities and caching.

```bash
# Terminal 6: Start Substreams Tier 2
firecore start substreams-tier2 \
  --config-file="" \
  --data-dir="./substreams-tier2-data" \
  --advertise-block-id-encoding="hex" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --substreams-tier2-grpc-listen-addr=":10017" \
  --substreams-tier1-addr="localhost:10016"
```

### Verify Substreams Operation

```bash
# List available Substreams services
grpcurl -plaintext localhost:10016 list | grep substreams
grpcurl -plaintext localhost:10017 list | grep substreams
```

## Load Balancer / API Gateway

In production, you would typically put a load balancer or API gateway in front of your services:

```bash
# Example nginx configuration for load balancing
# upstream firehose_backend {
#     server localhost:10015;
# }
# 
# upstream substreams_backend {
#     server localhost:10016;
#     server localhost:10017;
# }
# 
# server {
#     listen 80;
#     location /firehose/ {
#         grpc_pass grpc://firehose_backend;
#     }
#     location /substreams/ {
#         grpc_pass grpc://substreams_backend;
#     }
# }
```

## Monitoring and Health Checks

Monitor each component's health:

```bash
# Check component health via gRPC health checks
grpcurl -plaintext localhost:10010 grpc.health.v1.Health/Check  # Reader
grpcurl -plaintext localhost:10011 grpc.health.v1.Health/Check  # Merger
grpcurl -plaintext localhost:10012 grpc.health.v1.Health/Check  # Relayer
grpcurl -plaintext localhost:10015 grpc.health.v1.Health/Check  # Firehose
grpcurl -plaintext localhost:10016 grpc.health.v1.Health/Check  # Substreams Tier1
grpcurl -plaintext localhost:10017 grpc.health.v1.Health/Check  # Substreams Tier2
```

## Production Considerations

### Service Discovery

In production, components need to discover each other. Consider using:

- **Kubernetes**: Service discovery via DNS
- **Consul**: Service mesh with health checking
- **AWS ELB/ALB**: Load balancing with health checks

### Storage

Replace the local filesystem with proper cloud storage:

```bash
# AWS S3
--common-one-block-store-url="s3://your-bucket/one-blocks"
--common-merged-blocks-store-url="s3://your-bucket/merged-blocks"

# Google Cloud Storage
--common-one-block-store-url="gs://your-bucket/one-blocks"
--common-merged-blocks-store-url="gs://your-bucket/merged-blocks"
```

### High Availability

For high availability:

1. **Run multiple instances** of each component
2. **Use health checks** and automatic restarts
3. **Implement proper monitoring** and alerting
4. **Use redundant storage** with replication

### Security

Secure your deployment:

1. **TLS encryption** for gRPC communications
2. **Authentication** and authorization
3. **Network segmentation** and firewalls
4. **Secrets management** for storage credentials

## Scaling

Scale components based on load:

- **Reader**: Usually one per blockchain network
- **Merger**: Can run multiple instances for different block ranges
- **Relayer**: Multiple instances for high availability
- **Firehose**: Scale horizontally based on query load
- **Substreams**: Scale both tiers based on processing needs

## Next Steps

- **Adapt for your blockchain**: Use these patterns with your target blockchain
- **Production deployment**: Implement proper orchestration (Kubernetes, Docker Swarm)
- **Monitoring**: Set up comprehensive monitoring and alerting
- **Performance tuning**: Optimize based on your specific requirements

{% hint style="success" %}
You now have a distributed Firehose deployment! This architecture can be adapted to any cloud provider or orchestration platform for production use.
{% endhint %}

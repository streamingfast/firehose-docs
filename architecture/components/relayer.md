---
description: StreamingFast Firehose Relayer component
---

# Relayer

The Relayer is the live block distribution hub of the Firehose stack. It connects to one or more Reader Nodes, consolidates their block streams, and provides a unified, deduplicated live block feed to downstream consumers including the Firehose and Substreams components.

## How Relayer Works

The Relayer creates a multiplexed connection to multiple block sources, manages their health and latency, and exposes a single gRPC endpoint that other components use to receive live blocks.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          Relayer Component                              │
│                                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                      │
│  │  Reader 1   │  │  Reader 2   │  │  Reader N   │                      │
│  │  (source)   │  │  (source)   │  │  (source)   │                      │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                      │
│         │                │                │                             │
│         └────────────────┼────────────────┘                             │
│                          ▼                                              │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                    Multiplexed Source                             │  │
│  │  • Connects to multiple Reader endpoints                          │  │
│  │  • Races sources for fastest block delivery                       │  │
│  │  • Filters lagging sources based on latency threshold             │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                          │                                              │
│                          ▼                                              │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                      ForkableHub                                  │  │
│  │  • Maintains fork-aware block graph                               │  │
│  │  • Tracks head block and time drift                               │  │
│  │  • Signals readiness when synchronized                            │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                          │                                              │
│                          ▼                                              │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                   gRPC BlockStream Server                         │  │
│  │  • Streams live blocks to Firehose, Substreams, etc.              │  │
│  │  • Same interface as Reader Node (BlockStream::Blocks)            │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                          │                                              │
│              ┌───────────┴───────────┐                                  │
│              ▼                       ▼                                  │
│        Firehose              Substreams Tier 1                          │
│        Component                                                        │
└─────────────────────────────────────────────────────────────────────────┘
```

### Source Multiplexing

The Relayer connects to multiple Reader Nodes simultaneously for:

- **Redundancy**: If one Reader fails, others continue providing blocks
- **Fork Coverage**: Different Readers may observe different forks from their network peers
- **Latency Optimization**: Sources race to deliver blocks; the fastest wins

Each source connection includes automatic reconnection and health monitoring.

### Realtime Gating

The Relayer monitors each source's latency against the `--relayer-max-source-latency` threshold:

- Sources exceeding the latency threshold are temporarily filtered out
- This prevents lagging sources from degrading overall performance
- Sources automatically rejoin when they catch up

{% hint style="info" %}
The default max source latency is very high (`999999h`) - effectively disabled. Set a reasonable value like `30s` for production deployments where you want to filter unresponsive sources.
{% endhint %}

### ForkableHub

The ForkableHub is the core data structure that:

- Maintains a fork-aware graph of recent blocks
- Tracks the current head block number and timestamp
- Calculates time drift between chain time and wall clock
- Provides readiness signaling to downstream components

The hub reads from both the live source factory (for new blocks) and one-block storage (for recent historical blocks not yet merged).

## Configuration

### Essential Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--relayer-grpc-listen-addr` | gRPC listening address | `:10014` |
| `--relayer-source` | Reader source addresses (repeatable) | `[:10010]` |
| `--common-one-block-store-url` | One-block files storage URL | `file://{data-dir}/storage/one-blocks` |

### Performance Tuning

| Flag | Description | Default |
|------|-------------|---------|
| `--relayer-max-source-latency` | Max tolerated source latency | `999999h` |
| `--relayer-source-request-burst` | Request burst size to upstream sources | (varies) |

## Connecting Multiple Sources

The `--relayer-source` flag can be specified multiple times to connect to multiple Reader Nodes:

```bash
firecore start relayer \
  --relayer-grpc-listen-addr=":10014" \
  --relayer-source="reader-1.internal:10010" \
  --relayer-source="reader-2.internal:10010" \
  --relayer-source="reader-3.internal:10010"
```

Each source is identified in logs and metrics, making it easy to diagnose issues with specific Readers.

## Health & Readiness

### Readiness Signaling

The Relayer exposes a gRPC health check endpoint with **two distinct states**:

| Status | Meaning |
|--------|---------|
| `SERVING` | Relayer is synchronized and streaming blocks |
| `NOT_SERVING` | Relayer is starting up or has lost connection to sources |

The readiness state is determined by the ForkableHub's internal ready flag, which becomes true once the hub has established a consistent view of the chain head.

### Health Check Commands

```bash
# Check current health status
grpcurl -plaintext localhost:10014 grpc.health.v1.Health/Check

# Watch for status changes (polls every 5 seconds)
grpcurl -plaintext localhost:10014 grpc.health.v1.Health/Watch
```

### Kubernetes Integration

Use the health endpoint for readiness probes:

```yaml
readinessProbe:
  exec:
    command:
      - grpcurl
      - -plaintext
      - localhost:10014
      - grpc.health.v1.Health/Check
  initialDelaySeconds: 10
  periodSeconds: 5
```

## gRPC Interface

The Relayer exposes the same `BlockStream::Blocks` interface as the Reader Node. This consistent interface allows:

- Downstream components to connect to either Reader or Relayer
- Simple failover configurations
- Uniform client code regardless of data source

```protobuf
service BlockStream {
  rpc Blocks(BlocksRequest) returns (stream Block);
}
```

Blocks are streamed with metadata including:
- Block number and hash
- Parent block information
- Fork step (new, undo, irreversible)
- Partial block indicators (when applicable)

## Operational Patterns

### Single Relayer

For simple deployments, one Relayer connects to all Readers:

```
Reader 1 ──┐
Reader 2 ──┼──► Relayer ──► Firehose
Reader 3 ──┘
```

### Regional Relayers

For geographically distributed deployments, regional Relayers can aggregate local Readers:

```
Region A:                    Region B:
Reader A1 ──┐                Reader B1 ──┐
Reader A2 ──┼──► Relayer A   Reader B2 ──┼──► Relayer B
            │                            │
            └──────────┬─────────────────┘
                       ▼
                 Global Relayer ──► Firehose
```

### Metrics

The Relayer collects and exposes metrics for:

- **Head block number**: Current chain tip
- **Time drift**: Difference between chain time and wall clock
- **Relative drift**: Block production rate variance
- **Source health**: Per-source connection status

Monitor these metrics to detect synchronization issues or lagging sources.

## Storage Access

The Relayer requires read access to one-block storage:

- **Purpose**: Bootstrap ForkableHub with recent blocks
- **Access pattern**: Read-only
- **Volume**: Only reads recent blocks, not full history

This allows the Relayer to maintain fork awareness even when starting up after all Readers have moved past certain blocks.

---
description: StreamingFast Firehose component for serving blockchain data
---

# Firehose

The Firehose component is the primary interface for clients to access blockchain data. It serves the Firehose gRPC API, providing both historical and real-time block streaming with sophisticated fork handling and cursor-based resumption.

## Overview

The Firehose component reads from multiple data sources and serves unified block streams to clients:

```
┌──────────────────────────────────────────────────────────────┐
│                         Firehose Component                   │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│   │ One-Blocks   │  │ Merged       │  │ Forked       │       │
│   │ Storage      │  │ Blocks       │  │ Blocks       │       │
│   │ (bootstrap)  │  │ (historical) │  │ (fork data)  │       │
│   └──────┬───────┘  └──────┬───────┘  └──────┬───────┘       │
│          │                 │                 │               │
│          └────────────────┬┴─────────────────┘               │
│                           ▼                                  │
│                    ┌──────────────┐       ┌──────────────┐   │
│                    │   ForkDB     │◄──────│   Relayer    │   │
│                    │              │       │ (live blocks)│   │
│                    └──────┬───────┘       └──────────────┘   │
│                           │                                  │
│                           ▼                                  │
│                    ┌──────────────┐                          │
│                    │ gRPC Stream  │──────► Clients           │
│                    │  (cursored)  │                          │
│                    └──────────────┘                          │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Data Sources

### One-Block Files (Bootstrapping)

One-block files are individual block files written by Reader components. Firehose uses these for:

- **Recent blocks**: Blocks not yet merged into 100-block bundles
- **Gap filling**: When merged blocks have gaps
- **Bootstrap scenarios**: Initial startup before merged blocks exist

### Merged Blocks (Historical Reprocessing)

Merged block files contain 100 blocks each and are the primary source for historical data:

- **Efficient historical access**: Large batch reads from object storage
- **Compressed storage**: Reduced storage costs and faster transfers
- **Parallel processing**: Multiple block ranges can be served simultaneously

### Forked Blocks (Cursor Resolution)

Forked block storage contains blocks from non-canonical chain branches:

- **Fork preservation**: All forks are kept until finality
- **Cursor resolution**: Enables resumption from any point, including forks
- **Reorg handling**: Clients can resume even after chain reorganizations

### Live Blocks (Real-Time Feed)

Live blocks come from the Relayer component:

- **Sub-second latency**: New blocks streamed immediately
- **Multiple sources**: Relayer connects to multiple Readers for redundancy
- **Seamless transition**: Automatic switch from historical to live data

## Core Features

### Fork-Aware Streaming

Firehose uses a `ForkDB` data structure that mirrors the blockchain's fork behavior:

```
Block Events:
─────────────

new 100 ─── new 101 ─── new 102 ─── new 103a
                                │
                                └── new 103b ─── undo 103a ─── new 104b

The ForkDB tracks all branches and emits appropriate events when
the canonical chain changes, allowing clients to maintain accurate
local state.
```

Each block event includes:
- **Step type**: `new`, `undo`, or `irreversible`
- **Block data**: Full block with all transactions and receipts
- **Cursor**: Unique position identifier for resumption

### Cursor-Based Resumption

Cursors enable reliable, exactly-once delivery:

```protobuf
message Cursor {
  string block_id = 1;      // Current block hash
  uint64 block_num = 2;     // Current block number
  string lib_id = 3;        // Last irreversible block hash
  uint64 lib_num = 4;       // Last irreversible block number
  string fork_step = 5;     // new, undo, or irreversible
}
```

**Resumption guarantees:**
- Resume from exact position after disconnect
- Resume from forked blocks (using forked blocks storage)
- Skip already-processed blocks automatically
- Handle reorgs that occurred during disconnect

### Automatic Reconnection

Clients can implement robust reconnection logic:

1. Store the cursor from each received block
2. On disconnect, reconnect with the stored cursor
3. Firehose reconstructs the exact stream position
4. Continue processing without duplicates or gaps

### Seamless Historical-to-Live Transition

Firehose automatically transitions between data sources:

```
Request: blocks 1000 to live

Timeline:
─────────

[Merged Blocks: 1000-2000] → [One-Blocks: 2001-2010] → [Live: 2011+]
        ▲                           ▲                        ▲
        │                           │                        │
   Historical data            Recent blocks            Real-time stream
   from storage               not yet merged           from Relayer
```

The transition is invisible to clients—they receive a continuous stream regardless of the underlying data source.

## Configuration

### Essential Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--firehose-grpc-listen-addr` | gRPC listening address | `:10015` |
| `--common-merged-blocks-store-url` | Merged blocks storage URL | `file://{data-dir}/storage/merged-blocks` |
| `--common-one-block-store-url` | One-block files storage URL | `file://{data-dir}/storage/one-blocks` |
| `--common-forked-blocks-store-url` | Forked blocks storage URL | `file://{data-dir}/storage/forked-blocks` |
| `--common-live-blocks-addr` | Relayer gRPC address for live blocks | `:10014` |
| `--common-first-streamable-block` | First block number available to stream | `0` |

### Performance Tuning

| Flag | Description | Default |
|------|-------------|---------|
| `--firehose-enforce-compression` | Require gzip or zstd compression | `true` |
| `--firehose-rate-limit-bucket-size` | Rate limit bucket size (-1 = unlimited) | `-1` |
| `--firehose-rate-limit-bucket-fill-rate` | Rate limit refill rate | `10s` |
| `--common-blocks-cache-enabled` | Enable disk-based block caching | `false` |
| `--common-blocks-cache-dir` | Block cache directory | `file://{data-dir}/storage/blocks-cache` |

### Discovery Service

For load-balanced deployments:

| Flag | Description |
|------|-------------|
| `--firehose-discovery-service-url` | gRPC discovery service URL |

## Usage Examples

### Starting Firehose

```bash
firecore start firehose \
  --firehose-grpc-listen-addr=":10015" \
  --common-merged-blocks-store-url="s3://my-bucket/merged-blocks" \
  --common-one-block-store-url="s3://my-bucket/one-blocks" \
  --common-forked-blocks-store-url="s3://my-bucket/forked-blocks" \
  --common-live-blocks-addr="relayer.internal:10014"
```

### With Block Caching

For high-traffic deployments, enable block caching to reduce repeated storage reads:

```bash
firecore start firehose \
  --firehose-grpc-listen-addr=":10015" \
  --common-blocks-cache-enabled=true \
  --common-blocks-cache-dir="/fast-storage/cache" \
  --common-blocks-cache-max-recent-entry-bytes=21474836480
```

## Client Integration

### gRPC API

Firehose exposes the `sf.firehose.v2.Stream` service:

```protobuf
service Stream {
  rpc Blocks(Request) returns (stream Response);
}

message Request {
  int64 start_block_num = 1;
  string stop_block_num = 2;    // Empty for live streaming
  string cursor = 3;            // Resume from cursor
  repeated string final_blocks_only = 4;
  repeated google.protobuf.Any transforms = 5;
}
```

### Streaming Modes

1. **Historical range**: Specify start and stop block numbers
2. **Historical to live**: Specify start, omit stop to continue streaming indefinitely
3. **Live only**: Start from a recent block or "head"
4. **Cursor resume**: Provide cursor from previous session

## Operational Considerations

### Storage Requirements

- **Merged blocks**: Primary storage, highly compressed
- **One-blocks**: Temporary, cleaned up by Merger
- **Forked blocks**: Pruned after configurable block count (default 50,000)

### High Availability

For production deployments:

1. Run multiple Firehose instances behind a load balancer
2. All instances read from the same storage backend
3. Clients can reconnect to any instance using cursors
4. Use discovery service for automatic instance registration

### Monitoring

Key metrics to monitor:

- `firehose_active_requests`: Current number of streaming clients
- `firehose_blocks_sent_total`: Total blocks sent to clients
- `firehose_request_duration_seconds`: Request latency histogram
- `firehose_cache_hits_total`: Block cache hit rate (if caching enabled)

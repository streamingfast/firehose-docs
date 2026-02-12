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

## Streaming Modes

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

## Configuration Reference

For complete configuration options and flags, see [Firehose CLI Reference](../../references/cli/firehose.md).

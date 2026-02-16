---
description: StreamingFast Firehose Merger component
---

# Merger

The Merger is responsible for consolidating individual block files into efficient batched bundles. It reads one-block files produced by Reader Nodes and creates merged 100-block files that serve as the primary historical data source for the Firehose pipeline.

## How Merger Works

The Merger continuously polls the one-block storage for new files, accumulates them into bundles, and writes merged files to persistent storage. It also handles fork preservation and cleanup of old data.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           Merger Component                              │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                     One-Block Storage Poller                      │  │
│  │         (continuously polls for new one-block files)              │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
│                              ▼                                          │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                         Bundler                                   │  │
│  │  • Accumulates blocks until bundle boundary (100 blocks)          │  │
│  │  • Validates sequential block ordering                            │  │
│  │  • Tracks forked blocks within current range                      │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                              │                                          │
│              ┌───────────────┼───────────────┐                          │
│              ▼               ▼               ▼                          │
│     ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                   │
│     │ Merged      │  │ Forked      │  │ One-Block   │                   │
│     │ Blocks      │  │ Blocks      │  │ Pruner      │                   │
│     │ Storage     │  │ Storage     │  │ (cleanup)   │                   │
│     └─────────────┘  └─────────────┘  └─────────────┘                   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Bundling Process

The Merger accumulates blocks in memory until it has enough to create a complete bundle:

1. **Polling**: Continuously checks one-block storage for new files
2. **Validation**: Ensures blocks arrive in sequential order, starting at bundle boundaries
3. **Accumulation**: Collects blocks until reaching the bundle size (100 blocks)
4. **Merge & Store**: Writes the accumulated blocks as a single merged file
5. **Advance**: Moves to the next bundle boundary and repeats

{% hint style="info" %}
The Merger retains the last block from each bundle as a "bootstrap block" - this facilitates connection to downstream systems and cursor resolution.
{% endhint %}

### Fork Handling

The Merger preserves all forks encountered by Reader Nodes:

- **Fork Detection**: Identifies blocks on non-canonical branches within the current bundle range
- **Fork Storage**: Moves forked blocks to dedicated fork storage for cursor resolution
- **Fork Pruning**: Cleans up old forked blocks beyond the configured pruning distance

This fork preservation enables the Firehose component to resume streaming from any cursor, even if that cursor points to a block on a fork that was later abandoned.

### Retry Logic

When encountering failures (storage errors, network issues), the Merger implements automatic retry:

- **12 retry attempts** with **5-second intervals** between attempts
- Handles temporary storage unavailability gracefully
- Logs warnings for holes in merged files that can be recovered

## Bundle Size

The Merger creates bundles of exactly **100 blocks** each. This fixed size provides:

- Predictable file sizes for storage planning
- Efficient batch access for historical queries
- Consistent compression ratios

## Pruning Operations

Two concurrent pruning operations run in the background:

1. **One-Block Pruner**: Removes source files after they've been merged and are beyond the pruning distance from the Last Irreversible Block (LIB)

2. **Forked Blocks Pruner**: Removes forked block files that are older than the configured pruning distance (default 50,000 blocks)

{% hint style="warning" %}
The pruning distance should be set large enough to handle chain reorganizations. The default of 50,000 blocks is conservative and suitable for most chains.
{% endhint %}

## Storage Access

### One-Block Storage (Input)

- **Access**: Read (to fetch blocks) and Delete (to prune)
- **Volume**: Temporary - files are deleted after merging
- **Naming**: Files include block number and hash for uniqueness

### Merged Blocks Storage (Output)

- **Access**: Write (to store bundles) and Read (to detect gaps)
- **Volume**: Permanent - the primary historical data store
- **Format**: Compressed 100-block bundles

### Forked Blocks Storage

- **Access**: Write (to preserve forks) and Delete (to prune)
- **Volume**: Moderate - pruned regularly, retains recent forks only
- **Purpose**: Enables cursor resolution on forked blocks

## Multiple Readers

When running multiple Reader Nodes, the Merger consolidates blocks from all sources:

- Each Reader may see different forks depending on network peers
- The Merger captures all forks from all Readers
- Forked blocks from any Reader are preserved for cursor resolution

This architecture ensures no block data is lost, even when different Readers observe different blockchain states.

## Configuration Reference

For complete configuration options and flags, see [Merger CLI Reference](../../references/cli/merger.md).

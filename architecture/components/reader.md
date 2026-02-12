---
description: StreamingFast Firehose Reader Node component
---

# Reader Node

The Reader Node is the foundational data extraction component of the Firehose stack. It wraps and manages a blockchain data source binary, reading block data from its standard output and producing one-block files for the rest of the Firehose pipeline.

## How Reader Node Works

The Reader Node operates by spawning a **subprocess** and reading **Firehose Protocol** logs from the subprocess's `stdout`. This design keeps Firehose completely decoupled from the underlying blockchain node - Firehose doesn't modify, access, or interact with any other aspect of the node's operation (database, network, RPC, etc.).

```
┌─────────────────────────────────────────────────────────────┐
│                      Reader Node                            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Subprocess Manager                       │  │
│  │  (spawns, monitors, restarts underlying process)      │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                  │
│                          │ spawns                           │
│                          ▼                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │         Underlying Binary (subprocess)                │  │
│  │                                                       │  │
│  │  • Firehose-enabled node (geth-firehose, etc.)        │  │
│  │  • RPC poller binary                                  │  │
│  │  • Any binary emitting Firehose Protocol logs         │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                  │
│                          │ stdout (Firehose Protocol logs)  │
│                          ▼                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Block Parser & Writer                    │  │
│  │  • Parses Firehose Protocol messages                  │  │
│  │  • Produces one-block files                           │  │
│  │  • Streams to Relayer via gRPC                        │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                  │
│              ┌───────────┴───────────┐                      │
│              ▼                       ▼                      │
│     One-Block Files            gRPC Stream                  │
│     (Object Storage)           (to Relayer)                 │
└─────────────────────────────────────────────────────────────┘
```

### Data Sources

The Reader Node can work with different types of underlying binaries:

| Source Type | Description | Example |
|-------------|-------------|---------|
| **Firehose-enabled Node** | A blockchain node instrumented to emit Firehose Protocol logs while syncing | `geth` with Firehose patches, `nearcore` with Firehose |
| **RPC Poller** | A binary that polls an existing RPC endpoint and converts responses to Firehose Protocol | `fireeth tools poller` |
| **Custom Binary** | Any binary that outputs valid Firehose Protocol logs | Custom chain implementations |

### Firehose Protocol

The underlying binary must emit specially formatted log lines to `stdout`. The protocol consists of two message types:

**FIRE INIT** - Sent once at startup to declare protocol version and block type:
```
FIRE INIT <version> <protobuf_block_type>
```

Example: `FIRE INIT 3.0 sf.ethereum.type.v2.Block`

**FIRE BLOCK** - Sent for each block with metadata and base64-encoded payload:
```
FIRE BLOCK <block_num> <block_hash> <parent_num> <parent_hash> <lib_num> <timestamp_nanos> <base64_block>
```

Supported protocol versions: `1.0`, `3.0`, `3.1`.

{% hint style="info" %}
The Reader Node only reads from `stdout`. It does not interact with the node's database, network layer, RPC interface, or any other component. This isolation ensures Firehose has zero impact on node operation.
{% endhint %}

## Reader Node Variants

Firehose provides three reader modes for different use cases:

### reader-node (Standard)

The most common mode. The Reader Node spawns and manages the underlying binary as a subprocess.

```bash
firecore start reader-node \
  --reader-node-path="geth" \
  --reader-node-arguments="--vmtrace=firehose --datadir={node-data-dir}"
```

### reader-node-stdin

Reads from an already-running process via stdin pipe. Useful when you need to manage the node process separately.

```bash
geth --vmtrace=firehose | firecore start reader-node-stdin
```

### reader-node-firehose

Connects to an existing Firehose endpoint and re-emits blocks as one-block files. Useful for creating local copies of remote Firehose data.

```bash
firecore start reader-node-firehose \
  --reader-node-firehose-endpoint="mainnet.eth.streamingfast.io:443"
```

## Output: One-Block Files

The Reader Node produces **one-block files** - individual files containing a single block's data in Protocol Buffer format. These files:

- Are named with the block number and hash for uniqueness
- Enable parallel processing by the Merger
- Capture all forks seen by this Reader
- Are pruned after being merged (by the Merger)

When running multiple Reader Nodes writing to the same storage, use `--reader-node-one-block-suffix` to give each instance a unique identifier and prevent write conflicts.

## High Availability

Multiple Reader Nodes can run simultaneously for high availability:

- Each Reader connects to different network peers, potentially seeing different forks
- All Readers write to the same one-block storage (with unique suffixes)
- The Merger consolidates all blocks, including forks from any Reader
- Readers race to push data to the Relayer, minimizing latency

See [High Availability](high-availability.md) for detailed deployment patterns.

## Underlying Node Requirements

When using a Firehose-enabled blockchain node, the node only needs to:

- Execute transactions in consensus order
- Emit Firehose Protocol logs to stdout

The node does **not** need:
- Archive mode
- JSON-RPC service
- Indexed data or query capabilities
- Any special storage configuration

This minimal configuration reduces resource requirements and operational complexity.

## Configuration Reference

For complete configuration options, flags, and the Management API reference, see [Reader Node CLI Reference](../../references/cli/reader-node.md).

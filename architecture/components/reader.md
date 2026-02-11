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
│  │              Subprocess Manager                        │  │
│  │  (spawns, monitors, restarts underlying process)       │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                  │
│                          │ spawns                           │
│                          ▼                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │         Underlying Binary (subprocess)                 │  │
│  │                                                        │  │
│  │  • Firehose-enabled node (geth-firehose, etc.)        │  │
│  │  • RPC poller binary                                   │  │
│  │  • Any binary emitting Firehose Protocol logs         │  │
│  └───────────────────────────────────────────────────────┘  │
│                          │                                  │
│                          │ stdout (Firehose Protocol logs)  │
│                          ▼                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Block Parser & Writer                     │  │
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
| **Firehose-enabled Node** | A blockchain node instrumented to emit Firehose Protocol logs while syncing | `geth` with Firehose patches, `nodeop` with Firehose |
| **RPC Poller** | A binary that polls an existing RPC endpoint and converts responses to Firehose Protocol | `firehose-ethereum` poller mode |
| **Custom Binary** | Any binary that outputs valid Firehose Protocol logs | Custom chain implementations |

### Firehose Protocol

The underlying binary must emit specially formatted log lines to `stdout` following the [Firehose Protocol](../../references/firehose-protocol.md). These logs contain:

- Block boundaries (FIRE BLOCK_BEGIN, FIRE BLOCK_END)
- Transaction data
- State changes
- Events/logs
- All blockchain-specific data encoded in Protocol Buffers

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
  --reader-node-arguments="--firehose-enabled --datadir={node-data-dir}" \
  --reader-node-data-dir="./data/node"
```

### reader-node-stdin

Reads from an already-running process via stdin pipe. Useful when you need to manage the node process separately.

```bash
geth --firehose-enabled | firecore start reader-node-stdin
```

### reader-node-firehose

Connects to an existing Firehose endpoint and re-emits blocks as one-block files. Useful for creating local copies of remote Firehose data.

```bash
firecore start reader-node-firehose \
  --reader-node-firehose-endpoint="mainnet.eth.streamingfast.io:443"
```

## Node Operator Management API

The Reader Node includes a management API that allows operators to control the underlying subprocess without restarting the entire Reader Node process. This is exposed via HTTP on the `--reader-node-manager-api-addr` port (default `:10011`).

### Available Operations

**Check node status:**
```bash
curl http://localhost:10011/v1/healthz
```

**Stop the underlying node:**
```bash
curl -XPOST http://localhost:10011/v1/stop
```

**Start the underlying node:**
```bash
curl -XPOST http://localhost:10011/v1/start
```

**Restart the underlying node:**
```bash
curl -XPOST http://localhost:10011/v1/restart
```

{% hint style="success" %}
The management API is particularly useful for maintenance operations - you can stop the blockchain node to perform backups or maintenance without affecting the Reader Node process itself.
{% endhint %}

## Configuration

### Key Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-path` | Path to the binary to execute | (required) |
| `--reader-node-arguments` | Arguments passed to the subprocess (supports templating) | |
| `--reader-node-data-dir` | Data directory for the underlying node | `{data-dir}/reader/data` |
| `--reader-node-grpc-listen-addr` | gRPC address for streaming blocks to Relayer | `:10010` |
| `--reader-node-manager-api-addr` | HTTP address for management API | `:10011` |
| `--reader-node-start-block-num` | Skip blocks before this number | `0` |
| `--reader-node-stop-block-num` | Stop after reaching this block | (none) |

### Argument Templating

The `--reader-node-arguments` flag supports template variables that are resolved at runtime:

| Template | Resolves To |
|----------|-------------|
| `{data-dir}` | The `--data-dir` flag value |
| `{node-data-dir}` | The `--reader-node-data-dir` flag value |
| `{hostname}` | Machine hostname |
| `{start-block-num}` | The `--reader-node-start-block-num` value |
| `{stop-block-num}` | The `--reader-node-stop-block-num` value |
| `{first-streamable-block}` | The `--common-first-streamable-block` value |

Environment variables are also expanded: `${ENV_VAR}` will be replaced with the value of `ENV_VAR`.

**Example:**
```bash
--reader-node-arguments="--datadir={node-data-dir} --port=${P2P_PORT}"
```

### Bootstrap Support

The Reader Node can automatically bootstrap an empty node from a backup or script using `--reader-node-bootstrap-data-url`:

**From a compressed archive:**
```bash
--reader-node-bootstrap-data-url="gs://my-bucket/backups/node-backup.tar.zst"
```

**From a bash script:**
```bash
--reader-node-bootstrap-data-url="bash:///path/to/bootstrap.sh?arg=--network=mainnet"
```

## Output: One-Block Files

The Reader Node produces **one-block files** - individual files containing a single block's data in Protocol Buffer format. These files are written to the path specified by `--common-one-block-store-url`.

One-block files:
- Are named with the block number and hash for uniqueness
- Enable parallel processing by the Merger
- Capture all forks seen by this Reader
- Are pruned after being merged (configurable)

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

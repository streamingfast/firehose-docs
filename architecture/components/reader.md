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
  --reader-node-arguments="--vmtrace=firehose --datadir={node-data-dir}" \
  --reader-node-data-dir="./data/node"
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

## Node Operator Management API

The Reader Node includes a management API that allows operators to control the underlying subprocess without restarting the entire Reader Node process. This is exposed via HTTP on the `--reader-node-manager-api-addr` port (default `:10011`).

### Available Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/healthz` or `/v1/healthz` | GET | Health check - returns ready/not ready status |
| `/v1/ping` | GET | Simple ping, returns "pong" |
| `/v1/is_running` | GET | Check if subprocess is running (JSON response) |
| `/v1/start_command` | GET | Show the command being executed |
| `/v1/maintenance` | POST | Stop subprocess for maintenance |
| `/v1/resume` | POST | Start/resume the subprocess |
| `/v1/reload` or `/v1/restart` | POST | Restart the subprocess |
| `/v1/backup` | POST | Trigger a backup (if backup modules configured) |
| `/v1/restore` | POST | Restore from backup |
| `/v1/list_backups` | GET | List available backups |
| `/v1/safely_reload` | POST | Safely reload (waits for production round on producer nodes) |

### Usage Examples

**Check health status:**
```bash
curl http://localhost:10011/v1/healthz
```

**Put node in maintenance mode (stop subprocess):**
```bash
curl -XPOST http://localhost:10011/v1/maintenance
```

**Resume node operation:**
```bash
curl -XPOST http://localhost:10011/v1/resume
```

**Restart the underlying node:**
```bash
curl -XPOST http://localhost:10011/v1/restart
```

**Check if subprocess is running:**
```bash
curl http://localhost:10011/v1/is_running
# Returns: {"is_running":true}
```

{% hint style="info" %}
Add `?sync=true` to POST requests to wait for the command to complete before returning.
{% endhint %}

{% hint style="success" %}
The management API is particularly useful for maintenance operations - you can stop the blockchain node to perform backups or maintenance without affecting the Reader Node process itself.
{% endhint %}

## Configuration

### Core Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-path` | Path to the binary to execute | (required) |
| `--reader-node-arguments` | Arguments passed to the subprocess (supports templating) | |
| `--reader-node-data-dir` | Data directory for the underlying node | `{data-dir}/reader/data` |
| `--reader-node-working-dir` | Working directory for reader files | `{data-dir}/reader/work` |
| `--reader-node-grpc-listen-addr` | gRPC address for streaming blocks to Relayer | `:10010` |
| `--reader-node-manager-api-addr` | HTTP address for management API | `:10011` |

### Block Range Control

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-start-block-num` | Skip blocks before this number | `0` |
| `--reader-node-stop-block-num` | Stop after reaching this block (inclusive) | (none) |
| `--reader-node-discard-after-stop-num` | Discard blocks after stop number | `false` |

### Performance Tuning

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-blocks-chan-capacity` | Block channel capacity (shutdown at 90% full) | `100` |
| `--reader-node-line-buffer-size` | Max line buffer size in bytes | `209715200` (200MB) |
| `--reader-node-readiness-max-latency` | Max head block latency for health check | `30s` |
| `--reader-node-one-block-suffix` | Unique suffix for one-block files | `default` |

### Debug Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-debug-firehose-logs` | Print Firehose protocol logs to stdout | `false` |

### Argument Templating

The `--reader-node-arguments` flag supports template variables that are resolved at runtime:

| Template | Resolves To |
|----------|-------------|
| `{data-dir}` | The `--data-dir` flag value |
| `{node-data-dir}` | The `--reader-node-data-dir` flag value |
| `{hostname}` | Machine hostname |
| `{start-block-num}` | The resolved `--reader-node-start-block-num` value |
| `{stop-block-num}` | The `--reader-node-stop-block-num` value |
| `{first-streamable-block}` | The `--common-first-streamable-block` value |

Environment variables are also expanded: `${ENV_VAR}` will be replaced with the value of `ENV_VAR`.

**Example:**
```bash
--reader-node-arguments="--datadir={node-data-dir} --port=${P2P_PORT}"
```

## Backup Support

The Reader Node supports automated backups through backup modules. Configure backups using the `--reader-node-backups` flag:

```bash
--reader-node-backups="type=gke-pvc-snapshot prefix=backup tag=v1 freq-blocks=1000"
```

Backup parameters:
- `type`: Backup module type (e.g., `gke-pvc-snapshot`)
- `prefix`: Backup name prefix
- `tag`: Backup tag/version
- `freq-blocks`: Trigger backup every N blocks
- `freq-time`: Trigger backup by time interval

Backups can also be triggered manually via the management API:
```bash
curl -XPOST http://localhost:10011/v1/backup
```

## Output: One-Block Files

The Reader Node produces **one-block files** - individual files containing a single block's data in Protocol Buffer format. These files are written to the path specified by `--common-one-block-store-url`.

One-block files:
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

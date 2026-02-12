# CLI Reference: Reader Node

This page documents the configuration flags for the Reader Node component. For architectural concepts and how the Reader Node works, see [Reader Node Architecture](../../architecture/components/reader.md).

## Reader Node Variants

Firehose provides three reader modes:

| Component | Description |
|-----------|-------------|
| `reader-node` | Spawns and manages a blockchain node subprocess |
| `reader-node-stdin` | Reads blocks from stdin pipe |
| `reader-node-firehose` | Reads blocks from a remote Firehose endpoint |

## Core Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-path` | Path to blockchain node binary | (required) |
| `--reader-node-arguments` | Arguments passed to the node (supports templating) | |
| `--reader-node-data-dir` | Data directory for the blockchain node | `{data-dir}/reader/data` |
| `--reader-node-working-dir` | Working directory for reader files | `{data-dir}/reader/work` |
| `--reader-node-grpc-listen-addr` | gRPC address for streaming blocks | `:10010` |
| `--reader-node-manager-api-addr` | HTTP address for node manager API | `:10011` |

## Argument Templating

The `--reader-node-arguments` flag is parsed using standard shell quoting rules, allowing you to:
- Use double quotes for values with spaces: `--flag "value with spaces"`
- Use single quotes for literal strings
- Escape special characters as needed

The flag also supports these template variables:

| Template | Description |
|----------|-------------|
| `{data-dir}` | Value of `--data-dir` flag |
| `{node-data-dir}` | Value of `--reader-node-data-dir` flag |
| `{hostname}` | Machine hostname |
| `{start-block-num}` | Value of `--reader-node-start-block-num` |
| `{stop-block-num}` | Value of `--reader-node-stop-block-num` |
| `{first-streamable-block}` | Value of `--common-first-streamable-block` |

Environment variables are also expanded: `${VAR}` becomes the value of `VAR`.

**Example:**
```bash
--reader-node-arguments="--datadir={node-data-dir} --port=${P2P_PORT} --vmtrace=firehose"
```

## Block Range Control

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-start-block-num` | Skip blocks before this number | `0` |
| `--reader-node-stop-block-num` | Stop after reaching this block | (none) |
| `--reader-node-discard-after-stop-num` | Discard blocks after stop number | `false` |

## Performance Tuning

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-blocks-chan-capacity` | Block channel capacity (shutdown at 90%) | `100` |
| `--reader-node-line-buffer-size` | Max line buffer size in bytes | `209715200` (200MB) |
| `--reader-node-readiness-max-latency` | Max head block latency for health check | `30s` |
| `--reader-node-one-block-suffix` | Unique suffix for one-block files (for multiple readers) | `default` |

## Bootstrap Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-bootstrap-data-url` | URL to bootstrap empty node from backup or script | |

Bootstrap URL formats:
- `gs://bucket/backup.tar.zst` - Extract archive to data dir
- `s3://bucket/backup.tar.zst` - Extract archive to data dir
- `bash:///path/to/script.sh?arg=value` - Execute bash script

## Reader Node Firehose Mode

For `reader-node-firehose` component connecting to remote Firehose:

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-firehose-endpoint` | Remote Firehose endpoint | (required) |
| `--reader-node-firehose-plaintext` | Use plaintext connection | `false` |
| `--reader-node-firehose-insecure` | Skip TLS validation | `false` |
| `--reader-node-firehose-compression` | Compression: `gzip`, `zstd`, `none` | `zstd` |
| `--reader-node-firehose-state` | State file for cursor persistence | `{data-dir}/reader/state` |
| `--reader-node-firehose-api-key-env-var` | Env var containing API key | `FIREHOSE_API_KEY` |
| `--reader-node-firehose-api-token-env-var` | Env var containing JWT token | `FIREHOSE_API_TOKEN` |

## Backup Configuration

| Flag | Description |
|------|-------------|
| `--reader-node-backups` | Backup module configuration string |

Backup parameters format: `type=<type> prefix=<prefix> tag=<tag> freq-blocks=<N>`

- `type`: Backup module type (e.g., `gke-pvc-snapshot`)
- `prefix`: Backup name prefix
- `tag`: Backup tag/version
- `freq-blocks`: Trigger backup every N blocks
- `freq-time`: Trigger backup by time interval

## Debug Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-debug-firehose-logs` | Print Firehose protocol logs to stdout | `false` |
| `--reader-node-test-mode` | Compare blocks against another instance | `false` |
| `--reader-node-test-mode-diff-against` | Address of instance to diff against | |
| `--reader-node-test-mode-diff-output` | File path for diff output | `-` (stdout) |

## Management API

The Reader Node exposes an HTTP management API on `--reader-node-manager-api-addr` (default `:10011`).

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

```bash
# Check health status
curl http://localhost:10011/v1/healthz

# Put node in maintenance mode (stop subprocess)
curl -XPOST http://localhost:10011/v1/maintenance

# Resume node operation
curl -XPOST http://localhost:10011/v1/resume

# Restart the underlying node
curl -XPOST http://localhost:10011/v1/restart

# Check if subprocess is running
curl http://localhost:10011/v1/is_running
# Returns: {"is_running":true}
```

{% hint style="info" %}
Add `?sync=true` to POST requests to wait for the command to complete before returning.
{% endhint %}

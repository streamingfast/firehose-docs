# CLI Reference

This document provides a comprehensive reference for the Firehose CLI.

## Binaries

| Binary | Description | Use Case |
|--------|-------------|----------|
| `firecore` | Core Firehose binary | All chains except Ethereum-compatible |
| `fireeth` | Ethereum Firehose binary | Ethereum and EVM-compatible chains |

{% hint style="info" %}
`fireeth` includes all `firecore` functionality plus Ethereum-specific commands. All examples below use `firecore` but work identically with `fireeth`.
{% endhint %}

## Start Command

The `firecore start` command launches Firehose components.

```bash
firecore start [flags] [all|component1 [component2...]]
```

### Available Components

| Component | Description | Default Port |
|-----------|-------------|--------------|
| `reader-node` | Spawns and manages blockchain node, extracts blocks | `:10010` (gRPC), `:10011` (manager API) |
| `reader-node-stdin` | Reads blocks from stdin pipe | `:10010` |
| `reader-node-firehose` | Reads blocks from remote Firehose endpoint | `:10010` |
| `merger` | Combines one-block files into merged bundles | `:10012` |
| `relayer` | Streams live blocks, provides high availability | `:10014` |
| `firehose` | Serves Firehose gRPC API | `:10015` |
| `substreams-tier1` | Serves Substreams API, handles live blocks | `:10016` |
| `substreams-tier2` | Substreams worker for historical processing | `:10017` |

## Global Flags

These flags are available for all `firecore` commands.

| Flag | Description | Default |
|------|-------------|---------|
| `-c, --config-file` | Configuration file path. Set to empty string to disable. | `./firehose.yaml` |
| `-d, --data-dir` | Data storage directory for all components | `./firehose-data` |
| `--log-format` | Log output format: `text` or `stackdriver` | `text` |
| `--log-to-file` | Also write logs to `{data-dir}/app.log.json` | `true` |
| `-v, --log-verbosity` | Verbose output level (use `-vvvv` for max) | `0` |
| `--metrics-listen-addr` | Prometheus metrics endpoint | `:9102` |
| `--pprof-listen-addr` | pprof profiling endpoint | `localhost:6060` |
| `--startup-delay` | Delay before launching components | `0` |
| `--log-level-switcher-listen-addr` | HTTP endpoint to dynamically change log levels | `localhost:1065` |

### Dynamic Log Level Switching

Change log levels at runtime:

```bash
curl -XPUT -d '{"level":"debug","inputs":"*"}' http://localhost:1065
```

Valid levels: `trace`, `debug`, `info`, `warn`, `error`, `panic`

## Common Flags

These flags are shared across multiple components and prefixed with `--common-`.

| Flag | Description | Default |
|------|-------------|---------|
| `--common-one-block-store-url` | Store URL for one-block files | `file://{data-dir}/storage/one-blocks` |
| `--common-merged-blocks-store-url` | Store URL for merged block files | `file://{data-dir}/storage/merged-blocks` |
| `--common-forked-blocks-store-url` | Store URL for forked block files | `file://{data-dir}/storage/forked-blocks` |
| `--common-index-store-url` | Store URL for index files | `file://{data-dir}/storage/index` |
| `--common-live-blocks-addr` | gRPC endpoint for real-time blocks (Relayer) | `:10014` |
| `--common-first-streamable-block` | First streamable block number | `0` |
| `--common-auth-plugin` | Authentication plugin URI | `null://` |
| `--common-metering-plugin` | Metering plugin URI | `null://` |
| `--common-session-plugin` | Session plugin URI | `local://...` |
| `--common-tmp-dir` | Temporary files directory | `{data-dir}/tmp` |
| `--common-auto-max-procs` | Auto-set GOMAXPROCS from cgroup | `false` |
| `--common-auto-mem-limit-percent` | Auto-set GOMEMLIMIT percentage from cgroup | `0` |
| `--common-system-shutdown-signal-delay` | Delay between SIGTERM and shutdown | `0` |

### Blocks Cache Flags

Enable disk-based block caching to reduce RAM usage:

| Flag | Description | Default |
|------|-------------|---------|
| `--common-blocks-cache-enabled` | Enable disk-based block caching | `false` |
| `--common-blocks-cache-dir` | Cache directory path | `file://{data-dir}/storage/blocks-cache` |
| `--common-blocks-cache-max-recent-entry-bytes` | Max bytes for recent blocks cache | `21474836480` (20GB) |
| `--common-blocks-cache-max-entry-by-age-bytes` | Max bytes for oldest blocks cache | `21474836480` (20GB) |

### Index Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--common-index-block-sizes` | Valid index bundle sizes | `[100000,10000,1000,100]` |

## Advertise Flags

These flags configure the Info endpoint for Firehose and Substreams Tier 1.

| Flag | Description | Default |
|------|-------------|---------|
| `--advertise-chain-name` | Chain name to advertise | (inferred from genesis) |
| `--advertise-chain-aliases` | Chain name aliases | (inferred from genesis) |
| `--advertise-block-id-encoding` | Block ID encoding: `hex`, `0x_hex`, `base58`, `base64`, `base64url` | (inferred from genesis) |
| `--advertise-block-features` | Block features to advertise | (inferred from genesis) |
| `--ignore-advertise-validation` | Skip genesis block validation | `false` |

## Reader Node Flags

Configuration for the `reader-node` component.

### Core Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-path` | Path to blockchain node binary | (required) |
| `--reader-node-arguments` | Arguments passed to the node (supports templating) | |
| `--reader-node-data-dir` | Data directory for the blockchain node | `{data-dir}/reader/data` |
| `--reader-node-working-dir` | Working directory for reader files | `{data-dir}/reader/work` |
| `--reader-node-grpc-listen-addr` | gRPC address for streaming blocks | `:10010` |
| `--reader-node-manager-api-addr` | HTTP address for node manager API | `:10011` |

### Argument Templating

The `--reader-node-arguments` flag supports these template variables:

| Template | Description |
|----------|-------------|
| `{data-dir}` | Value of `--data-dir` flag |
| `{node-data-dir}` | Value of `--reader-node-data-dir` flag |
| `{hostname}` | Machine hostname |
| `{start-block-num}` | Value of `--reader-node-start-block-num` |
| `{stop-block-num}` | Value of `--reader-node-stop-block-num` |
| `{first-streamable-block}` | Value of `--common-first-streamable-block` |

Environment variables are also expanded: `${VAR}` becomes the value of `VAR`.

### Block Range Control

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-start-block-num` | Skip blocks before this number | `0` |
| `--reader-node-stop-block-num` | Stop after reaching this block | (none) |
| `--reader-node-discard-after-stop-num` | Discard blocks after stop number | `false` |

### Performance Tuning

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-blocks-chan-capacity` | Block channel capacity (shutdown at 90%) | `100` |
| `--reader-node-line-buffer-size` | Max line buffer size in bytes | `209715200` (200MB) |
| `--reader-node-readiness-max-latency` | Max head block latency for health check | `30s` |
| `--reader-node-one-block-suffix` | Unique suffix for one-block files (for multiple readers) | `default` |

### Bootstrap Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-bootstrap-data-url` | URL to bootstrap empty node from backup or script | |

Bootstrap URL formats:
- `gs://bucket/backup.tar.zst` - Extract archive to data dir
- `s3://bucket/backup.tar.zst` - Extract archive to data dir
- `bash:///path/to/script.sh?arg=value` - Execute bash script

### Reader Node Firehose Mode

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

### Debug Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--reader-node-debug-firehose-logs` | Print Firehose protocol logs to stdout | `false` |
| `--reader-node-test-mode` | Compare blocks against another instance | `false` |
| `--reader-node-test-mode-diff-against` | Address of instance to diff against | |
| `--reader-node-test-mode-diff-output` | File path for diff output | `-` (stdout) |

## Merger Flags

Configuration for the `merger` component.

| Flag | Description | Default |
|------|-------------|---------|
| `--merger-grpc-listen-addr` | gRPC listening address | `:10012` |
| `--merger-time-between-store-lookups` | Polling interval for source store | `1s` |
| `--merger-time-between-store-pruning` | Interval for pruning loops | `1m0s` |
| `--merger-delete-threads` | Parallel threads for file deletion | `8` |
| `--merger-prune-forked-blocks-after` | Blocks before deleting old forks | `50000` |
| `--merger-stop-block` | Stop after merging to this block | (none) |

## Relayer Flags

Configuration for the `relayer` component.

| Flag | Description | Default |
|------|-------------|---------|
| `--relayer-grpc-listen-addr` | gRPC listening address | `:10014` |
| `--relayer-source` | Reader source addresses (repeatable) | `[:10010]` |
| `--relayer-max-source-latency` | Max tolerated source latency | `999999h` |

## Firehose Flags

Configuration for the `firehose` component (gRPC server).

| Flag | Description | Default |
|------|-------------|---------|
| `--firehose-grpc-listen-addr` | gRPC listening address | `:10015` |
| `--firehose-enforce-compression` | Require gzip or zstd encoding | `true` |
| `--firehose-rate-limit-bucket-size` | Rate limit bucket size (-1 = no limit) | `-1` |
| `--firehose-rate-limit-bucket-fill-rate` | Rate limit bucket refill rate | `10s` |
| `--firehose-discovery-service-url` | gRPC discovery service URL | |

## Substreams Tier 1 Flags

Configuration for the `substreams-tier1` component.

### Core Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--substreams-tier1-grpc-listen-addr` | gRPC listening address (append `*` for TLS) | `:10016` |
| `--substreams-tier1-block-type` | Protobuf block type (e.g., `sf.ethereum.type.v2.Block`) | |
| `--substreams-tier1-enforce-compression` | Require gzip or zstd encoding | `true` |

### Tier 2 Connection

| Flag | Description | Default |
|------|-------------|---------|
| `--substreams-tier1-subrequests-endpoint` | Address to reach tier2 workers | `:10017` |
| `--substreams-tier1-subrequests-plaintext` | Use plaintext connection to tier2 | `true` |
| `--substreams-tier1-subrequests-insecure` | Skip tier2 TLS validation | `false` |
| `--substreams-tier1-max-subrequests` | Parallel subrequests per request | `4` |

### Request Limits

| Flag | Description | Default |
|------|-------------|---------|
| `--substreams-tier1-active-requests-soft-limit` | Soft limit for active requests (triggers unready) | `0` (none) |
| `--substreams-tier1-active-requests-hard-limit` | Hard limit (rejects requests) | `0` (none) |
| `--substreams-tier1-default-max-request-per-user` | Default max requests per user | `3` |
| `--substreams-tier1-default-minimal-request-life-time-second` | Minimum request lifetime | `180` |

### State Storage

| Flag | Description | Default |
|------|-------------|---------|
| `--substreams-state-store-url` | URL for Substreams state data | `{sf-data-dir}/localdata` |
| `--substreams-state-store-default-tag` | Tag appended to state store URL | |
| `--substreams-state-bundle-size` | Blocks between store snapshots | `1000` |
| `--substreams-block-execution-timeout` | Max block execution time | `3m` |
| `--substreams-tier1-quicksave-store` | Store for quicksave on shutdown | |

### Discovery & Pools

| Flag | Description | Default |
|------|-------------|---------|
| `--substreams-tier1-discovery-service-url` | Discovery service for tier2 | |
| `--substreams-tier1-global-worker-pool-address` | Global worker pool address | |
| `--substreams-tier1-global-worker-pool-keep-alive-delay` | Worker pool keep-alive interval | `25s` |
| `--substreams-tier1-global-request-pool-address` | Global request pool address | |
| `--substreams-tier1-global-request-pool-keep-alive-delay` | Request pool keep-alive interval | `25s` |
| `--substreams-tier1-foundational-stores-config-path` | Foundational stores config file | |

## Substreams Tier 2 Flags

Configuration for the `substreams-tier2` component (workers).

| Flag | Description | Default |
|------|-------------|---------|
| `--substreams-tier2-grpc-listen-addr` | gRPC listening address (append `*` for TLS) | `:10017` |
| `--substreams-tier2-max-concurrent-requests` | Max concurrent requests (0 = no limit) | `0` |
| `--substreams-tier2-segment-execution-timeout` | Max segment execution time | `1h` |
| `--substreams-tier2-discovery-service-url` | Discovery service to advertise presence | |

## Configuration File

As an alternative to command-line flags, use a YAML configuration file:

```yaml
start:
  args:
    - reader-node
    - merger
    - relayer
    - firehose
  flags:
    data-dir: /data/firehose
    reader-node-path: /usr/local/bin/geth
    reader-node-arguments: "--datadir {node-data-dir} --firehose-enabled"
    common-merged-blocks-store-url: "s3://my-bucket/merged-blocks"
```

## Environment Variables

Flags can be set via environment variables:

| Pattern | Example |
|---------|---------|
| Global flags: `FIRECORE_GLOBAL_<FLAG>` | `FIRECORE_GLOBAL_DATA_DIR=/data` |
| Start command flags: `FIRECORE_<FLAG>` | `FIRECORE_READER_NODE_PATH=/usr/bin/geth` |

Convert flag names: replace `-` with `_` and uppercase.

## Storage URLs

Firehose supports multiple storage backends via URL schemes:

| Scheme | Example | Description |
|--------|---------|-------------|
| `file://` | `file:///data/blocks` | Local filesystem |
| `gs://` | `gs://bucket/path` | Google Cloud Storage |
| `s3://` | `s3://bucket/path` | Amazon S3 |
| `az://` | `az://container/path` | Azure Blob Storage |

{% hint style="info" %}
For S3-compatible storage (MinIO, Ceph), use `s3://` with appropriate endpoint configuration via environment variables.
{% endhint %}

## Getting Help

```bash
# General help
firecore --help

# Start command help
firecore start --help

# List available tools
firecore tools --help
```

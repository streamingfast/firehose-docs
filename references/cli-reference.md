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

For component-specific configuration, see:
- [Reader Node CLI Reference](cli/reader-node.md)
- [Merger CLI Reference](cli/merger.md)
- [Relayer CLI Reference](cli/relayer.md)
- [Firehose CLI Reference](cli/firehose.md)
- [Substreams CLI Reference](cli/substreams.md)

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

### Index Flags (Legacy)

{% hint style="warning" %}
Index flags are for legacy graph-node integration. For new projects, use Substreams instead.
{% endhint %}

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
    reader-node-arguments: "--datadir {node-data-dir} --vmtrace=firehose"
    common-merged-blocks-store-url: "s3://my-bucket/merged-blocks"
```

## Environment Variables

Flags can be set via environment variables. Convert flag names by replacing `-` with `_` and uppercasing.

### Global Flags

Global flags (those available on all commands like `--data-dir`, `--log-format`) use the `FIRECORE_GLOBAL_` prefix:

| Flag | Environment Variable |
|------|---------------------|
| `--data-dir` | `FIRECORE_GLOBAL_DATA_DIR` |
| `--log-format` | `FIRECORE_GLOBAL_LOG_FORMAT` |
| `--metrics-listen-addr` | `FIRECORE_GLOBAL_METRICS_LISTEN_ADDR` |

### Start Command Flags

Flags specific to the `start` command use the `FIRECORE_` prefix (without `GLOBAL_`):

| Flag | Environment Variable |
|------|---------------------|
| `--common-first-streamable-block` | `FIRECORE_COMMON_FIRST_STREAMABLE_BLOCK` |
| `--common-merged-blocks-store-url` | `FIRECORE_COMMON_MERGED_BLOCKS_STORE_URL` |
| `--reader-node-path` | `FIRECORE_READER_NODE_PATH` |
| `--reader-node-arguments` | `FIRECORE_READER_NODE_ARGUMENTS` |
| `--firehose-grpc-listen-addr` | `FIRECORE_FIREHOSE_GRPC_LISTEN_ADDR` |

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

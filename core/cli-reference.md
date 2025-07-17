---
description: Firehose CLI reference for the firecore binary
---

# CLI Reference

## Overview

The `firecore` binary is the main command-line interface for operating Firehose on most blockchain networks. This section provides comprehensive documentation for all available commands and flags.

> **Note**: Ethereum uses a specialized `fireeth` binary that extends `firecore` with Ethereum-specific functionality. See [Ethereum CLI Reference](../chains/ethereum/fireeth-binary.md) for details.

## Basic Usage

```bash
firecore [global-flags] <command> [command-flags] [arguments]
```

## Global Flags

These flags are available for all commands:

### Data and Configuration
- `--data-dir, -d` (string): Path to data storage for all components (default: `./firehose-data`)
- `--config-file, -c` (string): Configuration file to use (default: `./firehose.yaml`)

### Logging
- `--log-format` (string): Format for logging to stdout (`text` or `stackdriver`, default: `text`)
- `--log-to-file` (bool): Also write logs to `{data-dir}/firehose.log` (default: `true`)
- `--log-level-switcher-listen-addr` (string): HTTP server address for runtime log level switching (default: `localhost:1065`)
- `--log-verbosity, -v` (count): Enables verbose output (`-vvvv` for max verbosity)

### Monitoring and Debugging
- `--metrics-listen-addr` (string): Address to serve Prometheus metrics (default: `:9102`)
- `--pprof-listen-addr` (string): Address for pprof analysis (default: `localhost:6060`)
- `--startup-delay` (duration): Delay before launching components (default: `0`)

## Commands

### start

The primary command for running Firehose components.

```bash
firecore start <app> [app-specific-flags]
```

#### Available Applications

- **`reader-node`** - Extracts data from blockchain nodes
- **`merger`** - Combines block files into larger segments
- **`relayer`** - Provides real-time streaming and high availability
- **`firehose`** - Serves gRPC API for block streaming
- **`substreams-tier1`** - Substreams execution tier 1
- **`substreams-tier2`** - Substreams execution tier 2
- **`index-builder`** - Builds block indexes (if supported by chain)

#### Common Store Configuration Flags

These flags configure data storage locations:

- `--common-one-block-store-url` (string): Store URL for one-block files
- `--common-merged-blocks-store-url` (string): Store URL for merged blocks
- `--common-forked-blocks-store-url` (string): Store URL for forked blocks
- `--common-live-blocks-addr` (string): gRPC endpoint for real-time blocks
- `--common-tmp-dir` (string): Local directory for temporary files
- `--common-index-store-url` (string): Store URL for index files

#### Chain Advertisement Flags

- `--advertise-chain-name` (string): Chain name to advertise in Info endpoint
- `--advertise-chain-aliases` ([]string): Chain name aliases to advertise
- `--advertise-block-features` ([]string): Block features to advertise
- `--advertise-block-id-encoding` (string): Block ID encoding type (`hex`, `base58`, etc.)
- `--ignore-advertise-validation` (bool): Skip runtime validation of advertised values

### tools

Utility commands for maintenance and debugging.

```bash
firecore tools <tool-command> [tool-flags]
```

Common tool commands include:
- Block inspection and validation
- Data migration utilities
- Index rebuilding tools
- Store verification commands

> **Note**: Available tool commands vary by blockchain implementation. Use `firecore tools --help` for a complete list.

## Configuration File

Instead of using command-line flags, you can specify configuration in a YAML file:

```yaml
# firehose.yaml example
start:
  args:
    - reader-node
  flags:
    data-dir: /var/firehose-data
    common-one-block-store-url: gs://my-bucket/blocks
    reader-node-path: /usr/local/bin/geth
```

## Environment Variables

All flags can be set via environment variables using the pattern:
```
FIRECORE_<FLAG_NAME_UPPERCASE>
```

For example:
- `FIRECORE_DATA_DIR` sets `--data-dir`
- `FIRECORE_LOG_LEVEL` sets `--log-level`

## Examples

### Start a reader node
```bash
firecore start reader-node \
  --data-dir=/var/firehose-data \
  --reader-node-path=/usr/local/bin/geth \
  --reader-node-arguments="--datadir=/var/geth-data --http"
```

### Start firehose gRPC server
```bash
firecore start firehose \
  --data-dir=/var/firehose-data \
  --common-merged-blocks-store-url=gs://my-bucket/merged \
  --firehose-grpc-listen-addr=:13042
```

### Start with configuration file
```bash
firecore --config-file=production.yaml start reader-node
```

## Next Steps

- Learn about [Common Flags](cli/common-flags.md) used across applications
- Explore [Configuration](cli/configuration.md) file options
- See [Chain-Specific Implementations](../chains/supported-chains.md) for additional flags

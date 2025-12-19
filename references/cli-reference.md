# CLI Reference

This document provides a comprehensive reference for the Firehose CLI tools.

## Firecore Binary

The `firecore` binary is the main Firehose executable for all chains except Ethereum-compatible ones.

{% hint style="info" %}
For Ethereum-compatible chains, use the `fireeth` binary which contains all `firecore` functionality plus Ethereum-specific commands and flags. All examples in this guide use `firecore` for simplicity, but `fireeth` works exactly the same way.
{% endhint %}

### Global Flags

Global flags are available across all `firecore` commands:

#### `--data-dir`
- **Description**: Directory to store Firehose data files
- **Default**: `./firehose-data`
- **Environment Variable**: `FIRECORE_GLOBAL_DATA_DIR`

#### `--config-file`
- **Description**: Path to configuration file
- **Default**: None
- **Environment Variable**: `FIRECORE_GLOBAL_CONFIG_FILE`

#### `--log-format`
- **Description**: Logging format to use
- **Options**: `text`, `json`, `stackdriver`
- **Default**: `text` (switches to `stackdriver` in Docker/Kubernetes environments)
- **Environment Variable**: `FIRECORE_GLOBAL_LOG_FORMAT`

{% hint style="info" %}
In Docker or Kubernetes execution environments, the default log format automatically switches to `stackdriver` (JSON format) for better container log processing.
{% endhint %}

### Start Command

The `firecore start` command launches the Firehose stack with various components.

```bash
firecore start [flags]
```

#### Reader Flags

##### `--reader-node-path`
- **Description**: Path to the blockchain node executable
- **Required**: Yes
- **Environment Variable**: `FIRECORE_READER_NODE_PATH`

##### `--reader-node-arguments`
- **Description**: Arguments to pass to the blockchain node
- **Default**: None
- **Environment Variable**: `FIRECORE_READER_NODE_ARGUMENTS`

##### `--reader-node-one-block-suffix`
- **Description**: Suffix for one-block files (supported on Ethereum & NEAR only)
- **Default**: None
- **Environment Variable**: `FIRECORE_READER_NODE_ONE_BLOCK_SUFFIX`

#### Network Flags

##### `--grpc-listen-addr`
- **Description**: Address for Firehose & Substreams gRPC server
- **Default**: `:9000`
- **Environment Variable**: `FIRECORE_GRPC_LISTEN_ADDR`

### Environment Variables

Firehose supports environment variable configuration with specific patterns:

#### Global Flags Pattern
For flags defined at the top level of `firecore`:
```
FIRECORE_GLOBAL_<FLAG_NAME_UPPERCASE>
```

**Example:**
- `--data-dir` → `FIRECORE_GLOBAL_DATA_DIR`
- `--config-file` → `FIRECORE_GLOBAL_CONFIG_FILE`

#### Start Command Flags Pattern
For flags under `firecore start`:
```
FIRECORE_<FLAG_NAME_UPPERCASE>
```

**Example:**
- `--reader-node-one-block-suffix=a` → `FIRECORE_READER_NODE_ONE_BLOCK_SUFFIX=a`
- `--grpc-listen-addr=:9001` → `FIRECORE_GRPC_LISTEN_ADDR=:9001`

### Configuration Files

{% hint style="info" %}
Configuration files are supported as an alternative to command-line flags. In the config file, the `flags` section represents flags available via `firecore start --help` - it's an equivalent method to using command-line arguments.
{% endhint %}

Example configuration file:
```yaml
start:
  flags:
    reader-node-path: "/usr/local/bin/geth"
    reader-node-arguments: "--datadir /data --syncmode full"
    grpc-listen-addr: ":9000"
```

### Getting Help

To see all available commands and flags:

```bash
# General help
firecore --help

# Help for start command
firecore start --help
```

{% hint style="warning" %}
Always verify flag names and defaults using `firecore start --help` as they may change between versions.
{% endhint %}


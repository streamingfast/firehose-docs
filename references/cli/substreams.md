# CLI Reference: Substreams

This page documents the configuration flags for the Substreams Tier 1 and Tier 2 components. For architectural concepts and how Substreams works, see [Substreams Architecture](../../architecture/components/substreams.md).

## Substreams Tier 1

The Tier 1 component serves the Substreams API and handles live block processing.

### Starting Tier 1

```bash
firecore start substreams-tier1 [flags]
```

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

## Substreams Tier 2

The Tier 2 component provides workers for historical block processing.

### Starting Tier 2

```bash
firecore start substreams-tier2 [flags]
```

### Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--substreams-tier2-grpc-listen-addr` | gRPC listening address (append `*` for TLS) | `:10017` |
| `--substreams-tier2-max-concurrent-requests` | Max concurrent requests (0 = no limit) | `0` |
| `--substreams-tier2-segment-execution-timeout` | Max segment execution time | `1h` |
| `--substreams-tier2-discovery-service-url` | Discovery service to advertise presence | |

## Example Usage

### Basic Tier 1 Setup

```bash
firecore start substreams-tier1 \
  --substreams-tier1-grpc-listen-addr=":10016" \
  --substreams-tier1-block-type="sf.ethereum.type.v2.Block" \
  --substreams-tier1-subrequests-endpoint="localhost:10017"
```

### Basic Tier 2 Setup

```bash
firecore start substreams-tier2 \
  --substreams-tier2-grpc-listen-addr=":10017"
```

### With Cloud Storage

```bash
firecore start substreams-tier1 \
  --substreams-tier1-grpc-listen-addr=":10016" \
  --substreams-state-store-url="s3://my-bucket/substreams-state" \
  --common-merged-blocks-store-url="s3://my-bucket/merged-blocks"
```

### With Request Limits

```bash
firecore start substreams-tier1 \
  --substreams-tier1-grpc-listen-addr=":10016" \
  --substreams-tier1-active-requests-soft-limit=50 \
  --substreams-tier1-active-requests-hard-limit=100 \
  --substreams-tier1-default-max-request-per-user=5
```

### Multiple Tier 2 Workers

Run multiple Tier 2 instances for parallel historical processing:

```bash
# Worker 1
firecore start substreams-tier2 --substreams-tier2-grpc-listen-addr=":10017"

# Worker 2
firecore start substreams-tier2 --substreams-tier2-grpc-listen-addr=":10018"

# Worker 3
firecore start substreams-tier2 --substreams-tier2-grpc-listen-addr=":10019"
```

Configure Tier 1 to use multiple workers via discovery service or manual endpoint configuration.

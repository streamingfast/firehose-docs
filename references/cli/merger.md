# CLI Reference: Merger

This page documents the configuration flags for the Merger component. For architectural concepts and how the Merger works, see [Merger Architecture](../../architecture/components/merger.md).

## Starting the Merger

```bash
firecore start merger [flags]
```

## Core Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--merger-grpc-listen-addr` | gRPC listening address for health checks | `:10012` |

## Storage Configuration

The Merger uses the common storage flags:

| Flag | Description | Default |
|------|-------------|---------|
| `--common-one-block-store-url` | One-block files storage URL (input) | `file://{data-dir}/storage/one-blocks` |
| `--common-merged-blocks-store-url` | Merged blocks storage URL (output) | `file://{data-dir}/storage/merged-blocks` |
| `--common-forked-blocks-store-url` | Forked blocks storage URL | `file://{data-dir}/storage/forked-blocks` |

## Timing Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--merger-time-between-store-lookups` | Polling interval for source store | `1s` |
| `--merger-time-between-store-pruning` | Interval between pruning operations | `1m0s` |

## Pruning Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--merger-prune-forked-blocks-after` | Blocks to retain before pruning forks | `50000` |
| `--merger-delete-threads` | Parallel threads for file deletion | `8` |

{% hint style="warning" %}
The pruning distance should be set large enough to handle chain reorganizations. The default of 50,000 blocks is conservative and suitable for most chains.
{% endhint %}

## Execution Control

| Flag | Description | Default |
|------|-------------|---------|
| `--merger-stop-block` | Stop after merging to this block | (none) |

## Health Check

The Merger exposes a gRPC health check endpoint:

```bash
grpcurl -plaintext localhost:10012 grpc.health.v1.Health/Check
```

The Merger always reports `SERVING` status when running - it doesn't have dynamic readiness conditions like other components.

## Example Usage

### Basic Local Setup

```bash
firecore start merger \
  --merger-grpc-listen-addr=":10012"
```

### With Cloud Storage

```bash
firecore start merger \
  --merger-grpc-listen-addr=":10012" \
  --common-one-block-store-url="s3://my-bucket/one-blocks" \
  --common-merged-blocks-store-url="s3://my-bucket/merged-blocks" \
  --common-forked-blocks-store-url="s3://my-bucket/forked-blocks"
```

### Processing to a Specific Block

```bash
firecore start merger \
  --merger-grpc-listen-addr=":10012" \
  --merger-stop-block=1000000
```

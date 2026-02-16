# CLI Reference: Relayer

This page documents the configuration flags for the Relayer component. For architectural concepts and how the Relayer works, see [Relayer Architecture](../../architecture/components/relayer.md).

## Starting the Relayer

```bash
firecore start relayer [flags]
```

## Core Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--relayer-grpc-listen-addr` | gRPC listening address | `:10014` |
| `--relayer-source` | Reader source addresses (repeatable) | `[:10010]` |
| `--common-one-block-store-url` | One-block files storage URL | `file://{data-dir}/storage/one-blocks` |

## Performance Tuning

| Flag | Description | Default |
|------|-------------|---------|
| `--relayer-max-source-latency` | Max tolerated source latency | `999999h` |
| `--relayer-source-request-burst` | Request burst size to upstream sources | (varies) |

{% hint style="info" %}
The default max source latency is very high (`999999h`) - effectively disabled. Set a reasonable value like `30s` for production deployments where you want to filter unresponsive sources.
{% endhint %}

## Connecting Multiple Sources

The `--relayer-source` flag can be specified multiple times:

```bash
firecore start relayer \
  --relayer-grpc-listen-addr=":10014" \
  --relayer-source="reader-1.internal:10010" \
  --relayer-source="reader-2.internal:10010" \
  --relayer-source="reader-3.internal:10010"
```

## Health Check

The Relayer exposes a gRPC health check endpoint with two states:

| Status | Meaning |
|--------|---------|
| `SERVING` | Relayer is synchronized and streaming blocks |
| `NOT_SERVING` | Relayer is starting up or has lost connection to sources |

### Health Check Commands

```bash
# Check current health status
grpcurl -plaintext localhost:10014 grpc.health.v1.Health/Check

# Watch for status changes (polls every 5 seconds)
grpcurl -plaintext localhost:10014 grpc.health.v1.Health/Watch
```

### Kubernetes Integration

```yaml
readinessProbe:
  exec:
    command:
      - grpcurl
      - -plaintext
      - localhost:10014
      - grpc.health.v1.Health/Check
  initialDelaySeconds: 10
  periodSeconds: 5
```

## Example Usage

### Single Reader Setup

```bash
firecore start relayer \
  --relayer-grpc-listen-addr=":10014" \
  --relayer-source="localhost:10010"
```

### Multiple Readers with Latency Filtering

```bash
firecore start relayer \
  --relayer-grpc-listen-addr=":10014" \
  --relayer-source="reader-1.internal:10010" \
  --relayer-source="reader-2.internal:10010" \
  --relayer-max-source-latency="30s"
```

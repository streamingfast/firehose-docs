# CLI Reference: Firehose

This page documents the configuration flags for the Firehose component. For architectural concepts and how the Firehose component works, see [Firehose Architecture](../../architecture/components/firehose.md).

## Starting the Firehose

```bash
firecore start firehose [flags]
```

## Core Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--firehose-grpc-listen-addr` | gRPC listening address | `:10015` |
| `--common-live-blocks-addr` | Relayer gRPC address for live blocks | `:10014` |
| `--common-first-streamable-block` | First block number available to stream | `0` |

## Storage Configuration

| Flag | Description | Default |
|------|-------------|---------|
| `--common-merged-blocks-store-url` | Merged blocks storage URL | `file://{data-dir}/storage/merged-blocks` |
| `--common-one-block-store-url` | One-block files storage URL | `file://{data-dir}/storage/one-blocks` |
| `--common-forked-blocks-store-url` | Forked blocks storage URL | `file://{data-dir}/storage/forked-blocks` |

## Performance Tuning

| Flag | Description | Default |
|------|-------------|---------|
| `--firehose-enforce-compression` | Require gzip or zstd compression | `true` |
| `--firehose-rate-limit-bucket-size` | Rate limit bucket size (-1 = unlimited) | `-1` |
| `--firehose-rate-limit-bucket-fill-rate` | Rate limit refill rate | `10s` |

## Discovery Service

For load-balanced deployments:

| Flag | Description |
|------|-------------|
| `--firehose-discovery-service-url` | gRPC discovery service URL |

## Example Usage

### Basic Local Setup

```bash
firecore start firehose \
  --firehose-grpc-listen-addr=":10015" \
  --common-live-blocks-addr="localhost:10014"
```

### With Cloud Storage

```bash
firecore start firehose \
  --firehose-grpc-listen-addr=":10015" \
  --common-merged-blocks-store-url="s3://my-bucket/merged-blocks" \
  --common-one-block-store-url="s3://my-bucket/one-blocks" \
  --common-forked-blocks-store-url="s3://my-bucket/forked-blocks" \
  --common-live-blocks-addr="relayer.internal:10014"
```

### With Rate Limiting

```bash
firecore start firehose \
  --firehose-grpc-listen-addr=":10015" \
  --firehose-rate-limit-bucket-size=100 \
  --firehose-rate-limit-bucket-fill-rate="1s"
```

## gRPC API

Firehose exposes the `sf.firehose.v2.Stream` service:

```protobuf
service Stream {
  rpc Blocks(Request) returns (stream Response);
}

message Request {
  int64 start_block_num = 1;
  string stop_block_num = 2;    // Empty for live streaming
  string cursor = 3;            // Resume from cursor
  repeated string final_blocks_only = 4;
  repeated google.protobuf.Any transforms = 5;
}
```

### Streaming Modes

1. **Historical range**: Specify start and stop block numbers
2. **Historical to live**: Specify start, omit stop to continue streaming indefinitely
3. **Live only**: Start from a recent block or "head"
4. **Cursor resume**: Provide cursor from previous session

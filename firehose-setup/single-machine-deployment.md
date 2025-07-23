# Single Machine Deployment

This guide shows how to deploy all Firehose components on a single machine using shared local storage. This approach is ideal for development, testing, and small-scale production deployments.

## Overview

In this deployment, all components (`reader-node`, `merger`, `relayer`, `firehose`, `substreams-tier1`, `substreams-tier2`) run as a single process with shared local storage.

```
┌─────────────────────────────────────────┐
│              Single Machine             │
├─────────────────────────────────────────┤
│  Reader Process    │  Firehose Stack    │
│  ┌─────────────┐   │  ┌──────────────┐  │
│  │dummy-blockchain │  │ Reader       │  │
│  │ (subprocess)│───┼──│ Merger       │  │
│  │             │   │  │ Relayer      │  │
│  └─────────────┘   │  │ Firehose &   │  │
│                    │  │ Substreams   │  │
│                    │  └──────────────┘  │
│                    │                    │
│  Shared Local Storage: ./firehose-data  │
└─────────────────────────────────────────┘
```

## Prerequisites

Before starting, ensure you have:

1. **Firecore binary**: Download from [firehose-core releases](https://github.com/streamingfast/firehose-core/releases)
2. **Dummy blockchain binary**: Install with `go install github.com/streamingfast/dummy-blockchain@latest`
3. **Both binaries available in PATH**: Verify with `firecore --help` and `dummy-blockchain --help`
4. **Available ports**: Ensure ports 10010, 10012, 10014, 10015, 10016, 10017 are not in use

{% hint style="warning" %}
**Port Conflicts**: If you encounter "address already in use" errors, check which ports are occupied:
```bash
# Check if ports are in use
netstat -tulpn | grep -E ':(10010|10012|10014|10015|10016|10017)'
```
{% endhint %}

## Step 1: Basic Configuration

Create a working directory and basic configuration:

```bash
# Create working directory
mkdir firehose-deployment
cd firehose-deployment

# Create data directory
mkdir -p firehose-data
```

## Step 2: Start the Firehose Stack

Launch all components using the `firecore` binary:

```bash
firecore start \
  reader-node merger relayer firehose substreams-tier1 substreams-tier2 \
  --config-file="" \
  --data-dir="./firehose-data" \
  --advertise-block-id-encoding="hex" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --reader-node-path="dummy-blockchain" \
  --reader-node-data-dir="./firehose-data/reader-node" \
  --reader-node-arguments="start --tracer=firehose --store-dir=./firehose-data/reader-node --block-rate=120 --genesis-height=0 --genesis-block-burst=100"
```

{% hint style="info" %}
**Default Ports Used:**
- **Firehose**: `:10015` (main gRPC API)
- **Reader**: `:10010` 
- **Relayer**: `:10014`
- **Merger**: `:10012`
- **Substreams Tier1**: `:10016`
- **Substreams Tier2**: `:10017`

The `--config-file=""` flag disables automatic config file loading to prevent conflicts.
{% endhint %}

{% hint style="info" %}
The `dummy-blockchain` runs as a subprocess of the Reader component. The Reader manages its lifecycle and extracts block data from it. See [Reader Component](../architecture/components/reader.md) for more details.
{% endhint %}

## Step 3: Verify the Deployment

Once the stack is running, you should see logs indicating that components are starting up. Let's verify each component is working correctly.

### Check One-Block Files

The Reader component extracts individual blocks and stores them as one-block files:

```bash
# List one-block files (should appear after a few seconds)
ls ./firehose-data/storage/one-blocks/

# Inspect a specific one-block file
firecore tools print one-block ./firehose-data/storage/one-blocks 1 --output=text
```

{% hint style="info" %}
The output will be in protobuf text format, which is expected. This shows the raw block data as extracted by the Reader component.
{% endhint %}

{% hint style="info" %}
One-block files contain individual block data as extracted by the Reader. Learn more about [Data Storage](../architecture/data-storage.md) patterns.
{% endhint %}

### Check Merged Blocks

The Merger component combines one-block files into larger merged block files:

```bash
# List merged block files (should appear after merger processes one-blocks)
ls ./firehose-data/storage/merged-blocks/

# Inspect a merged block file (use an actual filename from the directory)
firecore tools print merged-blocks ./firehose-data/storage/merged-blocks 100 --output=text
```

{% hint style="info" %}
Merged blocks are optimized for efficient storage and streaming. See [Merger Component](../architecture/components/merger.md) for details.
{% endhint %}

### Check Relayer Stream

The Relayer provides live block streaming:

```bash
# Stream live blocks from the relayer (in a separate terminal)
firecore tools relayer stream localhost:10010 -o text +3
```

This command will show the last 3 blocks and then stream new blocks as they arrive.

{% hint style="info" %}
The Relayer enables real-time block streaming for live applications. Learn more about [Relayer Component](../architecture/components/relayer.md).
{% endhint %}

## Step 4: Test the gRPC API

Test the Firehose gRPC API to ensure it's serving blocks correctly:

```bash
# Install grpcurl if not already available
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# List available services
grpcurl -plaintext localhost:10015 list

# Get blocks from the Firehose API
grpcurl -plaintext -d '{"start_block_num": 1, "stop_block_num": 5}' \
  localhost:10015 sf.firehose.v2.Stream/Blocks
```

## Step 5: Test Substreams

Verify that Substreams tiers are working:

```bash
# List Substreams tier1 services
grpcurl -plaintext localhost:10016 list

# List Substreams tier2 services  
grpcurl -plaintext localhost:10017 list

# Test a simple Substreams request (if you have a .spkg file)
# substreams run -e localhost:10016 your-substream.spkg map_blocks -s 1 -t 10
```

{% hint style="info" %}
Substreams runs on separate ports from Firehose:
- **Substreams Tier1**: `:10016` (processing tier)
- **Substreams Tier2**: `:10017` (caching tier)
- **Firehose**: `:10015` (block streaming)
{% endhint %}

## Configuration Options

### Storage Locations

By default, all data is stored under `./firehose-data/storage/`:

- **One-blocks**: `./firehose-data/storage/one-blocks/`
- **Merged blocks**: `./firehose-data/storage/merged-blocks/`
- **Indexes**: `./firehose-data/storage/indexes/`

### Performance Tuning

For better performance, consider:

```bash
# Increase block rate for faster testing
--reader-node-arguments="start --tracer=firehose --store-dir=./firehose-data/reader-node --block-rate=300 --genesis-height=0 --genesis-block-burst=100"

# Use different data directory on faster storage
--data-dir="/fast-ssd/firehose-data"
```

## Monitoring

Monitor your deployment by watching the logs and checking component health:

```bash
# Watch for errors in logs
tail -f firecore.log | grep ERROR

# Check disk usage
du -sh ./firehose-data/

# Monitor block processing rate
watch 'ls ./firehose-data/storage/one-blocks/ | wc -l'
```

## Next Steps

- **Production deployment**: Consider the [Distributed Deployment](distributed-deployment.md) for production use
- **Chain-specific setup**: Adapt these concepts for your target blockchain using [Chain-Specific Implementations](../ethereum/README.md)
- **Advanced configuration**: Explore the [CLI Reference](../references/cli-reference.md) for more options

{% hint style="success" %}
You now have a fully functional Firehose deployment! The same patterns shown here with `dummy-blockchain` can be applied to any Firehose-enabled blockchain.
{% endhint %}

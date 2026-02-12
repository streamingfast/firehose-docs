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

Create a working directory:

```bash
# Create working directory
mkdir firehose-workspace
cd firehose-workspace
```

## Step 2: Start the Firehose Stack

Launch all components using the `firecore` binary:

```bash
firecore start \
  reader-node merger relayer firehose substreams-tier1 substreams-tier2 \
  --config-file="" \
  --data-dir="./firehose-data" \
  --advertise-chain-name="acme-dummy-blockchain" \
  --reader-node-path="dummy-blockchain" \
  --reader-node-data-dir="./firehose-data/reader-node" \
  --reader-node-arguments="start --tracer=firehose --store-dir={data-dir}/reader --block-rate=120"
```

{% hint style="info" %}
**Default Ports Used:**
- **Firehose**: `:10015` (gRPC - [sf.firehose.v2.Stream](https://buf.build/streamingfast/firehose/docs/main:sf.firehose.v2))
- **Reader**: `:10010` (gRPC - internal reader protocol)
- **Relayer**: `:10014` (gRPC - live block streaming)
- **Merger**: `:10012` (gRPC - internal merger protocol)
- **Substreams Tier1**: `:10016` (gRPC - [sf.substreams.rpc.v2.Stream](https://buf.build/streamingfast/substreams/docs/main:sf.substreams.rpc.v2))
- **Substreams Tier2**: `:10017` (gRPC - internal tier1 <=> tier2 protocol)

The `--config-file=""` flag disables automatic config file loading switching into a flags only mode.
{% endhint %}

{% hint style="info" %}
The `dummy-blockchain` runs as a subprocess of the Reader component. The Reader manages its lifecycle and extracts block data from it. Extracted data is exchanged through stdout pipe to the Reader component and contains chain's specific Protobuf block and metadata. See [Reader Component](../architecture/components/reader.md) for more details.
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

This command will show the last 3 blocks and then stop the stream.

{% hint style="info" %}
The Relayer enables real-time block streaming for live applications. Learn more about [Relayer Component](../architecture/components/relayer.md).
{% endhint %}

## Step 4: Test the Firehose API

Test the Firehose API using the built-in client tools:

```bash
# Get blocks 1-5 from the Firehose API
firecore tools firehose-client -p localhost:10015 -o text -- 1:5

# Get a single block (block 5)
firecore tools firehose-single-block-client -p localhost:10015 -o text -- 5

# View full block data in JSON format
firecore tools firehose-single-block-client -p localhost:10015 -o protojson -- 5

# Alternative JSON output
firecore tools firehose-single-block-client -p localhost:10015 -o json -- 5
```

## Step 5: Test Substreams

Verify that Substreams tiers are working:

```bash
# Test a simple Substreams request
substreams run -e localhost:10016 -p common@v0.1.0 -s 1 -t +5
```

## Configuration Options

### Storage Locations

By default, all data is stored under `./firehose-data/storage`:

- **One-blocks**: `./firehose-data/storage/one-blocks` (controlled by `--common-one-block-store-url`)
- **Merged blocks**: `./firehose-data/storage/merged-blocks` (controlled by `--common-merged-blocks-store-url`)

These paths are shared among all components and can be customized using the respective flags. The `--data-dir` flag sets the base directory for all storage locations.

## Next Steps

- **Production deployment**: Consider the [Distributed Deployment](distributed-deployment.md) for production use
- **Chain-specific setup**: Adapt these concepts for your target blockchain using [Chain-Specific Implementations](../ethereum/README.md)
- **Advanced configuration**: Explore the [CLI Reference](../references/cli-reference.md) for more options

{% hint style="success" %}
You now have a fully functional Firehose deployment! The same patterns shown here with `dummy-blockchain` can be applied to any Firehose-enabled blockchain.
{% endhint %}

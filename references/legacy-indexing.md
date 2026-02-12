---
description: Legacy Firehose indexing and transforms (deprecated)
---

# Legacy Firehose Indexing

{% hint style="warning" %}
**Deprecation Notice**: Firehose indexing and transforms are legacy features primarily used for graph-node integration. For new projects, use [Substreams](https://substreams.streamingfast.io/) for data filtering and transformation instead.
{% endhint %}

## Overview

Firehose can generate block indexes that optimally serve requests containing filtering parameters. This feature was designed primarily for graph-node integration and is not recommended for general use.

## How Indexes Work

Firehose indexes function in two primary ways:

1. **Block skipping**: Block files aren't read for ranges within block indexes that do not match the filter provided.
2. **Payload reduction**: Block files containing both matching and non-matching transactions return a reduced payload of only matched transactions.

## Enabling Indexes

{% hint style="info" %}
Blockchains have varying levels of support for indexes. For example, `firehose-ethereum` has support while many other chains do not.
{% endhint %}

### Index Configuration Flags

Use the following flag for valid index bundle sizes when looking for block indexes:

```
--common-index-block-sizes [ints]
```

Default values: `100000,10000,1000,100`

Common store URL to read and write index files:

```
--common-index-store-url [string]
```

Default: `file://{sf-data-dir}/storage/index`

## Index Builder

The Firehose Index Builder generates index files from merged blocks. It can be run:

- **Sequentially**: To produce indexes as merged-blocks are produced
- **In parallel**: Multiple instances over different block ranges to quickly process millions of blocks

### Running the Index Builder

```bash
fireeth start combined-index-builder \
  --combined-index-builder-index-size=10000 \
  --combined-index-builder-start-block=1000000 \
  --combined-index-builder-stop-block=2000000 \
  --common-index-store-url=s3://mybucket/mainnet-indexes \
  --common-blocks-store-url=s3://mybucket/mainnet-blocks
```

## Transforms

Transforms are Protocol Buffer definitions used to locate specific blocks according to search criteria. They are used by graph-node to filter blockchain data before indexing.

### Ethereum Transforms

For Ethereum, transforms support filtering by:

- **Log filters**: Match transactions containing logs with specific addresses and topics
- **Call filters**: Match transactions containing calls to specific addresses

### Example: Log Filter

Match transactions with logs from a specific address and topic:

```bash
fireeth tools firehose-client api.streamingfast.io:443 15289746 15307883 \
  --log-filters=0xa5b7f12346048e8a3e780dbeb4c2f469be8ffcef:0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
```

### Example: Call Filter

Match transactions containing calls to specific addresses:

```bash
fireeth tools firehose-client api.streamingfast.io:443 15290180 15290300 \
  --call-filters=0xa5b7f12346048e8a3e780dbeb4c2f469be8ffcef+0xfeaf24248e04ac7ad0ea6e7e617182cff429d4e5:
```

### Transform Protocol Buffers

Transforms are defined in the chain-specific protobuf definitions. For Ethereum, see the `CombinedFilter` in:

[sf/ethereum/transform/v1/transforms.proto](https://github.com/streamingfast/firehose-ethereum/blob/develop/proto/sf/ethereum/transform/v1/transforms.proto)

## graph-node Integration

The primary use case for indexing and transforms is graph-node integration. When running graph-node with Firehose:

1. graph-node sends transform filters based on subgraph manifest requirements
2. Firehose uses indexes to skip irrelevant block ranges
3. Only matching data is returned to graph-node for indexing

For graph-node setup with Firehose, refer to [The Graph documentation](https://thegraph.com/docs/).

## Migration to Substreams

For new data filtering and transformation needs, use Substreams instead:

- **Better performance**: Parallel processing with caching
- **More flexibility**: Custom Rust/WASM logic
- **Ecosystem support**: Multiple output sinks available

See the [Substreams documentation](https://docs.substreams.dev) for details.

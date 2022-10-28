---
description: StreamingFast Firehose indexing
---

# Indexing

## Indexing

Firehose can generate block indexes that optimally serve requests containing filtering parameters.

Firehose indexes function in _two_ primary fashions.

1. Block files aren’t read for ranges within block indexes that do not match the filter provided.
2. Block files containing both matching and non-matching transactions for the filter will return a reduced payload of only the matched transactions.

## Enabling Indexes

Blockchains have varying levels of support for indexes. For example, `firehose-ethereum` has support while `firehose-arweave` currently does not.

Enabling indexes for Firehose is accomplished through flags passed to the binary when running the fireeth executable. When enabling indexes, ensure the flags are set and the URL makes logical sense for the deployment being created.&#x20;

Use the following flag for valid index bundle sizes when looking for block indexes.&#x20;

`--common-block-index-sizes [ints]`                 &#x20;

{% hint style="info" %}
**Note**: _The default values are 100000,100000,10000,1000._
{% endhint %}

Common store URL, with prefix, to read and write index files.

`--common-index-store-url [string]`                &#x20;

{% hint style="info" %}
**Note**: The default value is:&#x20;

`file://{sf-data-dir}/storage/index`
{% endhint %}

## Index Builder

The Firehose Index Builder provides functionality for generating index files. Developers can utilize this tool through the combined-index-builder application provided by the Firehose fireeth binary.

The Firehose Index Builder can be run sequentially to produce indexes as merged-blocks are produced.&#x20;

Alternatively The Firehose Index Builder can be run multiple times in parallel over different block ranges to quickly process millions of blocks.

Use the following command to run the Firehose Index Builder to generate index files.

```
fireeth start combined-index-builder --combined-index-builder-index-size=10000 --combined-index-builder-start-block=1000000 --combined-index-builder-stop-block=2000000 --common-index-store-url=s3://mybucket/mainnet-indexes --common-blocks-store-url=s3://mybucket/mainnet-blocks
```

Some chains, such as Cosmos, may expose the Firehose Index Builder under the `tools` command.

Use the following commands to run the Firehose Index Builder to generate index files for chains that expose the functionality through the `tools` command.

```
firecosmos tools generate-event-origin-index {index-url} {source-blocks-url} {start-block-num} {stop-block-num}
```

```
firecosmos tools generate-event-type-index {index-url} {source-blocks-url} {start-block-num} {stop-block-num}
```

```
firecosmos tools generate-message-type-index {index-url} {source-blocks-url} {start-block-num} {stop-block-num}
```

## Using Indexes Within Firehose Requests

{% hint style="warning" %}
**Important**: As previously mentioned, certain blockchains provide support for indexes at this time. For example, `firehose-ethereum` has support while `firehose-arweave` currently does not.
{% endhint %}

### Ethereum

Filters are specified using the firehose-client tool. The following example illustrates how to match transactions that contain logs tied to a specific address and topic.

Example address:

0xa5b7f12346048e8a3e780dbeb4c2f469be8ffcef

Example topic:

0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef

Use the following command to match topics to a specific address.

```
fireeth tools firehose-client  api.streamingfast.io:443  15289746 15307883    --log-filters=0xa5b7f12346048e8a3e780dbeb4c2f469be8ffcef:0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
```

The command will return the following blocks.

```
[15289746(startBlock, no transactions), 15295215, 15307816, 15307882, 15308252(stopBlock, no transactions)]
```

Example addresses:&#x20;

\[0xa5b7f12346048e8a3e780dbeb4c2f469be8ffcef, 0xfeaf24248e04ac7ad0ea6e7e617182cff429d4e5]

Use the following command to match transactions containing calls to one of the addresses listed above.

```
fireeth tools firehose-client  api.streamingfast.io:443  15290180 15290300    --call-filters=0xa5b7f12346048e8a3e780dbeb4c2f469be8ffcef+0xfeaf24248e04ac7ad0ea6e7e617182cff429d4e5:
```

The command will return the following blocks.

```
[15290180(startBlock, no transactions), 15290186, 15290293, 15290300(stopBlock, no transactions)]
```

Create a CombinedFilter object and place it in the Transforms array in the Firehose request.

See the CombinedFilter in the `transforms` protobuf in the following code example.

[https://github.com/streamingfast/firehose-ethereum/blob/develop/proto/sf/ethereum/transform/v1/transforms.proto#L24](https://github.com/streamingfast/firehose-ethereum/blob/develop/proto/sf/ethereum/transform/v1/transforms.proto#L24)

### Cosmos

The `firehose-client` tool for Cosmos does not currently implement filters.

Use the following protobuf file instead.

[https://github.com/figment-networks/proto-cosmos/blob/main/sf/cosmos/transform/v1/transform.proto](https://github.com/figment-networks/proto-cosmos/blob/main/sf/cosmos/transform/v1/transform.proto)

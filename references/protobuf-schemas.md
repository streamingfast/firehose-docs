---
description: StreamingFast Firehose schemas
---

# Schemas

## Chain-specific schemas

Firehose currently has Layer 1 Protocol Buffer schemas for several different blockchains. Follow the links below to find the schemas relevant to the blockchain being targeted.

* [Ethereum Protobuf Definitions](https://github.com/streamingfast/firehose-ethereum/blob/develop/proto/sf/ethereum/type/v2/type.proto)
* [NEAR Protobuf Definitions](https://github.com/streamingfast/firehose-near/blob/develop/proto/sf/near/type/v1/type.proto)
* Solana Protobuf Definitions:
  * [Solana Block data model](https://github.com/streamingfast/sf-solana/blob/develop/proto/sf/solana/type/v1/type.proto) (original)
  * [Solana Account Changes data model](https://github.com/streamingfast/firehose-solana/blob/develop/proto/sf/solana/type/v1/account.proto) (account changes only)
* [Arweave Protobuf Definitions](https://github.com/streamingfast/firehose-arweave/blob/develop/proto/sf/arweave/type/v1/type.proto)
* [Aptos Protobuf Definitions](https://github.com/aptos-labs/aptos-core/blob/main/crates/aptos-protos/proto/aptos/extractor/v1/extractor.proto)

## The `bstream` Block

The `bstream` Block is the main blockchain-agnostic object flowing throughout Firehose.

{% hint style="info" %}
**Note**: _The_ `stream` _Block is the envelope used to pass blockchain-specific Block objects, for Ethereum, as an example._
{% endhint %}

## Versioning

### _**Coming Soon**_

Discussion on general multi-chain considerations of versioning in the Firehose suite to answer questions such as:

* when do we change the namespace,
* when do we bump the `version` field in the `block`.

---
description: StreamingFast Firehose schemas
---

# Schemas

### Chain-specific schemas

Firehose currently has Layer 1 Protocol Buffer schemas for several different blockchains. Follow the links below to find the schemas relevant to the blockchain being targeted.

* [Ethereum Protobuf Definitions](https://github.com/streamingfast/sf-ethereum/blob/develop/proto/sf/ethereum/type/v1/type.proto)
* [NEAR Protobuf Definitions](https://github.com/streamingfast/sf-near/blob/develop/proto/sf/near/codec/v1/codec.proto)
* Solana Protobuf Definitions:
  * [Version 1](https://github.com/streamingfast/sf-solana/blob/develop/proto/sf/solana/type/v1/type.proto), original Solana data model
  * [Version 2](https://github.com/streamingfast/sf-solana/blob/develop/proto/sf/solana/type/v2/type.proto), StreamingFast enriched data model
* [Cosmos Protobuf Definitions](https://github.com/figment-networks/proto-cosmos/blob/main/sf/cosmos/type/v1/type.proto)
* [Arweave Protobuf Definitions](https://github.com/streamingfast/firehose-arweave/blob/develop/proto/sf/arweave/type/v1/type.proto)
* [Aptos Protobuf Definitions](https://github.com/streamingfast/firehose-aptos/blob/main/proto/sf/aptos/type/v1/type.proto)

### The `bstream` Block

The `bstream` Block is the main blockchain-agnostic object flowing throughout Firehose.&#x20;

The `bstream` Block is the _envelope_ used to pass blockchain-specific _Block_ objects, for Ethereum, as an example.

What are the important fields, their constraints and meaning. `parent_id`, `lib_num`, considerations for their determinism.

### Versioning

**Coming Soon**

Discussion on general multi-chain considerations of versioning in the Firehose suite to answer questions such as:

* when do we change the namespace,&#x20;
* when do we bump the `version` field in the `block`.

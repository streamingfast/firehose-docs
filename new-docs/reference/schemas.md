# Schemas

## Chain-specific schemas

_<mark style="color:yellow;">**\[\[slm:] content has not been updated below this line.]**</mark>_

Here is a quick reference to all the known Layer 1 Firehose Protocol Buffer schemas:

* [Ethereum Protobuf Definitions](https://github.com/streamingfast/sf-ethereum/blob/develop/proto/sf/ethereum/type/v1/type.proto)
* [NEAR Protobuf Definitions](https://github.com/streamingfast/sf-near/blob/develop/proto/sf/near/codec/v1/codec.proto)
* Solana Protobuf Definitions:
  * [Version 1](https://github.com/streamingfast/sf-solana/blob/develop/proto/sf/solana/type/v1/type.proto), original Solana data model
  * [Version 2](https://github.com/streamingfast/sf-solana/blob/develop/proto/sf/solana/type/v2/type.proto), StreamingFast enriched data model
* [Cosmos Protobuf Definitions](https://github.com/figment-networks/proto-cosmos/blob/main/sf/cosmos/type/v1/type.proto)
* [Arweave Protobuf Definitions](https://github.com/streamingfast/firehose-arweave/blob/develop/proto/sf/arweave/type/v1/type.proto)
* [Aptos Protobuf Definitions](https://github.com/streamingfast/firehose-aptos/blob/main/proto/sf/aptos/type/v1/type.proto)

## The `bstream` Block

As the main object, blockchain-agnostic, flowing throughout the Firehose. It's the _envelope_ used to pass blockchain-specific _Block_ objects (like Ethereum's, etc..)

What are the important fields, their constraints and meaning. `parent_id`, `lib_num`, considerations for their determinism.

## Versioning

\[discuss the general (any blockchain) considerations of versioning in the Firehose suite, when do we change the namespace, when do we bump the `version` field in the `block`.

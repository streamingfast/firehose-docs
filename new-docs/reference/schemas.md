# Schemas

## Chain-specific schemas

Here is a quick reference to all the known Layer 1 Firehose Protocol Buffer schemas:

* [Ethereum Protobuf Definitions](https://github.com/streamingfast/sf-ethereum/blob/develop/proto/sf/ethereum/type/v1/type.proto)
* [NEAR Protobuf Definitions](https://github.com/streamingfast/sf-near/blob/develop/proto/sf/near/codec/v1/codec.proto)
* Solana Protobuf Definitions
* Cosmos Protobuf Definitions

## The \`bstream\` Block

as the main object, blockchain-agnostic, flowing throughout the Firehose. It's the _envelope_ used to pass blockchain-specific _Block_ objects (like Ethereum's, etc..)

What are the important fields, their constraints and meaning. `parent_id`, `lib_num`, considerations for their determinism.

## Versioning

\[discuss the general (any blockchain) considerations of versioning in the Firehose suite, when do we change the namespace, when do we bump the `version` field in the `block`.

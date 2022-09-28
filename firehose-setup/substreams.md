---
description: StreamingFast Substreams with Firehose documentation
---

# Substreams

### Firehose vs Substreams

It's important to realize that Firehose and Substreams are two unique, separate applications. Firehose consumes blockchain data and provides binary block data in a streaming fashion.

Substreams consumes Firehose block stream data and provides a mechanism for developers to harness very targeted types of block data through custom protobuf schemas.

Firehose does expose some Substreams functionality in its core install. So, while there is some overlap between the applications, they aren't the same thing. The installation and operation procedures are both different as well. The main thing to remember is Firehose and Substreams work together in harmony to provide exceptionally fast access to blockchain data for DApps and Web3 development efforts.

### Run Firehose with Substreams

Learn more about using Firehose with Substreams in [the documentation](https://substreams.streamingfast.io/reference-and-specs/advanced/running-locally).

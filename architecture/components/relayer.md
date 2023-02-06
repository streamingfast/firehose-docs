---
description: StreamingFast Firehose relayer component
---

# Relayer

## Relayer Component in Detail

The Relayer component is responsible for providing executed block data to other Firehose components.

The Relayer component feeds from all available Reader nodes to get a comprehensive view of all possible forks.

The Relayer "fans out", or relays, block information to the other Firehose components.

### Relayer & gRPC

The Relayer component serves its block data through the streaming gRPC interface `BlockStream::Blocks`. This is the _same interface_ that the Reader component exposes to the Relayer component. Read more about the `BlockStream::Blocks` interface in [its GitHub repository](https://github.com/streamingfast/proto/blob/develop/sf/bstream/v1/bstream.proto).

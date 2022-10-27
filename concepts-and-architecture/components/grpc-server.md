---
description: StreamingFast Firehose gRPC server component
---

# gRPC Server

### Firehose gRPC Server

#### gRPC Server in Detail

The Firehose gRPC Server component is responsible for providing the extracted, formed, and collated blockchain data handled by the other Firehose components.

#### Historical Data

Firehose will use merged blocks from data storage directly for historical requests.&#x20;

#### Live Data

Live blocks are received from the Relayer component.&#x20;

#### Relayer & Reader Coordination

The Relayer component gets its data from one, or more, Reader components.

#### Serving Data

The Firehose gRPC Server component provides the data to the end consumer of Firehose through remote method calls to the server.

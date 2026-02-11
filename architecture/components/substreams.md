---
description: StreamingFast Firehose Substreams component
---

# Substreams

## Substreams Component in Detail

The Substreams component provides high-performance, parallelized blockchain data transformation and filtering capabilities. It enables consumers to define custom data pipelines that execute directly within the Firehose infrastructure.

### Why Operators Should Run Substreams

Running Substreams alongside Firehose provides significant value to operators and their users:

* **Value-Added Service**: Offer more than raw block data. Substreams enables users to transform, filter, and aggregate blockchain data in real-time.
* **Infrastructure Reuse**: Substreams shares the same storage and data sources as Firehose. Running it adds minimal overhead while significantly expanding your service capabilities.
* **Parallel Processing**: Substreams processes historical blockchain data in a massively parallelized manner, enabling processing speeds previously thought impossible.
* **Ecosystem Compatibility**: Immediate support for The Graph (Substreams-powered subgraphs), dozens of data sinks (PostgreSQL, MongoDB, Kafka, ClickHouse, BigQuery, etc.), and the broader StreamingFast ecosystem.
* **Developer Attraction**: Activate a community of developers who already know Substreams and will be eager to use your infrastructure.

### How Substreams Works

Substreams modules are written in Rust, compiled to WebAssembly (WASM), and executed within the Substreams engine. Users define their data transformation logic in `.spkg` (Substreams Package) files containing:

* **Map modules**: Transform input blocks into custom output types
* **Store modules**: Aggregate data across blocks (counters, accumulators, state)
* **Index modules**: Create filter conditions for efficient block skipping

When a user runs a Substreams request, the engine:

1. Reads block data from the same merged block storage used by Firehose
2. Executes the user's WASM modules against each block
3. Streams the transformed output back to the consumer
4. Caches intermediate results for future requests

### Substreams Tier Architecture

Substreams uses a two-tier architecture to optimize for both real-time streaming and parallel historical processing:

#### Substreams Tier 1

The Tier 1 component is the primary entry point for Substreams requests:

* Handles incoming gRPC requests from consumers
* Manages live block streaming (connects to Relayer for real-time data)
* Coordinates parallel historical processing by dispatching work to Tier 2 instances
* Merges results from Tier 2 workers into a cohesive output stream
* Manages output caching for frequently-requested data ranges

#### Substreams Tier 2

The Tier 2 component provides the parallel processing backbone:

* Executes WASM modules against historical block ranges
* Processes multiple block ranges simultaneously across multiple instances
* Stores execution results in cache storage for reuse
* Scales horizontally to handle large parallel workloads

{% hint style="info" %}
**Scaling Strategy**: Tier 1 handles request coordination and live blocks, while Tier 2 scales horizontally for historical processing. In high-load scenarios, add more Tier 2 instances while keeping fewer Tier 1 instances.
{% endhint %}

### Component Dependencies

The Substreams components depend on other Firehose components:

* **Merged Blocks Storage**: Both tiers read block data from the same storage used by Firehose
* **One-Block Storage**: Required for accessing recent blocks not yet merged
* **Relayer**: Tier 1 connects to the Relayer for live block streaming
* **Cache Storage**: Both tiers use shared cache storage for execution results

```
┌─────────────────────────────────────────────────────────────┐
│                    Consumer Request                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Substreams Tier 1                        │
│  • Request handling       • Live streaming (via Relayer)    │
│  • Work coordination      • Result merging                  │
└─────────────────────────────────────────────────────────────┘
           │                                    │
           │ (historical ranges)                │ (live blocks)
           ▼                                    ▼
┌─────────────────────────┐      ┌─────────────────────────────┐
│   Substreams Tier 2     │      │         Relayer             │
│   (parallel workers)    │      │    (live block source)      │
│  ┌─────┐ ┌─────┐ ┌─────┐│      └─────────────────────────────┘
│  │ T2  │ │ T2  │ │ T2  ││
│  └─────┘ └─────┘ └─────┘│
└─────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│                    Shared Storage                           │
│  • Merged Blocks    • One-Blocks    • Substreams Cache      │
└─────────────────────────────────────────────────────────────┘
```

### Production Considerations

#### Caching

Substreams execution results are cached, meaning subsequent requests for the same block ranges with the same modules will be served from cache. This is particularly valuable for:

* Popular Substreams packages used by multiple consumers
* Development workflows where users iterate on downstream processing
* High-availability setups where results survive instance restarts

#### Resource Requirements

* **Tier 1**: Moderate CPU/memory for coordination; network-intensive for streaming
* **Tier 2**: CPU-intensive for WASM execution; scales with parallelism needs
* **Storage**: Cache storage grows with unique Substreams package usage

#### High Availability

For production deployments:

* Run multiple Tier 1 instances behind a load balancer
* Scale Tier 2 instances based on historical processing demand
* Use shared cache storage accessible by all instances

### Default Ports

| Component | Default Port | Purpose |
|-----------|--------------|---------|
| Substreams Tier 1 | `:10016` | Consumer-facing gRPC API |
| Substreams Tier 2 | `:10017` | Internal processing API |

### gRPC Services

Substreams exposes the following gRPC services:

* `sf.substreams.rpc.v2.Stream/Blocks` - Main streaming endpoint for Substreams execution

### What Consumers Can Build

With Substreams, your users can build:

* **Real-time Analytics**: Live dashboards, trading signals, protocol metrics
* **Custom Indexers**: Purpose-built indexes for specific protocols or use cases
* **Data Pipelines**: ETL workflows feeding databases, data warehouses, or message queues
* **The Graph Subgraphs**: Substreams-powered subgraphs with dramatically improved sync times
* **Cross-Chain Applications**: Consistent data processing across multiple blockchains

{% hint style="success" %}
**Operator Benefit**: Running Substreams differentiates your infrastructure from basic RPC providers. Users get powerful data transformation capabilities without managing their own indexing infrastructure.
{% endhint %}

---
description: StreamingFast Firehose template for new chain integrations
---

# Firehose Starter

Instrumenting a new chain requires the blockchain node to output [Firehose Logs](../architecture/data-flow.md#firehose-logs) — a simple, unified protocol consisting of `FIRE INIT` and `FIRE BLOCK` messages. Any chain that implements this protocol automatically benefits from the entire Firehose ecosystem.

The Firehose Logs protocol is chain-agnostic: the node outputs block data as base64-encoded protobuf, and `firehose-core` handles the rest. The chain-specific parts are:

1. **Node instrumentation**: Modify your blockchain node to output `FIRE INIT` and `FIRE BLOCK` messages
2. **Protobuf schema**: Define your chain's block data model

That's it — most chains only need these two pieces. No custom binary required.

## Implement Node Instrumentation

The key integration work is implementing the [Firehose Logs protocol](../architecture/data-flow.md#firehose-logs-protocol) in your blockchain node. The node must output:

1. `FIRE INIT` once at startup with the protocol version and protobuf block type
2. `FIRE BLOCK` for each block with metadata and base64-encoded protobuf payload

See the [dummy-blockchain tracer](https://github.com/streamingfast/dummy-blockchain/tree/main/tracer) for a reference implementation.

## Define Protobuf Types

Create protobuf definitions that model your chain's block data structure. The block type name must match what your instrumented node outputs in the `FIRE INIT` message.

Publish your protobuf definitions to the [Buf registry](https://buf.build) to use `firecore` directly, or keep them local if building a custom binary.

## Using `firecore` Directly

If your protobuf block definitions are published to the [Buf registry](https://buf.build), you can use `firecore` directly without building any chain-specific binary:

```bash
firecore start reader-node \
  --reader-node-path=/path/to/your/instrumented-node \
  --reader-node-proto-type=buf.build/myorg/mychain:sf.mychain.type.v1.Block
```

This is the simplest integration path and works for most chains.

## Optional: Custom `firehose-<chain>` Binary

For chains that need custom CLI commands, specialized tooling, or prefer not to use the Buf registry, you can create a `firehose-<chain>` wrapper around `firehose-core`.

We provide a template project [firehose-acme](https://github.com/streamingfast/firehose-acme) as a starting point. It includes scaffolding code and a [dummy-blockchain](https://github.com/streamingfast/dummy-blockchain) example.

Copy the template:

```bash
git clone git@github.com:streamingfast/firehose-acme firehose-mychain
cd firehose-mychain
```

### Rename to Your Chain

Rename all references from "acme" to your chain's name. Choose two names:

* **Long form**: Full chain name (e.g., `arweave`, `solana`, `ethereum`)
* **Short form**: 3-4 letter abbreviation (e.g., `arw`, `sol`, `eth`)

Perform the following replacements:

* Rename `cmd/fireacme` → `cmd/fire<short>` (e.g., `cmd/firearw`)
* Search and replace `fireacme` → `fire<short>`
* Search and replace `acme` → `<long>` (case-sensitive for `acme`, `ACME`, `Acme`)

Update the proto file path `sf/acme/type/v1/type.proto` and regenerate Go structs:

```bash
./types/pb/generate.sh
```

### Development & Testing

The template includes a development script that starts Firehose with the dummy-blockchain:

```bash
./devel/standard/start.sh
```

This uses the configuration in [devel/standard/standard.yaml](https://github.com/streamingfast/firehose-acme/blob/master/devel/standard/standard.yaml). Modify `start.flags.reader-node-path` to point to your instrumented node binary.

Run the test suite:

```bash
go test ./...
```

{% hint style="info" %}
You can reach out to the StreamingFast team on Discord. We usually maintain these Go-side integrations and can help with the initial setup.
{% endhint %}

## Register Your Chain

Once your integration is working, register your chain in The Graph's networks registry to make it discoverable by the ecosystem.

### The Graph Networks Registry

Add your chain to [The Graph Networks Registry](https://github.com/graphprotocol/networks-registry) by following their [adding/updating a chain guide](https://github.com/graphprotocol/networks-registry?tab=readme-ov-file#addingupdating-a-chain).

The registry entry includes metadata about your chain such as:
* Chain ID and name
* Firehose and Substreams endpoints
* Block type information

### Update Well-Known Protobuf Descriptors

After your chain is registered, update `firehose-core` to include your chain's protobuf descriptors in the well-known types. This enables better tooling support across the ecosystem.

1. Run the [registry generator](https://github.com/streamingfast/firehose-core/blob/develop/proto/registry.go#L21) to regenerate the well-known descriptors
2. Open a PR to `firehose-core` with the updated descriptors

{% hint style="info" %}
The StreamingFast team can help with this step — reach out on Discord after your chain is registered.
{% endhint %}

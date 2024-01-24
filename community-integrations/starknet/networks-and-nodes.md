---
description: Starknet networks and nodes
---

# Starknet networks

## Public networks

A few public Starknet networks are live, and are uniquely identified as follows:

| Identifier                     | Layer 1                  | Description                                                  |
| ------------------------------ | ------------------------ | ------------------------------------------------------------ |
| `starknet-mainnet`             | Ethereum mainnet         | The main canonical Starknet where valuable assets are stored |
| `starknet-sepolia`             | Ethereum Sepolia testnet | The latest testnet which developers are encouraged to use    |
| `starknet-goerli`              | Ethereum Goerli testnet  | The original testnet which will be deprecated soon           |
| `starknet-sepolia-integration` | Ethereum Sepolia testnet | A canary network for SDK and node developers                 |
| `starknet-goerli-integration`  | Ethereum Goerli testnet  | A canary network for SDK and node developers                 |

{% hint style="success" %}
**Tip**: Firehose does not know or care about the assigned identifiers. These identifiers are useful only in [`graph-node`](https://github.com/starknet-graph/graph-node) and [`graph-cli`](https://github.com/graphprotocol/graph-tooling/tree/main/packages/cli).
{% endhint %}

## Local development networks

It's also possible to run a vastly simplified Starknet network for local development. The [`katana` tool from `dojo`](https://github.com/dojoengine/dojo/tree/main/crates/katana) is a popular option.

Note that since these networks aren't real Starknet, it's not possible to synchronize a full node with such a network. However, this does _not_ mean it's impossible to run a Firehose stack on such a network, as you can use the [`jsonrpc-to-firestark` pseudo node](#jsonrpc-to-firestark).

# Pre-instrumented nodes

All instrumented nodes are available in 3 different distributions:

- as a standalone Docker image (supports both AMD64 and ARM64) where the node binary is available as the entrypoint;
- as a `firehose-starknet` Docker image (supports both AMD64 and ARM64) where `firestark` is the entrypoint, but the node binary is available on `PATH`;
- and of course, as source code that you can directly compile from.

{% hint style="info" %}
**Note**: Precompiled binaries are not available at the moment. However, you can always [use Docker images](./local-deployment-with-docker.md) for the entire stack.
{% endhint %}

## `pathfinder`

A Starknet node implemented in Rust.

| Distribution                                          | Link                                                                                           |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Standalone Docker image (multi-arch)                  | [`starknet/pathfinder-firehose:0.10.2`](https://hub.docker.com/r/starknet/pathfinder-firehose) |
| `firehose-starknet` bundled Docker image (multi-arch) | [`starknet/firestark:0.2.1-pathfinder-0.10.2`](https://hub.docker.com/r/starknet/firestark)    |
| Source code                                           | [`starknet-graph/pathfinder`](https://github.com/starknet-graph/pathfinder)                    |

## `juno`

A Starknet node implemented in Go.

| Distribution                                          | Link                                                                                 |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------ |
| Standalone Docker image (multi-arch)                  | [`starknet/juno-firehose:0.8.1`](https://hub.docker.com/r/starknet/juno-firehose)    |
| `firehose-starknet` bundled Docker image (multi-arch) | [`starknet/firestark:0.2.1-juno-0.8.1`](https://hub.docker.com/r/starknet/firestark) |
| Source code                                           | [`starknet-graph/juno`](https://github.com/starknet-graph/juno)                      |

## `jsonrpc-to-firestark`

A pseudo node that does not actually synchronize with the network. Instead, it relies on a trusted JSON-RPC endpoint on an existing synchronized full node to collect and emit the same data format expected by Firehose to the standard output.

This pseudo node exists because currently Starknet full nodes cannot synchronize through P2P, but instead only from a centralized sequencer API, which is heavily rate-limited. Having to synchronize from scratch via the sequencer could take an extended period of time. `jsonrpc-to-firestark` significantly speeds up the process if there's an already-synchronized node under the same network.

An additional use case for `jsonrpc-to-firestark` is to "synchronize" with local development networks where full nodes cannot be used.

| Distribution                                          | Link                                                                                            |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Standalone Docker image (multi-arch)                  | [`starknet/jsonrpc-to-firestark:0.4.0`](https://hub.docker.com/r/starknet/jsonrpc-to-firestark) |
| `firehose-starknet` bundled Docker image (multi-arch) | [`starknet/firestark:0.2.1-jsonrpc-0.4.0`](https://hub.docker.com/r/starknet/firestark)         |
| Source code                                           | [`starknet-graph/jsonrpc-to-firestark`](https://github.com/starknet-graph/jsonrpc-to-firestark) |

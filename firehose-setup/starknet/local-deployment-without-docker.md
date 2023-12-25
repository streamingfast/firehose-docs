---
description: Firehose Starknet local deployment without Docker
---

{% hint style="info" %}
**Note**: As an example, this page uses the `pathfinder` full node on the `starknet-mainnet` network. See the [Networks and nodes](./networks-and-nodes.md) page for details.

If you use a different node, command arguments will also need to be changed accordingly. Please refer to the node's own documentation for details.
{% endhint %}

{% hint style="success" %}
**Tip**: [Deploying with Docker](./local-deployment-with-docker.md) is recommended for easier setup and maintenance.
{% endhint %}

# Overview

This guide walks you through installing `firehose-starknet` and the instrumented `pathfinder` node from source, and demonstrates running the Firehose stack without using Docker.

# Prerequisites

You need these to get started:

- [Go](https://go.dev/) 1.21 or higher
- A reasonably recent version of [Rust](https://www.rust-lang.org/tools/install)

{% hint style="info" %}
**Note**: You need to have Rust installed even if you choose to use `juno`, a Starknet full node implemented in Go, as it uses Rust code under the hood.
{% endhint %}

# Installation

## Instrumented `pathfinder`

To install the instrumented `pathfinder` (v0.10.2) from source, simply run this `cargo` command:

```console
PATHFINDER_FORCE_VERSION="v0.10.2" cargo install --locked --git https://github.com/starknet-graph/pathfinder --tag v0.10.2 pathfinder
```

{% hint style="success" %}
**Tip**: You can uninstall later it with:

```console
cargo uninstall pathfinder
```

{% endhint %}

Verify that the `pathfinder` command is now available:

```console
pathfinder --version
```

{% hint style="success" %}
**Tip**: If the command is not found, make sure the directory `$HOME/.cargo/bin` is in your `PATH` environment variable.
{% endhint %}

## `firehose-starknet`

To install `firehose-starknet` (v0.2.1) from source, first clone the repository anywhere you like:

```console
git clone https://github.com/starknet-graph/firehose-starknet
```

Then change directory into the repository:

```console
cd firehose-starknet
```

Make sure you're checked out to the desired version (v0.2.1):

```console
git checkout v0.2.1
```

And run the installation command:

```console
go install ./cmd/firestark
```

The `firehose-starknet` application is available as the `firestark` command. Verify that it's been installed successfully:

```console
firestark --version
```

{% hint style="success" %}
**Tip**: If the command is not found, make sure the directory `$HOME/go/bin` (or `$GOPATH/bin`) is in your `PATH` environment variable.
{% endhint %}

# Running the Firehose stack

First of all, a new data directory should be created for persisting Firehose and node data. This can be any folder you want, here we create a `firestark-data` folder in the current working directory:

```console
mkdir ./firestark-data
```

Then, make 4 sub-directories inside it to store data from different components:

```console
mkdir ./firestark-data/node ./firestark-data/one-blocks ./firestark-data/merged-blocks ./firestark-data/forked-blocks
```

Now run the following `firestark` command, where `YOUR_ETHEREUM_URL` must be replaced with your own URL for Ethereum Mainnet RPC, to bring up the whole stack:

```console
firestark \
    --config-file "" \
    start firehose reader-node merger relayer \
    --reader-node-path pathfinder \
    --reader-node-arguments "--data-directory $(pwd)/firestark-data/node --ethereum.url YOUR_ETHEREUM_URL" \
    --common-one-block-store-url "file:///$(pwd)/firestark-data/one-blocks" \
    --common-merged-blocks-store-url "file:///$(pwd)/firestark-data/merged-blocks" \
    --common-forked-blocks-store-url "file:///$(pwd)/firestark-data/forked-blocks"
```

Once the process is up and running, the Firehose stack will start producing blocks. You can verify that it's working by running this `grpcurl` command:

```console
grpcurl -plaintext -d '{"start_block_num": 0}' localhost:10015 sf.firehose.v2.Stream.Blocks
```

{% hint style="success" %}
**Tip**: You need to have [`grpcurl`](https://github.com/fullstorydev/grpcurl) installed for this command to work.
{% endhint %}

The `grpcurl` command subscribes to the block stream, and you should be able to see new blocks being printed to the console as they become available.

# Deployment Guide

To set up a Firehose environment you need:

* A [Firecore](https://github.com/streamingfast/firehose-core) binary, which spins up the different components needed (reader, merger, relayer...).
* A supported blockchain node client (see [Chain-Specific Implementations](../firehose-setup/ethereum/README.md))
* A full instrumented node or an RPC to fetch the blockchain data.

## The Firecore

Firecore allows you to spin up all the different Firehose component needed, such as the reader or the relayer. The Firecore is a binary exported in the form of a CLI, so you can easily interact with it.

You can download the latest version of Firecore from the [release page of GitHub](https://github.com/streamingfast/firehose-core/releases).

# For all chains except Ethereum compatible ones

Use the `firecore` binary for all blockchain integrations except Ethereum-compatible chains.

{% hint style="info" %}
`firecore` commands/flags are a subset of `fireeth` (which contains Ethereum specific commands and flags). We will use `firecore` in the deployment guide for simplicity - `fireeth` should work exactly the same.
{% endhint %}

## Basic Deployment Example

Here's a basic example using command-line flags (recommended approach):

```bash
firecore start \
  --reader-node-path="/usr/local/bin/geth" \
  --reader-node-arguments="--datadir /data --syncmode full" \
  --grpc-listen-addr=":9000"
```

{% hint style="info" %}
Configuration files are also supported. Refer to the [CLI Reference](../references/cli-reference.md) for details on both flag and config file usage.
{% endhint %}

## Instrumented Node or RPC

Firehose is only an extraction engine, so you still have to provide a valid source of data. There are two modes in which Firehose can extract data:

**- Instrumented Node:** in this case, you run a full blockchain node (e.g. `geth` for Ethereum). Note that this requires the node to share the same instrumentation interface used by Firehose, so that it is possible to extract all the data required.&#x20;

**- RPC Poller:** in this case, you are DO NOT run the full node, but rely on the RPC API of the blockchain, which usually offers you a poorer data model.

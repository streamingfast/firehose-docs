---
description: StreamingFast Firehose for Ethereum
---

# Ethereum

## Supported Node Clients

Firehose for Ethereum supports **Geth and Geth forks only**. This includes:

* Ethereum Mainnet (Geth)
* Polygon (Geth fork)
* BSC (Geth fork)
* Other EVM-compatible chains using Geth-based clients

{% hint style="info" %}
For node operation requirements and configuration, refer to the official documentation of the specific Geth client you're using. Firehose acts as a data reader on top of the node client.
{% endhint %}

## Binary Information

Ethereum uses the `fireeth` binary (found at [firehose-ethereum](https://github.com/streamingfast/firehose-ethereum)) instead of the standard `firecore` binary. The `fireeth` binary includes all `firecore` functionality plus Ethereum-specific features.

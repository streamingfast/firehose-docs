---
description: Firehose configuration for Arbitrum One
---

# Arbitrum

This page provides Arbitrum One specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/nitro:<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/nitro/pkgs/container/nitro)

The image contains both the Firehose-patched Nitro binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| Nitro (Firehose-patched) | [streamingfast/nitro](https://github.com/streamingfast/nitro) |

## Networks

| Network | Chain Name |
|---------|------------|
| Arbitrum One | `arb-one` |
| Arbitrum Nova | `arb-nova` |
| Arbitrum Sepolia | `arb-sepolia` |

## L1 Dependency

{% hint style="warning" %}
Arbitrum requires access to an Ethereum L1 node (both execution and beacon client) for operation. The L1 connection is used for state validation and blob data retrieval.
{% endhint %}

## Reader Node Configuration

### Arbitrum One

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="arb-one" \
  --reader-node-path="nitro" \
  --reader-node-arguments="--parent-chain.connection.url=<l1-rpc-url> --parent-chain.blob-client.beacon-url=<l1-beacon-url> --chain.id=42161 --execution.vmtrace.tracer-name=firehose" \
  <other_flags...>
```

### Arbitrum Nova

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="arb-nova" \
  --reader-node-path="nitro" \
  --reader-node-arguments="--parent-chain.connection.url=<l1-rpc-url> --parent-chain.blob-client.beacon-url=<l1-beacon-url> --chain.id=42170 --execution.vmtrace.tracer-name=firehose" \
  <other_flags...>
```

## Key Nitro Flags

| Flag | Description |
|------|-------------|
| `--execution.vmtrace.tracer-name=firehose` | **Required.** Enables Firehose Protocol output |
| `--chain.id` | Chain ID (42161 for Arbitrum One, 42170 for Nova) |
| `--parent-chain.connection.url` | Ethereum L1 RPC endpoint |
| `--parent-chain.blob-client.beacon-url` | Ethereum L1 beacon client endpoint |

## Resources

- [Arbitrum Documentation](https://docs.arbitrum.io/)
- [streamingfast/nitro](https://github.com/streamingfast/nitro)
- [Arbitrum Node Running](https://docs.arbitrum.io/run-arbitrum-node/run-full-node)

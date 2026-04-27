---
description: Firehose configuration for Monad Mainnet
---

# Monad

This page provides Monad Mainnet specific configuration. First read the [Ethereum general notes](README.md) for common information.

{% hint style="info" %}
Monad runs its own node stack (`monad-bft` + `monad-execution`), distributed as a Debian package by Category Labs. The `monad-firehose-tracer` reads execution events emitted by `monad-execution` and outputs Firehose Protocol blocks.
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/evm-firehose-tracer-rs/monad:<version>
```

[View available versions on GitHub Packages](https://github.com/streamingfast/evm-firehose-tracer-rs/pkgs/container/evm-firehose-tracer-rs%2Fmonad)

The image contains both the `monad-firehose-tracer` binary and `fireeth`.

## Client Binary

| Client | Repository | Releases |
|--------|------------|----------|
| Monad Firehose Tracer | [streamingfast/evm-firehose-tracer-rs](https://github.com/streamingfast/evm-firehose-tracer-rs) | [GitHub Packages](https://github.com/streamingfast/evm-firehose-tracer-rs/pkgs/container/evm-firehose-tracer-rs%2Fmonad) |

## Networks

| Network | Chain Name |
|---------|------------|
| Monad Mainnet | `monad-mainnet` |

## Monad Node Dependency

{% hint style="warning" %}
Monad requires a running Monad BFT node alongside the tracer. Refer to the [Monad documentation](https://docs.monad.xyz/) for node setup.
{% endhint %}

## Reader Node Configuration

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="monad-mainnet" \
  --reader-node-path="/path/to/monad-firehose-tracer" \
  --reader-node-arguments="--chain-id=143 --monad-event-ring-path=/dev/hugepages/event-rings/monad-events --event-channel-buffer-size=524288" \
  <other_flags...>
```

## Key Tracer Flags

| Flag | Description |
|------|-------------|
| `--chain-id` | Monad chain ID (`143` for mainnet) |
| `--monad-event-ring-path` | Path to the execution event ring (e.g. `/dev/hugepages/event-rings/monad-events`) |
| `--event-channel-buffer-size` | Internal event channel buffer size (default: `524288`) |

## Resources

- [Monad Documentation](https://docs.monad.xyz/)
- [evm-firehose-tracer-rs](https://github.com/streamingfast/evm-firehose-tracer-rs)
- [firehose-ethereum GitHub](https://github.com/streamingfast/firehose-ethereum)

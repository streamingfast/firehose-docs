---
description: Firehose configuration for Worldchain
---

# Worldchain

This page provides Worldchain specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:optimism-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

Worldchain is built on the OP Stack, so it uses the same Firehose-patched OP Geth. The image contains both the binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| OP Geth (Firehose-patched) | [streamingfast/op-geth](https://github.com/streamingfast/op-geth) |

## Networks

| Network | Chain Name |
|---------|------------|
| Worldchain Mainnet | `worldchain-mainnet` |

## OP Node Dependency

{% hint style="warning" %}
Worldchain requires an OP Node (consensus client) running alongside OP Geth. The OP Node connects to Ethereum L1 for state derivation.
{% endhint %}

## Reader Node Configuration

### Worldchain Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="worldchain-mainnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --op-network=worldchain-mainnet --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose --state.scheme=path" \
  <other_flags...>
```

## Key OP Geth Flags

| Flag | Description |
|------|-------------|
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--op-network` | OP Stack network name (`worldchain-mainnet`) |
| `--authrpc.jwtsecret` | Path to JWT secret for OP Node connection |
| `--state.scheme=path` | Recommended state storage scheme |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [World Documentation](https://world.org/developers)
- [streamingfast/op-geth](https://github.com/streamingfast/op-geth)

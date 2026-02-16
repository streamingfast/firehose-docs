---
description: Firehose configuration for Katana
---

# Katana

This page provides Katana specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:optimism-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

Katana is built on the OP Stack, so it uses the same Firehose-patched OP Geth. The image contains both the binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| OP Geth (Firehose-patched) | [streamingfast/op-geth](https://github.com/streamingfast/op-geth) |

## Networks

| Network | Chain Name |
|---------|------------|
| Katana Mainnet | `katana-mainnet` |

## OP Node Dependency

{% hint style="warning" %}
Katana requires an OP Node (consensus client) running alongside OP Geth with a custom rollup configuration. The OP Node connects to Ethereum L1 for state derivation.
{% endhint %}

## Reader Node Configuration

### Katana Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="katana-mainnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=747474 --rollup.sequencerhttp=https://rpc.katana.network --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose --state.scheme=hash" \
  <other_flags...>
```

## Key OP Geth Flags

| Flag | Description |
|------|-------------|
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--networkid` | Network ID (747474 for Katana Mainnet) |
| `--rollup.sequencerhttp` | Sequencer endpoint for transaction submission |
| `--authrpc.jwtsecret` | Path to JWT secret for OP Node connection |
| `--state.scheme=hash` | State storage scheme (Katana uses `hash`) |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [Katana Network](https://katana.network/)
- [streamingfast/op-geth](https://github.com/streamingfast/op-geth)

---
description: Firehose configuration for Base
---

# Base

This page provides Base specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:optimism-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

Base is built on the OP Stack, so it uses the same Firehose-patched OP Geth. The image contains both the binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| OP Geth (Firehose-patched) | [streamingfast/op-geth](https://github.com/streamingfast/op-geth) |

## Networks

| Network | Chain Name |
|---------|------------|
| Base Mainnet | `base-mainnet` |
| Base Sepolia | `base-sepolia` |

## OP Node Dependency

{% hint style="warning" %}
Base requires an OP Node (consensus client) running alongside OP Geth. The OP Node connects to Ethereum L1 for state derivation. Refer to the [Base documentation](https://docs.base.org/guides/run-a-base-node/) for OP Node setup.
{% endhint %}

## Reader Node Configuration

### Base Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="base-mainnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=8453 --op-network=base-mainnet --rollup.sequencerhttp=https://mainnet-sequencer.base.org/ --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose --state.scheme=path" \
  <other_flags...>
```

### Base Sepolia

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="base-sepolia" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=84532 --op-network=base-sepolia --rollup.sequencerhttp=https://sepolia-sequencer.base.org/ --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose --state.scheme=path" \
  <other_flags...>
```

## Key OP Geth Flags

| Flag | Description |
|------|-------------|
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--op-network` | OP Stack network name (`base-mainnet` or `base-sepolia`) |
| `--networkid` | Network ID (8453 for Base Mainnet) |
| `--rollup.sequencerhttp` | Sequencer endpoint for transaction submission |
| `--authrpc.jwtsecret` | Path to JWT secret for OP Node connection |
| `--state.scheme=path` | Recommended state storage scheme |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [Base Documentation](https://docs.base.org/)
- [Run a Base Node](https://docs.base.org/guides/run-a-base-node/)
- [streamingfast/op-geth](https://github.com/streamingfast/op-geth)

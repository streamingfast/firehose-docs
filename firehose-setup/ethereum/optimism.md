---
description: Firehose configuration for Optimism (OP Mainnet)
---

# Optimism

This page provides Optimism (OP Mainnet) specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:optimism-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

The image contains both the Firehose-patched OP Geth binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| OP Geth (Firehose-patched) | [streamingfast/op-geth](https://github.com/streamingfast/op-geth) |

## Networks

| Network | Chain Name |
|---------|------------|
| OP Mainnet | `optimism-mainnet` |
| OP Sepolia | `optimism-sepolia` |

## OP Node Dependency

{% hint style="warning" %}
Optimism requires an OP Node (consensus client) running alongside OP Geth. The OP Node connects to Ethereum L1 for state derivation. Refer to the [Optimism documentation](https://docs.optimism.io/builders/node-operators/rollup-node) for OP Node setup.
{% endhint %}

## Reader Node Configuration

### OP Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="optimism-mainnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=10 --op-network=op-mainnet --rollup.sequencerhttp=https://mainnet-sequencer.optimism.io/ --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose --state.scheme=path" \
  <other_flags...>
```

### OP Sepolia

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="optimism-sepolia" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=11155420 --op-network=op-sepolia --rollup.sequencerhttp=https://sepolia-sequencer.optimism.io/ --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose --state.scheme=path" \
  <other_flags...>
```

## Key OP Geth Flags

| Flag | Description |
|------|-------------|
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--op-network` | OP Stack network name |
| `--networkid` | Network ID (10 for OP Mainnet) |
| `--rollup.sequencerhttp` | Sequencer endpoint for transaction submission |
| `--authrpc.jwtsecret` | Path to JWT secret for OP Node connection |
| `--state.scheme=path` | Recommended state storage scheme |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [Optimism Documentation](https://docs.optimism.io/)
- [streamingfast/op-geth](https://github.com/streamingfast/op-geth)
- [OP Node Setup](https://docs.optimism.io/builders/node-operators/rollup-node)

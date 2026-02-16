---
description: Firehose configuration for Unichain
---

# Unichain

This page provides Unichain specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:optimism-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

Unichain is built on the OP Stack, so it uses the same Firehose-patched OP Geth. The image contains both the binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| OP Geth (Firehose-patched) | [streamingfast/op-geth](https://github.com/streamingfast/op-geth) |

## Networks

| Network | Chain Name |
|---------|------------|
| Unichain Mainnet | `unichain-mainnet` |

## OP Node Dependency

{% hint style="warning" %}
Unichain requires an OP Node (consensus client) running alongside OP Geth. The OP Node connects to Ethereum L1 for state derivation. Refer to the [Unichain documentation](https://docs.unichain.org/) for OP Node setup.
{% endhint %}

## Reader Node Configuration

### Unichain Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="unichain-mainnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=130 --op-network=unichain-mainnet --rollup.sequencerhttp=https://mainnet-sequencer.unichain.org --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose --state.scheme=path" \
  <other_flags...>
```

## Key OP Geth Flags

| Flag | Description |
|------|-------------|
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--op-network` | OP Stack network name (`unichain-mainnet`) |
| `--networkid` | Network ID (130 for Unichain Mainnet) |
| `--rollup.sequencerhttp` | Sequencer endpoint for transaction submission |
| `--authrpc.jwtsecret` | Path to JWT secret for OP Node connection |
| `--state.scheme=path` | Recommended state storage scheme |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [Unichain Documentation](https://docs.unichain.org/)
- [streamingfast/op-geth](https://github.com/streamingfast/op-geth)

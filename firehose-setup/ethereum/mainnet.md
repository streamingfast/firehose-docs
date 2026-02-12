---
description: Firehose configuration for Ethereum Mainnet and testnets
---

# Ethereum Mainnet

This page provides Ethereum Mainnet specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:geth-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

The image contains both the Firehose-patched Geth binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| Geth (Firehose-patched) | [streamingfast/go-ethereum](https://github.com/streamingfast/go-ethereum) |

## Networks

| Network | Chain Name |
|---------|------------|
| Mainnet | `eth-mainnet` |
| Sepolia | `eth-sepolia` |
| Hoodi | `eth-hoodi` |

## Consensus Client Requirement

{% hint style="warning" %}
Ethereum requires a consensus (beacon) client to sync. You must run a consensus client (Lighthouse, Prysm, Teku, etc.) alongside Geth. Refer to the [Geth documentation](https://geth.ethereum.org/docs/getting-started/consensus-clients) for setup instructions.
{% endhint %}

## Reader Node Configuration

### Ethereum Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="eth-mainnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=1 --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose" \
  <other_flags...>
```

### Sepolia Testnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="eth-sepolia" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --sepolia --syncmode=full --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose" \
  <other_flags...>
```

### Hoodi Testnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="eth-hoodi" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --hoodi --syncmode=full --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* --authrpc.jwtsecret=/path/to/jwt.hex --vmtrace=firehose" \
  <other_flags...>
```

## Key Geth Flags

| Flag | Description |
|------|-------------|
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--networkid` | Network ID (1 for mainnet) |
| `--mainnet` / `--sepolia` / `--hoodi` | Network selection (alternative to networkid) |
| `--authrpc.jwtsecret` | Path to JWT secret for consensus client connection |
| `--authrpc.addr` | Auth RPC listen address for consensus client |
| `--authrpc.port` | Auth RPC port (default 8551) |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [Geth Documentation](https://geth.ethereum.org/docs)
- [Consensus Client Setup](https://geth.ethereum.org/docs/getting-started/consensus-clients)
- [streamingfast/go-ethereum](https://github.com/streamingfast/go-ethereum)

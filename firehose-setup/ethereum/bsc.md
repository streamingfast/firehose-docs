---
description: Firehose configuration for BNB Smart Chain
---

# BNB Smart Chain

This page provides BNB Smart Chain (BSC) specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:bnb-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

The image contains both the Firehose-patched BSC Geth binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| BSC Geth (Firehose-patched) | [streamingfast/bsc](https://github.com/streamingfast/bsc) |

## Networks

| Network | Chain Name |
|---------|------------|
| BSC Mainnet | `bsc-mainnet` |
| BSC Testnet | `bsc-testnet` |

## Reader Node Configuration

### BSC Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="bsc-mainnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=56 --syncmode=full --vmtrace=firehose" \
  <other_flags...>
```

### BSC Testnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="bsc-testnet" \
  --reader-node-path="geth" \
  --reader-node-arguments="--datadir={node-data-dir} --networkid=97 --syncmode=full --vmtrace=firehose" \
  <other_flags...>
```

## Key BSC Geth Flags

| Flag | Description |
|------|-------------|
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--networkid` | Network ID (56 for mainnet, 97 for testnet) |
| `--syncmode` | `full` recommended for BSC |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [BSC Documentation](https://docs.bnbchain.org/)
- [streamingfast/bsc](https://github.com/streamingfast/bsc)
- [BSC Node Best Practices](https://docs.bnbchain.org/bnb-smart-chain/developers/node_operators/node_best_practices/)

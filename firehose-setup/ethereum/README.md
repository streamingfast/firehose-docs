---
description: Firehose chain-specific configuration for Ethereum
---

# Ethereum

This page provides Ethereum-specific configuration for Firehose. For general deployment instructions, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="info" %}
This guide covers only the chain-specific Reader Node configuration. For general Firehose architecture and deployment patterns, refer to the main deployment guides.
{% endhint %}

{% hint style="warning" %}
This guide does not cover how to sync an Ethereum node. For node synchronization, storage requirements, and network configuration, refer to the official documentation of your chosen client (Geth, Erigon, etc.).
{% endhint %}

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-ethereum](https://github.com/streamingfast/firehose-ethereum) | `fireeth` |

The `fireeth` binary includes all `firecore` functionality plus Ethereum-specific features and commands. Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-ethereum/releases).

## Supported Clients

Firehose for Ethereum supports **Geth and Geth forks**:

| Client | Networks | Notes |
|--------|----------|-------|
| Geth (with Firehose patches) | Ethereum Mainnet, Sepolia, Holesky | Requires patched Geth binary |
| Polygon Bor | Polygon PoS | Geth fork with Firehose patches |
| BSC Geth | BNB Smart Chain | Geth fork with Firehose patches |
| Erigon (with Firehose patches) | Ethereum Mainnet | Alternative client, requires patches |

### Firehose-Enabled Binaries

You must use a Firehose-patched version of the client. Pre-built binaries are available:

| Client | Repository |
|--------|------------|
| Geth | [sf-ethereum/go-ethereum](https://github.com/streamingfast/go-ethereum) |
| Polygon Bor | [sf-polygon/polygon-bor](https://github.com/streamingfast/polygon-bor) |
| BSC Geth | [sf-bsc/bsc](https://github.com/streamingfast/bsc) |

## Reader Node Configuration

### Basic Configuration

```bash
fireeth start reader-node \
  --reader-node-path="geth" \
  --reader-node-arguments="--firehose-enabled --datadir={node-data-dir} --syncmode=snap --http" \
  --reader-node-data-dir="./data/geth"
```

### Key Flags

The Firehose-patched Geth requires the `--firehose-enabled` flag to emit Firehose Protocol logs.

| Geth Flag | Description |
|-----------|-------------|
| `--firehose-enabled` | **Required.** Enables Firehose Protocol output to stdout |
| `--syncmode` | Sync mode: `snap` (recommended), `full`, or `archive` |
| `--datadir` | Data directory for Geth (use `{node-data-dir}` template) |

### Example: Ethereum Mainnet

```bash
fireeth start reader-node merger relayer firehose \
  --reader-node-path="/usr/local/bin/geth" \
  --reader-node-arguments="--firehose-enabled --datadir={node-data-dir} --syncmode=snap --mainnet --http --http.api=eth,net,web3" \
  --reader-node-data-dir="./data/geth" \
  --common-first-streamable-block=0
```

### Example: Polygon PoS

```bash
fireeth start reader-node merger relayer firehose \
  --reader-node-path="/usr/local/bin/bor" \
  --reader-node-arguments="server --firehose-enabled --datadir={node-data-dir} --syncmode=full --chain=mainnet --bor.heimdall=https://heimdall-api.polygon.technology" \
  --reader-node-data-dir="./data/bor" \
  --common-first-streamable-block=0
```

### Example: BSC Mainnet

```bash
fireeth start reader-node merger relayer firehose \
  --reader-node-path="/usr/local/bin/geth" \
  --reader-node-arguments="--firehose-enabled --datadir={node-data-dir} --syncmode=snap --config=/config/bsc-config.toml" \
  --reader-node-data-dir="./data/bsc" \
  --common-first-streamable-block=0
```

## Advertise Configuration

For Ethereum networks, configure the advertise flags:

| Network | Chain Name | Block ID Encoding |
|---------|------------|-------------------|
| Ethereum Mainnet | `eth-mainnet` | `0x_hex` |
| Ethereum Sepolia | `eth-sepolia` | `0x_hex` |
| Polygon PoS | `polygon-mainnet` | `0x_hex` |
| BSC | `bsc-mainnet` | `0x_hex` |

```bash
--advertise-chain-name="eth-mainnet" \
--advertise-block-id-encoding="0x_hex"
```

## Resources

- [firehose-ethereum GitHub](https://github.com/streamingfast/firehose-ethereum)
- [Geth Documentation](https://geth.ethereum.org/docs)
- [Polygon Documentation](https://docs.polygon.technology/)
- [BSC Documentation](https://docs.bnbchain.org/)

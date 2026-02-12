---
description: Firehose chain-specific configuration for Tron
---

# Tron

This page covers Reader Node configuration specific to Tron. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
Firehose for Tron uses an RPC poller approach. You can either run your own Tron node or use an RPC provider like TronGrid. For node setup, refer to the [official Tron documentation](https://developers.tron.network/).
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/firehose-tron:<version>
```

[View available versions on GitHub Packages](https://github.com/streamingfast/firehose-tron/pkgs/container/firehose-tron)

The image contains the `firecore` and `firetron` binaries.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-tron](https://github.com/streamingfast/firehose-tron) | `firecore`, `firetron` |

Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-tron/releases).

## Networks

| Network | Chain Name |
|---------|------------|
| Tron Mainnet | `tron-mainnet` |
| Tron Mainnet (EVM) | `tron-evm-mainnet` |

## Architecture

Firehose for Tron uses an **RPC poller** approach. The poller fetches blocks from Tron gRPC and/or JSON-RPC endpoints and converts them to Firehose format.

Tron supports two block formats:
- **Native Tron blocks**: Full Tron protocol data via gRPC
- **EVM-compatible blocks**: Ethereum-style blocks via JSON-RPC for EVM compatibility

```
┌──────────────────┐     gRPC     ┌──────────────────┐     stdout    ┌──────────────┐
│  Tron Node       │◄──────────── │    firetron      │──────────────►│  Reader Node │
│  (gRPC/JSON-RPC) │              │     poller       │               │  (Firehose)  │
└──────────────────┘              └──────────────────┘               └──────────────┘
```

## Reader Node Configuration

### Tron Mainnet (Native)

```bash
firecore start reader-node <apps> \
  --advertise-chain-name="tron-mainnet" \
  --common-first-streamable-block=<start-block> \
  --reader-node-path="firetron" \
  --reader-node-arguments="fetch {first-streamable-block} --state-dir={node-data-dir}/poller/states --tron-endpoints=<tron-grpc-endpoint>" \
  <other_flags...>
```

### Tron Mainnet (EVM)

For EVM-compatible block format:

```bash
firecore start reader-node <apps> \
  --advertise-chain-name="tron-evm-mainnet" \
  --common-first-streamable-block=<start-block> \
  --reader-node-path="firetron" \
  --reader-node-arguments="fetch-evm {first-streamable-block} --state-dir={node-data-dir}/poller/states --tron-evm-endpoints=<tron-jsonrpc-endpoint> --tron-endpoints=<tron-grpc-endpoint>" \
  <other_flags...>
```

## Key Poller Flags

| Flag | Description |
|------|-------------|
| `fetch` | Subcommand to fetch native Tron blocks |
| `fetch-evm` | Subcommand to fetch EVM-compatible blocks |
| `{first-streamable-block}` | Variable substituted from `--common-first-streamable-block` |
| `--state-dir` | Directory to store poller state |
| `--tron-endpoints` | Tron gRPC endpoint (e.g., `grpc.trongrid.io:50051`) |
| `--tron-evm-endpoints` | Tron JSON-RPC endpoint for EVM blocks |
| `--tron-api-key` | API key for TronGrid access |
| `--block-fetch-batch-size` | Number of blocks to fetch in parallel |
| `--interval-between-fetch` | Delay between fetch cycles |

## Resources

- [Tron Documentation](https://developers.tron.network/)
- [TronGrid API](https://www.trongrid.io/)
- [firehose-tron GitHub](https://github.com/streamingfast/firehose-tron)

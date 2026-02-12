---
description: Firehose chain-specific configuration for Stellar
---

# Stellar

This page covers Reader Node configuration specific to Stellar. For general Firehose architecture and deployment, see the [Single Machine Deployment](../single-machine-deployment.md) or [Distributed Deployment](../distributed-deployment.md) guides.

{% hint style="warning" %}
Firehose for Stellar uses an RPC poller approach. You can either run your own Stellar/Soroban RPC node or use an RPC provider. For node setup, refer to the [official Stellar documentation](https://developers.stellar.org/).
{% endhint %}

## Docker Image

```
ghcr.io/streamingfast/firehose-stellar:<version>
```

[View available versions on GitHub Packages](https://github.com/streamingfast/firehose-stellar/pkgs/container/firehose-stellar)

The image contains the `firecore` and `firestellar` binaries.

## Binary & Releases

| Component | Repository | Binary |
|-----------|------------|--------|
| Firehose | [firehose-stellar](https://github.com/streamingfast/firehose-stellar) | `firecore`, `firestellar` |

Download releases from the [GitHub releases page](https://github.com/streamingfast/firehose-stellar/releases).

## Networks

| Network | Chain Name |
|---------|------------|
| Stellar Mainnet | `stellar-mainnet` |
| Stellar Testnet | `stellar-testnet` |

## Architecture

Firehose for Stellar uses an **RPC poller** approach. The poller fetches ledgers from Stellar Soroban RPC endpoints and converts them to Firehose format.

```
┌──────────────────┐     RPC      ┌──────────────────┐     stdout    ┌──────────────┐
│  Soroban RPC     │◄────────────│   firestellar    │──────────────►│  Reader Node │
│    Endpoint      │              │     poller       │               │  (Firehose)  │
└──────────────────┘              └──────────────────┘               └──────────────┘
```

## Reader Node Configuration

### Stellar Mainnet

```bash
firecore start reader-node <apps> \
  --advertise-chain-name="stellar-mainnet" \
  --common-first-streamable-block=<start-ledger> \
  --reader-node-path="firestellar" \
  --reader-node-arguments="fetch rpc {first-streamable-block} --state-dir={node-data-dir}/poller/states --endpoints=<soroban-rpc-endpoint>" \
  <other_flags...>
```

### Stellar Testnet

```bash
firecore start reader-node <apps> \
  --reader-node-path="firestellar" \
  --reader-node-arguments="fetch rpc {first-streamable-block} --state-dir={node-data-dir}/poller/states --endpoints=<soroban-rpc-endpoint> --is-mainnet=false" \
  --common-first-streamable-block=<start-ledger> \
  --advertise-chain-name="stellar-testnet" \
  <other_flags...>
```

## Key Poller Flags

| Flag | Description |
|------|-------------|
| `fetch rpc` | Subcommand to run the RPC poller |
| `{first-streamable-block}` | Variable substituted from `--common-first-streamable-block` |
| `--state-dir` | Directory to store poller state |
| `--endpoints` | Soroban RPC endpoint URL(s), can be specified multiple times |
| `--block-fetch-batch-size` | Number of ledgers to fetch in parallel |
| `--is-mainnet` | Set to `false` for testnet (default `true`) |

## Resources

- [Stellar Documentation](https://developers.stellar.org/)
- [Soroban RPC](https://developers.stellar.org/docs/data/rpc)
- [firehose-stellar GitHub](https://github.com/streamingfast/firehose-stellar)

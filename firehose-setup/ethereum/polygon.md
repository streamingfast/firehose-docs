---
description: Firehose configuration for Polygon PoS
---

# Polygon

This page provides Polygon PoS specific configuration. First read the [Ethereum general notes](README.md) for common information.

## Docker Image

```
ghcr.io/streamingfast/go-ethereum:polygon-<version>-fh3.0
```

[View available versions on GitHub Packages](https://github.com/streamingfast/go-ethereum/pkgs/container/go-ethereum)

The image contains both the Firehose-patched Bor binary and `fireeth`.

## Client Binary

| Client | Repository |
|--------|------------|
| Bor (Firehose-patched) | [streamingfast/polygon-bor](https://github.com/streamingfast/polygon-bor) |

## Networks

| Network | Chain Name |
|---------|------------|
| Polygon Mainnet | `polygon-mainnet` |
| Polygon Amoy | `polygon-amoy` |

## Heimdall Dependency

{% hint style="warning" %}
Polygon PoS requires a Heimdall node running alongside Bor. Heimdall provides checkpoint validation. You must run your own Heimdall node. Refer to the [Polygon documentation](https://docs.polygon.technology/pos/how-to/full-node/) for Heimdall setup instructions.
{% endhint %}

## Reader Node Configuration

### Polygon Mainnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="polygon-mainnet" \
  --reader-node-path="bor" \
  --reader-node-arguments="server --chain=mainnet --config=/path/to/config.toml --datadir={node-data-dir} --bor.heimdall=http://heimdall:1317 --syncmode=full --vmtrace=firehose" \
  <other_flags...>
```

### Polygon Amoy Testnet

```bash
fireeth start reader-node <apps> \
  --advertise-chain-name="polygon-amoy" \
  --reader-node-path="bor" \
  --reader-node-arguments="server --chain=amoy --config=/path/to/config.toml --datadir={node-data-dir} --bor.heimdall=http://heimdall:1317 --syncmode=full --vmtrace=firehose" \
  <other_flags...>
```

## Key Bor Flags

| Flag | Description |
|------|-------------|
| `server` | Bor subcommand to start the node |
| `--vmtrace=firehose` | **Required.** Enables Firehose Protocol output |
| `--syncmode` | `full` recommended for Polygon |
| `--chain` | `mainnet` or `amoy` |
| `--config` | Path to Bor configuration TOML file |
| `--bor.heimdall` | Heimdall REST API endpoint (e.g., `http://heimdall:1317`) |
| `--datadir` | Data directory (use `{node-data-dir}` template) |

## Resources

- [Polygon Documentation](https://docs.polygon.technology/)
- [Polygon Node Requirements](https://docs.polygon.technology/pos/how-to/full-node/)
- [streamingfast/polygon-bor](https://github.com/streamingfast/polygon-bor)

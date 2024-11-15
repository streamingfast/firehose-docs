# Overview

Usually, to set up a Firehose environment you need:

* A [Firecore](https://github.com/streamingfast/firehose-core) binary, which spins up the different components needed (reader, merger, relayer...).
* A Firehose chain-specific binary, which is used as a bridge between Firecore and the blockchain.
* A full instrumented node or an RPC to fetch the blockchain data.

## The Firecore

Firecore allows you to spin up all the different Firehose component needed, such as the reader or the relayer. The Firecore is a binary exported in the form of a CLI, so you can easily interact with it.

You can download the latest version of Firecore from the [release page of GitHub](https://github.com/streamingfast/firehose-core/releases).

## The Chain-Specific Binary

Every chain has a different data model (e.g. Ethereum vs Solana), therefore, Firehose needs to extract the data of every blockchain differently. In order for Firehose to support a new chain, a new extraction layer must be created. This extraction layer is then used by Firecore to interact with the different _base components_.

Essentially, Firecore acts as the coordinator and uses the chain-specific binary. Some examples of chain-specific binaries are [firehose-ethereum](https://github.com/streamingfast/firehose-ethereum) or [firehose-solana](https://github.com/streamingfast/firehose-solana).

## Instrumented Node or RPC

Firehose is only an extraction engine, so you still have to provide a valid source of data. There are two modes in which Firehose can extract data:

**- Instrumented Node:** in this case, you run a full blockchain node (e.g. `geth` for Ethereum). Note that this requires the node to share the same instrumentation interface used by Firehose, so that it is possible to extract all the data required.&#x20;

**- RPC Poller:** in this case, you are DO NOT run the full node, but rely on the RPC API of the blockchain, which usually offers you a poorer data model.

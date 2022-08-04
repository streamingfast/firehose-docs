---
description: StreamingFast Firehose documentation for existing blockchain integration
---

# Firehose & Existing Blockchains

Existing blockchains that can be integrated immediately with Firehose include Ethereum, NEAR, Solana, and Cosmos.

All of the hardware required for the target blockchain node is required. Each blockchain has specific requirements for running a node.&#x20;

The blockchain specific node requirements for each one can be found by visiting the following websites.

[Run a node - Ethereum.org ](https://ethereum.org/en/run-a-node/)

[Run a Node on Linux and MacOS - NEAR Nodes](https://near-nodes.io/validator/running-a-node)

[Running a Validator - Solana Docs](https://docs.solana.com/running-validator)

[Running a Node - Cosmos SDK Documentation](https://docs.cosmos.network/main/run-node/run-node.html)

Internet connection availability and speed are other factors that need to be accounted for to set up the node and Firehose system.

#### Integrate your chain

Modify `devel/standard/standard.yaml` and change the `start.flags.mindreader-node-path` flag to point to your blockchain node's binary. Learn more about those parameters in the \[Operator's manual]\(\{{#< ref "/operate/running-the-node" >#\}}).

Modify `devel/standard/start.sh` to

Run it with:&#x20;

\--- NOTE ---

Run it with what?&#x20;

\--- /NOTE ---

#### Define types

Go to the `proto` directory, and modify `sf/acme/type/v1/type.proto` to match your chain's types. More details in [specs for chain's protobuf model definitions](../protobuf-defs/)

#### Modify the Ingestor's `Read()`

Inside `codec`, is a file called `reader.go`. This file is the boundary between your process and the firehose's ingestion process.

Read the source of the `ConsoleReader` and make sure you understand how it works. This will be the bulk of your integration work.

Do X, Y, Z

#### Make sure data is produced

As you iterate, check that files are produced under `xyz` directory.

#### Rename everything

Pick two names, the long form and short form for your chain, following the [naming conventions](../names/).

For example:

* `arweave` and `arw`

Then finalize the rename:

* Rename `cmd/fireacme` -> `cmd/firearw` (short form)
* Search and replace `fireacme` => `firearw` (short form)
* Do massive search and replace from: `acme` => `arweave` (long form)

Meanwhile, please follow the [this document from github.com/streamingfast/firehose-acme](https://github.com/streamingfast/firehose-acme/blob/master/INTEGRATION.md)

Additional links:

* https://github.com/streamingfast/firehose-acme
* https://github.com/streamingfast/dummy-blockchain

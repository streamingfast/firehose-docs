---
description: StreamingFast Firehose node instrumentation documentation
---

# Node Instrumentation

Instrumenting a node is a crucial part of creating a successful custom Firehose system.

#### Integrate your chain

Modify `devel/standard/standard.yaml` and change the `start.flags.mindreader-node-path` flag to point to your blockchain node's binary. Learn more about those parameters in the \[Operator's manual]\(\{{#< ref "/operate/running-the-node" >#\}}).

Modify `devel/standard/start.sh` to

Run it with:

#### Define types

Go to the `proto` directory, and modify `sf/acme/type/v1/type.proto` to match your chain's types. More details in [specs for chain's protobuf model definitions](protobuf-defs/)

#### Modify the Ingestor's `Read()`

Inside `codec`, is a file called `reader.go`. This file is the boundary between your process and the firehose's ingestion process.

Read the source of the `ConsoleReader` and make sure you understand how it works. This will be the bulk of your integration work.

Do X, Y, Z

#### Make sure data is produced

As you iterate, check that files are produced under `xyz` directory.

#### Rename everything

Pick two names, the long form and short form for your chain, following the [naming conventions](names/).

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

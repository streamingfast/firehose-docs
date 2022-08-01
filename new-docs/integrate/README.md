---
description: StreamingFast Firehose integration documentation
---

# Integration

\--- CONTINUE HERE ---

This document walks you through a brand new Firehose integration.

**Prerequisites**

* Solid understanding of the Firehose Concepts & Architecture
* Review the Principles & Approach documentation to align your integration with the goals of Firehose.

#### Clone the ACME repo

The ACME repo is the sample repository that you'll base yourself on for your new integration.

```
git clone git@github.com:streamingfast/firehose-acme
```

Next steps will happen within that repository.

### Run it

To start your work, make sure you can run the `fireacme` binary, and have it obtain data from your instrumented blockchain node.

```
go install -v ./cmd/fireacme
```

This will install the `fireacme` binary in your `GOPATH`, which is normally `~/go/bin`. **Make sure this path is in your `PATH` before continuing.**

### Test with the dummy chain

Modify `devel/standard/standard.yaml` to point to the dummy chain implementation. Install it from https://github.com/streamingfast/dummy-blockchain

### Integrate your chain

Modify `devel/standard/standard.yaml` and change the `start.flags.mindreader-node-path` flag to point to your blockchain node's binary. Learn more about those parameters in the \[Operator's manual]\(\{{#< ref "/operate/running-the-node" >#\}}).

Modify `devel/standard/start.sh` to

Run it with:

### Define types

Go to the `proto` directory, and modify `sf/acme/type/v1/type.proto` to match your chain's types. More details in [specs for chain's protobuf model definitions](protobuf-defs/)

### Modify the Ingestor's `Read()`

Inside `codec`, is a file called `reader.go`. This file is the boundary between your process and the firehose's ingestion process.

Read the source of the `ConsoleReader` and make sure you understand how it works. This will be the bulk of your integration work.

Do X, Y, Z

### Make sure data is produced

As you iterate, check that files are produced under `xyz` directory.

### Rename everything

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

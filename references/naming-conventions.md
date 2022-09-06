---
description: StreamingFast Firehose naming conventions
---

# Naming Conventions

Firehose currently has multiple versions with separate naming conventions. This page serves as an effort to provide a unified experience between Firehose versions.

A new Firehose implementation makes use of two forms of a blockchain protocol's name: a _long_ and a _short_ form.&#x20;

The short form should be the shortest contraction of the chain name possible.  For example:&#x20;

`ethereum` and `eth`.&#x20;

_Note, these forms will be referenced throughout the naming conventions documentation._

### Firehose-enabled Blockchain Nodes

These are conventions that apply to the blockchain node codebases themselves, when they are integrating the Firehose.&#x20;

Think of `geth` for Go Ethereum, `solana-validator` for Solana,  `gaia` for Cosmos, etc.

* Whenever possible, the top-level flag  `--firehose-enabled` should be used to enable the firehose mode of spewing out data to standard output.
* Preferably, each line of output should start with the word `FIRE` followed by a simple word defining what data to expect on each line (for line-based Firehose instrumentation). NOTE: previous implementations used `DMLOG`, for deepmind, which was the codename of StreamingFast instrumentation.
* If using a library proves useful when doing node instrumentation, using `firehose` as the name of the library for all firehose helpers is preferable. NOTE: `deepmind` was used in several prior implementations.

### Within the chain-specific Firehose binary

This section defines what is expected of a conventional Firehose implementation. We use the word `acme` here, that should be replaced by the chain you are instrumenting.

* Repository name: `firehose-acme` (_long form_, ex: `firehose-ethereum`)
* Binary name: `fireacme`, using the _short form_ name (like `eth` for Ethereum, giving `fireeth`), living under `/cmd/fireacme`.
* Protocol Buffers schema:
  * The protobuf definition convention for a top-level Block for a new chain is: `sf.[chain].type.v1.Block`
* Directory layouts:
  * `/proto`: any protobuf definitions for the chain, properly namespaced. Ex:  `proto/sf/acme/type/v1/type.proto` as the first (and often only) file
  * `/types`: containing rendered protobuf types (and some helpers). Ex: `/types/pb/sf/acme/type/v1;pbacme`, using the _short form_ package name prefixed with `pb`.
  * `/types/go.mod`: to be able to import `github.com/streamingfast/firehose-acme/types` and pull only a limited number of dependencies.
  * `/codec`: containing all coding and decoding methods to manipulate the stream of data coming from the Firehose-enabled Blockchain Node. This library is concerned only with the data wrangling, and not the management of nodes.

### Changes to prior conventions

The `reader` component has historically been known as the `mindreader`, with its twist on the `deepmind` instrumentation the StreamingFast stack originally had.

Going forward:Historically, the `mindreader` was the component

* This component is to be known as the Reader in the documentation.
* The name of the _app_ within the `fireacme` binary is `reader` (instead of `mindreader` or `extractor` or `ingestor` as it has been in some places).
* Flags for that components would follow the convention of the different types of nodes handled by the `fireacme` binary: `--reader-node-config-1-2-3`, alongside ex: `--peering-node-config123` and `--miner-node-config123`
* You can expect your pods to be named `reader` instead of `mindreader` here and there.

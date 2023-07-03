---
description: StreamingFast Firehose template sample for A Company that Makes Everything
---

# Firehose Acme

Instrumenting a new chain from scratch requires the node native code to be instrumented to output Firehose logs, but this is only one side of the coin. A Firehose instrumentation of a new chain requires also a `firehose-<chain>` program that contains chain-specific code to read the data output by the instrumented node, and serves data throughout the Firehose stack.

This `firehose-<chain>` is a Golang project that contains the CLI, the [reader code necessary to assemble Firehose node output into chain-specific Blocks](https://github.com/streamingfast/firehose-acme/blob/master/codec/console\_reader.go), and a bunch of other small boilerplate code around the Firehose set of libraries.

To ease the work of Firehose implementors, we provide a "template" project [firehose-acme](https://github.com/streamingfast/firehose-acme) that is the main starting point for instrumenting new, unsupported blockchain nodes.

It consists of basic code and a Dummy Blockchain prototype. The idea is that you can play with this [firehose-acme](https://github.com/streamingfast/firehose-acme) instance to see blocks produced and test some Firehose behaviors.

## Install `firehose-acme`

Clone the repository:

```bash
git clone git@github.com:streamingfast/firehose-acme
```

Install the `fireacme` binary:

```bash
cd firehose-acme
go install ./cmd/fireacme
```

{% hint style="info" %}
A [Go](https://go.dev/doc/install) installation is required for the command below to work and the path where Golang install binaries should be available in your `PATH` (can be added with `export PATH=$PATH:$(go env GOPATH)/bin`, see [GOPATH](https://go.dev/doc/gopath\_code#GOPATH) for further details).
{% endhint %}

And validate that everything is working as expected:

```bash
fireacme --version
fireacme version dev (Built 2023-02-02T13:42:20-05:00)
```

{% hint style="info" %}
If `fireacme` is not found, please check [https://go.dev/doc/gopath\_code#GOPATH](https://go.dev/doc/gopath\_code#GOPATH)
{% endhint %}

## Install the dummy blockchain

Obtain the Dummy Blockchain by installing from source:

```bash
go install github.com/streamingfast/dummy-blockchain@latest
```

And validate that it was installed correctly:

```bash
dummy-blockchain --version
dummy-blockchain version 0.0.1 (build-commit="-" build-time="-")
```

## Run it

A simple shell script that starts `firehose-acme` with sane default is located at [devel/standard/start.sh](https://github.com/streamingfast/firehose-acme/blob/master/devel/standard/start.sh). The configuration file used to launch all the applications at once is located at [devel/standard/standard.yaml](https://github.com/streamingfast/firehose-acme/blob/master/devel/standard/standard.yaml)

Run the script from your local cloned `firehose-acme` version as done in [firehose-acme installation section](firehose-starter.md#firehose-acme-installation):

```bash
./devel/standard/start.sh
```

The following messages will be printed to the terminal window if:

* All of the configuration changes were made correctly,
* All system paths have been set correctly,
* And the Dummy Blockchain was installed and set up correctly.

```bash
2023-02-02T13:54:25.882-0500 INFO (dtracing) registering development exporters from environment variables
2023-02-02T13:54:25.882-0500 INFO (fireacme) starting Firehose on Acme with config file 'standard.yaml'
2023-02-02T13:54:25.882-0500 INFO (fireacme) launching applications: firehose,merger,reader-node,relayer
start --store-dir=/Users/maoueh/work/sf/firehose-acme/devel/standard/firehose-data/reader/data --firehose-enabled --block-rate=60
...
2023-02-02T13:54:25.883-0500 INFO (reader) created acme superviser {"superviser": {"binary": "dummy-blockchain", "arguments": ["start", "--store-dir=/Users/maoueh/work/sf/firehose-acme/devel/standard/firehose-data/reader/data", "--firehose-enabled", "--block-rate=60"], "data_dir": "/Users/maoueh/work/sf/firehose-acme/devel/standard/firehose-data/reader/data", "last_block_seen": 0, "server_id": ""}}
...
2023-02-02T13:54:25.884-0500 INFO (reader) creating new command instance and launch read loop {"binary": "dummy-blockchain", "arguments": ["start", "--store-dir=/Users/maoueh/work/sf/firehose-acme/devel/standard/firehose-data/reader/data", "--firehose-enabled", "--block-rate=60"]}
...
2023-02-02T13:54:28.677-0500 INFO (bstream) hub is now Ready
2023-02-02T13:54:28.677-0500 INFO (firehose) launching gRPC firehose server {"live_support": true}
2023-02-02T13:54:28.677-0500 INFO (firehose) launching gRPC server {"listen_addr": ":18015"}
2023-02-02T13:54:28.677-0500 INFO (firehose) serving gRPC (over HTTP router) (plain-text) {"listen_addr": ":18015"}
2023-02-02T13:54:28.899-0500 INFO (reader.acme) level=info msg="processing block" hash=4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce height=3
2023-02-02T13:54:29.897-0500 INFO (reader.acme) level=info msg="processing block" hash=4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a height=4
2023-02-02T13:54:30.897-0500 INFO (reader.acme) level=info msg="processing block" hash=ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d height=5
...
```

To integrate the target blockchain modify `devel/standard/standard.yaml` and change the `start.flags.mindreader-node-path` flag to point to the custom integration's blockchain node binary.

## Define protobuf types

Update the proto file `sf/acme/type/v1/type.proto` to model your chain's data model.

### Generate structs

After updating the references to "Acme" the Protocol Buffers need to be regenerated. Use the `generate` shell script to make the updates.

```
./types/pb/generate.sh
```

## Implement the reader

The [`console_reader.go`](https://github.com/streamingfast/firehose-acme/blob/master/codec/console\_reader.go#L121) file is the interface between the instrumented node's output and the Firehose ingestion process.

Each blockchain has specific pieces of data, and implementation details that are paticular to that blockchain. Reach out to us if you need guidance here.

{% hint style="warning" %}
**Important**_: Studying the StreamingFast Ethereum and other implementations and instrumentations should serve as a foundation for other custom integrations._
{% endhint %}

## Run tests

After completing all of the previous steps the base integration is ready for initial testing.

```
go test ./...
```

If all changes were made correctly the updated project should compile successfully.

## Wrap up the integration

You can reach out to the StreamingFast team on Discord. We usually maintain these Go-side integrations and keep them up-to-date. We can review, and do the renames as needed.

### Rename

You can also rename the project and all files and references to `acme` to your own chain's name. Choose two names, a long-form and a short form for the custom integration following the naming conventions outlined below.

For example:

* `arweave` and `arw`

Then finalize the rename:

* Rename `cmd/fireacme` -> `cmd/firearw` (short form)
* Search and replace `fireacme` => `firearw` (short form)
* Conduct a global search and replace from: `acme` => `arweave` (long form)
* Conduct a global search to replace `ACME` => `ARWEAVE` (long form)
* Conduct a global search to replace `Acme` => `Arweave` (long form)


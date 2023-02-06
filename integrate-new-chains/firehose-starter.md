---
description: StreamingFast Firehose template
---

# Firehose Acme

Instrumenting a new chain from scratch requires the node native code to be instrumented to output Firehose logs, but this is only one side of the coin. A Firehose instrumentation of a new chain requires also a `firehose-<chain>` repository that contains the chain specific code to run the Firehose stack.

This `firehose-<chain>` is a Golang project that contains the CLI, the reader code necessary to assemble Firehose Logs into chain specific logs and a bunch of other small boilerplate code around the Firehose set of libraries.

To ease the work of Firehose implementors, we provide a "template" project [firehose-acme](https://github.com/streamingfast/firehose-acme) that is the main starting point for instrumenting new, unsupported blockchain nodes.

It consists of basic code and a faux data provision application called the Dummy Blockchain, or `dchain`. The idea is that you can even play with this [firehose-acme](https://github.com/streamingfast/firehose-acme) instance to see blocks produced and test how Firehose looks like in its core.

{% hint style="info" %}
A [Go](https://go.dev/doc/install) installation is required for the command below to work and the path where Golang install binaries should be available in your `PATH` (can be added with `export PATH=$PATH:$(go env GOPATH)/bin`, see [GOPATH](https://go.dev/doc/gopath_code#GOPATH) for further details).
{% endhint %}

## `firehose-acme` Installation

Clone the repository:

```bash
git clone git@github.com:streamingfast/firehose-acme
```

Install the `fireacme` binary:

```bash
cd firehose-acme
go install ./cmd/fireacme
```

And validate that everything is working as expected:

```bash
fireacme --version
fireacme version dev (Built 2023-02-02T13:42:20-05:00)
```

{% hint style="info" %}
When doing the `fireacme --version` command, if you see instead a message like `command not found: fireacme`, it's most probably because `$(go env GOPATH)/bin` is not in your `PATH` environment variable.
{% endhint %}

## Dummy Blockchain

Obtain the Dummy Blockchain by installing from source:

```bash
go install github.com/streamingfast/dummy-blockchain@latest
```

And validate that it was installed correctly:

```bash
dummy-blockchain --version
dummy-blockchain version 0.0.1 (build-commit="-" build-time="-")
```

## Testing `firehose-acme`

### YAML Configuration

A simple shell script that starts `firehose-acme` with sane default is located at [devel/standard/start.sh](https://github.com/streamingfast/firehose-acme/blob/master/devel/standard/start.sh). The configuration file used to launch all the applications at once is located at [devel/standard/standard.yaml](https://github.com/streamingfast/firehose-acme/blob/master/devel/standard/standard.yaml)

Run the script from your local cloned `firehose-acme` version as done in [firehose-acme installation section](#firehose-acme-installation):

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

{% hint style="info" %}
We want to emphasis that `firehose-acme` is only a template project showcasing how Firehose works and used by implementors to bootstrap instrumentation of their chain.
Real-world Firehose implementations don't use or rely on the Dummy Blockchain application or its data, they deal with the blockchain's specific native process and specific `firehose-<chain>` repository.
{% endhint %}

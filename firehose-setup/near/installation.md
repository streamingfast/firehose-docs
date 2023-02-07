---
description: StreamingFast Firehose NEAR Setup
---

# Firehose NEAR Setup

In this document, we are going to showcase how you can launch a Firehose on NEAR instance on a single machine that will serve everything. Firehose installation is accomplished through a few fairly simple tasks including obtaining specific binaries and some configuration steps.

{% hint style="info" %}
Running on a single machine is quick and easy and can work fairly good if you are to use it for your own needs. For production grade set up, especially those shared across many users, we highly recommend splitting each component of Firehose in their own container with a shared storage for files access properly set up between them. This enables horizontal scaling with fine control over which component should be scaled out.
{% endhint %}

To bootstrap our instance, we are going to start Firehose on NEAR from a snapshot provided by the NEAR foundation. This will make our Firehose installation serves fairly recent blocks from the NEAR network. A caveat of using a snapshot like this is that historical blocks, e.g. blocks that were produced before the snapshot was taken, will not be available. To get access to historical blocks, look at [Backfill historical blocks section](#backfill).

It's important to understand here that we are going to run a NEAR full node (a.k.a NEAR RPC node). Operation blockchain's full node is a complex task and requires access to powerful disk(s) and powerful machine. The `firehose-near` binary is going to launch `near-firehose-indexer` which is a thin wrapper around `neard` that outputs Firehose Instrumentation Logs for NEAR. The `near-firehose-indexer` process acts just like `neard` would, synchronizing with the network. How to properly and efficiently operate a NEAR full node is not the responsibility of Firehose. When you have problem syncing or slow ingestion rate, you should first look at the [Full Node](https://near-nodes.io/rpc) official documentation and seek help with `neard` in mind.

{% hint style="warning" %}
Knowledge of `neard` and how to run a NEAR full node is required here. We even suggest that you try to operate a NEAR full node outside of Firehose before hand. Starting a Firehose on NEAR instance is quite easy when you ran NEAR full node before, the `neard` data folder can even be used to bootstrap the `firehose-near` instance instead of fetching a NEAR snapshot.
{% endhint %}

## Requirements

This tutorial have been tested on a Ubuntu 22.04 machine, and you will need to compile [`near-firehose-indexer`](https://github.com/streamingfast/near-firehose-indexer) manually.

Hardware requirements should follow NEAR full node requirements found at https://near-nodes.io/rpc/hardware-rpc. Firehose requires also extra disk space for Firehose NEAR blocks produced, indexes file for filtered blocks stream and for Substreams, if enabled. The actual space usage is hard to give exactly, specially for Substreams which is highly dependent on usage. Firehose NEAR Mainnet blocks weight ~600 GiB, this is in addition to space taken by NEAR node itself, so a minimum of 2 TiB is recommended.

## Installation

### `firenear`

First install the `firenear` binary:

```bash
# Use correct binary for your platform, `linux_x86_64` in the command below can be replaced by `darwin_x86_64` or `darwin_arm64`
TAG=$(curl -s https://api.github.com/repos/streamingfast/firehose-near/releases/latest | grep "tag_name" | cut -f 4 -d '"')
LINK=$(curl -s https://api.github.com/repos/streamingfast/firehose-near/releases/latest | grep -Eo "https://.*linux_x86_64.tar.gz")
curl -L $LINK  | tar zxf -

# Copy result to be available system-wide
cp firenear "/usr/local/bin/firenear-$TAG"
ln -fs /usr/local/bin/firenear-$TAG /usr/local/bin/firenear
```

The command above will download the [latest `firehose-near`](https://github.com/streamingfast/firehose-near/releases) tarball, extracts it in the current folder and copy over `/usr/local/bin` as well as creating a symlink for versioning.

And validate that everything is working as expected:

```bash
firenear --version
```

It should print:

```text
firenear version 1.0.1 (Commit 1fb7e0e, Built 2023-02-06T20:42:17Z)
```

### Firehose Instrumented Node Binary

Second step is to have the Firehose instrumented node binary. In the case of NEAR, we are going to get our hand on [`near-firehose-indexer`](https://github.com/streamingfast/near-firehose-indexer). This binary is actually a NEAR Indexer binary and essentially, it's `neard` configured to index the block and transactions as they are synced by the node and emit Firehose logs out of it.

To avoid any compatibility issues, we are going to compile the binary directly on the machine that will execute the binary.

It's an important that you pick the current active version to sync with the network, the [NEAR latest stable releases](https://github.com/near/nearcore/tags) page lists the most recent version that is needed to sync with Mainnet. As new versions of `neard` are published, new versions of [`near-firehose-indexer`](https://github.com/streamingfast/near-firehose-indexer) will be made available by us, so be sure to subscribe to [`near-firehose-indexer` releases](https://github.com/streamingfast/near-firehose-indexer/releases) to be informed when a new release is out.

{% hint style="warning" %}
It's important that you subscribe to NEAR update announcements to ensure you correctly continue to synchronize with the network. Some versions upgrade are hard forks which mean that if you don't upgrade in time, you will be unable to follow the canonical chain when the hard fork is activated on the network. It's your responsibility to monitor new NEAR releases and hard forks.
{% endhint %}

Install required build dependencies:

```bash
apt update
apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ protobuf-compiler libssl-dev pkg-config clang llvm
```

Install and configure [rustup](https://rustup.rs):

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Follow the instructions and don't forget to run `source "$HOME/.cargo/env"` at the end to make the binaries available.

Now let's clone [`near-firehose-indexer`](https://github.com/streamingfast/near-firehose-indexer/releases) and checkout the correct version. In this tutorial we are going to use `1.30.1-fire` because it's the latest version at time of writing, be sure to use the correct version (latest tag can be found with `curl -s https://api.github.com/repos/streamingfast/near-firehose-indexer/releases/latest | grep tag_name`):

```bash
# The compilation step uses lot of disk space, so ensure you have at least 20 GiB on the disk where you clone the project
git clone https://github.com/streamingfast/near-firehose-indexer.git

cd near-firehose-indexer
git checkout 1.30.1-fire
```

Then let's compile it:

```bash
CARGO_PROFILE_RELEASE_CODEGEN_UNITS='1' CARGO_PROFILE_RELEASE_LTO='fat' CARGO_BUILD_RUSTFLAGS='-D warnings' NEAR_RELEASE_BUILD='release' cargo build --release
```

This will take several minutes to complete depending on your machine size. And to terminate, let's copy the binary somewhere it's going to be available:

```bash
cp target/release/near-firehose-indexer /usr/local/bin/near-firehose-indexer-1.30.1-fire
ln -fs /usr/local/bin/near-firehose-indexer-1.30.1-fire /usr/local/bin/near-firehose-indexer
```

Finally, let's verify that it worked correctly:

```bash
near-firehose-indexer --version
```

It should print:

```bash
near-firehose-indexer 1.30.1
```

{% hint style="note" %}
If you see `1.27.0` printed while you downloaded `1.30.1`, it's just a mistake of this release where the version was not updated properly.
{% endhint %}

## Snapshot

We are now going to download a NEAR Mainnet snapshot to our local disk. Instructions for download NEAR snapshot for Mainnet or Testnet are given at https://near-nodes.io/intro/node-data-snapshots. We are going to use [s5cmd](https://github.com/peak/s5cmd) because it improves download speed a lot. We are going to quickly give the instructions but please refer to https://near-nodes.io/intro/node-data-snapshots for further details.

```bash
curl -L https://github.com/peak/s5cmd/releases/download/v2.0.0/s5cmd_2.0.0_Linux-64bit.tar.gz | tar zxf -
cp s5cmd /usr/local/bin
```

The NEAR snapshot should be put under a folder named `data` within the NEAR home directory. In our instructions, our NEAR home directory will be at `/data/node` so we are going to transfer all NEAR snapshot data under `/data/node/data`. Feel free to adjust those paths to your own setup.

```bash
chain="mainnet"  # or "testnet"
kind="rpc"       # or "archive"
latest=$(s5cmd --no-sign-request cat "s3://near-protocol-public/backups/${chain:?}/${kind:?}/latest")

mkdir -p /data/node/data
s5cmd --no-sign-request sync --delete "s3://near-protocol-public/backups/${chain:?}/${kind:?}/${latest:?}/*" /data/node/data
# Takes a few minutes to a few hours depending on your connection speed, 453.2 GB to download at time of writing
```

## Running

Now that we have our NEAR full node snapshot at `/data/node/data`, we need to setup the required configuration files that are needed to run the node. Essentially, we are following https://near-nodes.io/rpc/run-rpc-node-without-nearup#mainnet instructions, please refer to there for further details about some element.

The files that are needed:
- `config.json`
- `genesis.json`
- `node_key.json`

Those files should be put in the NEAR home directory, which is at `/data/node` in our case. Those files are provided by NEAR directly:

```bash
chain="mainnet"
curl https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/${chain:?}/config.json --output /data/node/config.json
curl https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/${chain:?}/genesis.json --output /data/node/genesis.json
```

The `config.json` already comes with pre-defined boot nodes as well as the tracked shards that we are interested in. Remember that those files are coming from NEAR directly, so please refer to their documentation for further details about the meaning of those config values.

We will now generate a unique `node_key.json` for this node. For this, we are going to use `firenear tools generate-node-key`. In the https://near-nodes.io/rpc/run-rpc-node-without-nearup#mainnet instructions, the `node_key.json` file is generated by doing `neard init` which essentially simply generates an ED25519 Public/Secret key pair and serialize it to a JSON file. We provide `firenear tools generate-node-key` as a convenience to avoid downloading yet another binary.

```bash
firenear tools generate-node-key /data/node/node_key.json
```

Now, we are going to sanity check that everything is all good by running `near-firehose-indexer`. This sanity check will also enable us to see at what block the snapshot is currently syncing, which is required later when we will start `firenear` binary.

```bash
near-firehose-indexer --home /data/node run
```

If everything works properly, you should see something like:

```
Feb 03 01:19:32.357  INFO main: Running
Feb 03 01:19:32.357  INFO indexer: Load config from /data/node...
Feb 03 01:19:32.357  WARN neard: /data/node/config.json: network.external_address is deprecated; please remove it from the config file
Feb 03 01:19:38.064  INFO near: Opening RocksDB database path=/data/node/data
Feb 03 01:19:43.100  INFO network: Starting http server at 0.0.0.0:3030
Feb 03 01:19:43.103  INFO indexer: Starting Streamer...
Feb 03 01:19:43.104  INFO stats: #84349610 Waiting for peers 0 peers ⬇ 0 B/s ⬆ 0 B/s 0.00 bps 0 gas/s CPU: 0%, Mem: 62.3 MB
Feb 03 01:19:43.229  INFO network: Error connecting to addr=194.36.145.175:24567 err=Os { code: 111, kind: ConnectionRefused, message: "Connection refused" }
Feb 03 01:19:43.397  INFO network: Error connecting to addr=114.37.187.160:24567 err=Os { code: 111, kind: ConnectionRefused, message: "Connection refused" }
Feb 03 01:19:43.534  INFO network: Error connecting to addr=95.216.96.29:24567 err=Os { code: 111, kind: ConnectionRefused, message: "Connection refused" }
Feb 03 01:19:43.562  INFO network: Error connecting to addr=168.119.88.135:24567 err=Os { code: 111, kind: ConnectionRefused, message: "Connection refused" }
Feb 03 01:19:43.643  INFO firehose: Block #84349608 (e2c28ce2cb7064fcff229f6374c91943ab1bd8e69d6da20c10bdebfb07f7d379) Shards: 4, Transactions: 5, Receipts: 15, ExecutionOutcomes: 14
...
```

As soon as you see some output, you can do `Ctrl-C` as we are going to restart everything now but through the `firenear` directly, which will launch `near-firehose-indexer` as a sub-process and manages it.

Prior continuing however, find the first line of the form `INFO stats: #84349610 Waiting for peers` and note the block number that you see, in our case it's `84349610`. We will use this value soon to compute for `firehose-near` the first streamable block of our setup.

We will now create a config file for `firehose-near` and explain within the file itself some of the configuration value. Let's create a file `/data/firehose.yaml` with the following content:

```yaml
start:
  args:
  - reader-node
  - receipt-index-builder
  - relayer
  - firehose
  - merger
  flags:
    ## Common configuration values

    # The first block available for Firehose consumption, used in various places. Normally for NEAR
    # Mainnet value would be `9820214`. Now that we are starting from a snapshot, remember the block
    # we asked to find from the log `INFO stats: #84349610`, we will use it, add 1000 and round it
    # up to nearest hundred boundary, so `roundedUpHundred(84349610 + 1000) = 84350700
    common-first-streamable-block: 84350700

    # Storage for various blocks and index
    common-one-block-store-url: /data/storage/one-blocks
    common-forked-blocks-store-url: /data/storage/forked-blocks
    common-merged-blocks-store-url: /data/storage/merged-blocks
    common-index-store-url: /data/storage/block-indexes
    common-block-index-sizes: 10000,1000,100

    # Address where to reach the relayer to receive live blocks from it, must be aligned with `relayer-grpc-listen-addr`
    common-live-blocks-addr: localhost:15011

    ## Firehose configuration values

    # Address where Firehose gRPC service will be available over plain-text connection
    firehose-grpc-listen-addr: :9000

    ## Merger configuration values

    # Listen address of merger gRPC connection, used for health checking
    merger-grpc-listen-addr: :15012
    # Interval between which merger should check if new one block files are available
    merger-time-between-store-lookups: 5s
    # Interval between which now merged one block files are pruned from the store.
    merger-time-between-store-pruning: 60s

    ## Reader configuration values

    # Location of NEAR home, it is passed to `near-firehose-indexer --home <home>` value
    reader-node-data-dir: /data/node
    # Logs coming from `near-firehose-indexer` will be push to you directly without modification,
    # if `true`, logs are ingested first by `firenear` and put through its internal logging system (zap).
    reader-node-log-to-zap: false

    # Transient local folder where reader component can write some files before uploading them
    # to their final destination.
    reader-node-working-dir: /data/reader

    # Listen address of the node manager HTTP interface, the HTTP interface can be used to
    # stop the node, start it back and perform routine maintenance operation.
    reader-node-manager-api-addr: :15009

    # Listen address where blocks read by the reader are pushed to, used by the relayer
    # to receive "live" blocks.
    reader-node-grpc-listen-addr: :15010

    # The reader component will be healthy when read block's time is at most 3600s
    # from now (e.g. healthy if 'now - block's time < 3600s').
    reader-node-readiness-max-latency: 3600s

    # The binary to use to launch the native node process, if not an absolute path
    # like in the case below, the binary must be available in `PATH`. You can also
    # use an absolute path to the binary.
    reader-node-path: near-firehose-indexer

    ## Receipt indexes configuration values

    receipt-index-builder-index-size: 10000
    receipt-index-builder-start-block: 0

    ## Relayer configuration values

    # Listen address of the relayer component, used by `common-live-blocks-addr` to receive
    # live blocks.
    relayer-grpc-listen-addr: :15011

    # The `relayer-max-source-latency` determines the tolerated drift of a source
    # to connect to it (e.g. relayer will accept block from the source only if
    # `now - received block's time < 999999h0m0s`), in our case, we tolerate all
    # drift so we are going to connect to the source, live or not.
    relayer-max-source-latency: 999999h0m0s

    # Address where to reach the reader node(s) to receive blocks from, must be aligned with `reader-node-grpc-listen-addr`
    relayer-source: localhost:15010
```

{% hint style="info" %}
The configuration file can actually by all turned into flags passed to the binary directly if you prefer. The `args` should be joined together with `,` and passed to `firenear start` directly while all the configuration value should be prefixed with `--` and pass as flag.
{% endhint %}

Let's now start the `firenear` stack:

```
firenear -c /data/firehose.yaml start -v
```

If everything is working, you should see logs like this:

```
...
Feb 03 02:54:00.930  INFO network: Error connecting to addr=69.10.52.162:24567 err=Elapsed(())
Feb 03 02:54:02.982  INFO stats: #84349610 Waiting for peers 2 peers ⬇ 12.8 kB/s ⬆ 1.58 kB/s 0.00 bps 0 gas/s CPU: 112%, Mem: 497 MB
2023-02-03T02:54:04.535Z INFO (merger) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/data/storage/merged-blocks/0084350700.dbin.zst", "base_filename": "0084350700", "retry_delay": "4s"}
2023-02-03T02:54:08.536Z INFO (merger) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/data/storage/merged-blocks/0084350700.dbin.zst", "base_filename": "0084350700", "retry_delay": "4s"}
Feb 03 02:54:09.618  INFO network: Error connecting to addr=18.119.163.74:24567 err=Elapsed(())
2023-02-03T02:54:12.537Z INFO (merger) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/data/storage/merged-blocks/0084350700.dbin.zst", "base_filename": "0084350700", "retry_delay": "4s"}
Feb 03 02:54:12.983  INFO stats: #84349610 Waiting for peers 2 peers ⬇ 12.5 kB/s ⬆ 1.43 kB/s 0.00 bps 0 gas/s CPU: 109%, Mem: 498 MB
...
```

Logs that have the date format `Feb 03 02:54:00.930` are coming from NEAR node directly and not from `firenear`. The logs with date format `2023-02-03T02:54:12.537Z` are those from `firenear`. You will see a bunch of logs like `Feb 03 02:56:41.062  INFO network: Error connecting to addr=142.132.150.14:24567 err=Os { code: 111, kind: ConnectionRefused, message: "Connection refused" }`, those are simply stating that `neard` tried to connect to a remote node but the connection was refused.

Logs like `2023-02-03T02:56:40.594Z INFO (merger) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/data/storage/merged-blocks/0084350700.dbin.zst", "base_filename": "0084350700", "retry_delay": "4s"}` are also normal, indeed, we have not yet produced this file because the node is still catching up.

Now, the node is waiting for peers to download the missing block header and to be able to replay the blocks. Once synchronization starts properly, you will see files being produced in `/data/storage/one-blocks` and in `/data/storage/merged-blocks`. It can take many minutes (and even dozen of minutes) before you are able to connect to good peers that will provide good data to you, this is something outside of Firehose controls, read NEAR documentation to try to improve P2P to your node.

{% hint style="info" %}
If you have been stuck a long time on `Feb 03 02:54:02.982 INFO stats: #84349610 Waiting for peers 2 peers ⬇ 12.8 kB/s ⬆ 1.58 kB/s 0.00 bps 0 gas/s CPU: 112%, Mem: 497 MB`, you may want to `Ctrl-C` and start again, sometimes it help getting better peers.
{% endhint %}

Once peering is good, there is still some wait time to download missing headers and state, this depends on how old is the snapshot you started from. You should see logs like:

```
Feb 03 03:09:13.883  INFO stats: #84349610 Downloading headers 21.63% (35334 left; at 84359361) 5 peers ⬇ 9.28 MB/s ⬆ 8.14 MB/s 0.00 bps 0 gas/s CPU: 183%, Mem: 2.52 GB
```

Which gives some information about completion rate. Now it's time to wait, you can monitor `/data/storage/merged-blocks/` folder and wait until a least one merged bundle is produced, you can follow to next steps once you have one. This step can be quite long depending on the peering and the machine used as well as external network factors.

### Operator Notes

NEAR works with a fast replay mode when the node is too far away from the canonical block of the network, this happen if your node is more than 1 (or 2 epochs, it's not 100% clear) away from the rest of the network, the node is going to not process blocks in between and instead "jump" to recent block by download some state snapshot. Firehose cannot work if blocks are missing, so it NEAR node needs to continuously synchronize with the network for Firehose to generate block properly and never create hole. If your node is down for tool long, you will need to fill the whole somehow, see [backfilling](#backfill) below for details.

## Verifying

To verify that everything is good, we are going to install `grpcurl`, a `curl` like command line tool but for gRPC protocol:

```bash
curl -L https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_x86_64.tar.gz | tar zxf -
```

Let's now perform a Firehose stream blocks request:

```bash
grpcurl -plaintext -d '{"start_block_num":0}' localhost:9000 sf.firehose.v2.Stream/Blocks
```

If you see some output, everything is working normally, your instance is working as expected. It will now continue to synchronize with the network.

{% hint style="info" %}
If instead you see something like `Failed to dial target host "localhost:9000": dial tcp 127.0.0.1:9000: connect: connection refused`, it means `firenear` has not produced a single block yet, wait until blocks are present in `/data/storage/merged-blocks` and then try again.
{% endhint %}

## Backfill

Now that you are synchronizing blocks live with the network, you need to backfill blocks that you did not process so far. This can be achieved in two ways:

- Download existing blocks from a trusted provider
- Configure an archive node instead of a full node, and replay blocks you are missing

### Download existing blocks

You can reach to us on Discord to discuss exchanging our NEAR blocks. Note that you will need to pay the egress cost associated with the transfer.

### Archive node

Now that you know how to sync Firehose for NEAR, you can repeat a similar procedure as the tutorial but with an archive node instead. Archive node are able to replay all block from genesis, so when you start with an archive node, you can specify the start block that you desire.

## Docker Images

Docker images are available and come in two flavor. One that only contains `firenear` and another one that we called bundled image that contains `firenear` as well as the [near-firehose-indexer](https://github.com/streamingfast/near-firehose-indexer), which is essentially `neard` codebase wrapped in NEAR indexer framework.

Both kind of image are pushed to repository [ghcr.io/streamingfast/firehose-near](https://ghcr.io/streamingfast/firehose-near), the image's tag can be used to determine which version it is:
- Image containing only `firenear` contains a single `tag` like `ghcr.io/streamingfast/firehose-near:v1.0.0`
- Image containing the bundle `firenear` and `near-firehose-indexer` contains two tags separated by a dash `-` character like `ghcr.io/streamingfast/firehose-near:v1.0.0-1.30.1-fire` which essentially means that `firehose-near` version `v1.0.0` is bundled with `near-firehose-indexer` version `1.30.1-fire`.


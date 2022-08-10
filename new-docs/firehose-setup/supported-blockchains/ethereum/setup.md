---
description: StreamingFast Firehose for Ethereum Setup
---

# Setup

#### Install the StreamingFast version of Geth

StreamingFast's instrumented `Geth` version extracts raw blockchain data from Ethereum nodes. [`Geth`](https://github.com/ethereum/go-ethereum) is the official [Golang](https://go.dev/) implementation of the Ethereum Protocol.

#### Step 1. download StreamingFast Geth&#x20;

Using a web browser download the StreamingFast Geth binary. StreamingFast currently provides binaries for Linux and macOS.

[https://github.com/streamingfast/go-ethereum/releases?q=geth](https://github.com/streamingfast/go-ethereum/releases?q=geth)

#### Step 2. update permissions on the StreamingFast Geth binary

After the download has been completed, open a Terminal window and navigate to the directory where it was saved.

The permissions on the binary must be set to be executable on the target computer.

```bash
chmod +x geth_linux
```

#### Step 3. run the StreamingFast Geth binary

Now, run the binary and check its version to ensure it was properly downloaded and the permissions were correctly set. _Note, if issues are encountered on macOS for this step see the Problems section of this document._

```bash
./geth_linux version
```

A message similar to the following should be displayed in the Terminal window If everything is working correctly.

```bash
INFO [08-08|14:36:21.188] Initializing deep mind 
INFO [08-08|14:36:21.193] Deep mind initialized                    enabled=false sync_instrumentation_enabled=true mining_enabled=false block_progress_enabled=false compaction_disabled=false archive_blocks_to_keep=0 genesis_provenance="Geth Default"
Geth
Version: 1.10.21-fh2
Git Commit: 86d99626c622c2e4e1a22502172c59911675faaf
Architecture: amd64
Go Version: go1.17.12
Operating System: darwin
GOPATH=/Users/<User Account>/go
GOROOT=go
```

_Note, the version will contain the letters "fh" to indicate that this is the instrumented StreamingFast Firehose version of the Geth binary._

Full source code is available for the StreamingFast instrumented version of Geth in its official Git repository.

[https://github.com/streamingfast/sf-ethereum](https://github.com/streamingfast/sf-ethereum)

Installation instructions for the standard, non-instrumented version of Geth are available on the Ethereum website. Installing the standard version of Geth is not required to run Firehose. _The Ethereum documentation provides a deeper understanding of the blockchain and node operation in general._

__[_https://geth.ethereum.org/docs/install-and-build/installing-geth_](https://geth.ethereum.org/docs/install-and-build/installing-geth)__

The next step for completing the setup is to download and install StreamingFast sfeth.

#### Install StreamingFast sfeth

StreamingFast sfeth contains all of the Firehose components including the Extractor, Merger, Relayer, and gRPC Server and is central to a functioning Firehose system. __&#x20;

**Step 1. download StreamingFast sfeth**

Using a web browser download the StreamingFast sfeth archive relevant to the target computer's operating system.&#x20;

[https://github.com/streamingfast/sf-ethereum/releases/latest](https://github.com/streamingfast/sf-ethereum/releases/latest)

**Step 2. extract the sfeth archive**

After sfeth has completed downloading issue the following command in the Terminal window to untar, or extract, the archive. Note, the file name for the archive must match the version that was downloaded.

```bash
tar -xvzf sf-ethereum_0.9.0_linux_x86_64.tar.gz
```

The following message will be displayed in the Terminal window after the archive has been extracted.

```bash
r.gz
x LICENSE
x README.md
x sfeth
```

To verify sfeth was completely downloaded and the application is functional, issue the following command to the Terminal window.

```bash
./sfeth --version
```

The following message will be displayed in the Terminal window if sfeth is working correctly.

```bash
sfeth version 0.10.2 (Commit f0a8987, Built 2022-08-09T12:43:08-07:00)
```

At this point, both the StreamingFast instrumented version of Geth and sfeth have been successfully set up on the target computer.&#x20;

To complete the full Firehose setup and begin syncing the node with the Ethereum Mainnet specific configuration files still need to be edited.

#### StreamingFast sfeth binary configuration

Configuration is the next step following the successful completion of the installation steps for StreamingFast Geth and sfeth.

**Step 1. choose Firehose location on target computer**

Using a Terminal window navigate to the location where the full StreamingFast Firehose system will be stored on the target computer.

**Step 2. Create directory for Firehose**&#x20;

Create a new directory in the location chosen in the previous setup. In the example, the name sf-firehose will be used.

```
mkdir sf-firehose
```

**Step 3. copy binary files into the sf-firehose directory**

```bash
cp <path-to-binary>/geth_linux ./sf-firehose/geth_linux
cp <path-to-binary>/sfeth ./sf-firehose/sfeth
```

Note, commands for the remaining steps use the newly created sf-firehose directory as the main, base working directory.

**Step 4. create sfeth configuration file**

To create a new file quickly issue the following command to the Terminal window.

```
touch eth-mainnet.yaml
```

Next, open the YAML configuration file in an editor. Copy the configuration settings below into the new YAML file.

Ensure that the changes have been saved.

The configuration settings below will sync from Ethereum Mainnet, however, this setup is not production-ready.&#x20;

```yaml
---
start:
  args:
  - mindreader-node
  - firehose

  flags:
    # Sets the verbosity of the application
    verbose: 2

    # Specifies the path where `sfeth` will store all data for all sub processes
    data-dir: eth-data

    # Logs to STDOUT
    log-to-file: false

    # ETH chain ID (from EIP-155) as returned from JSON-RPC `eth_chainId` call
    common-chain-id: "1"

    # ETH network ID as returned from JSON-RPC `net_version` call
    common-network-id: "1"

    # Path to the Geth binary we downloaded in Step 1
    mindreader-node-path: ./geth_linux

    # Tells the Firehose to run without a live stream (i.e. Relayer)
    common-blockstream-addr: ""

    # Instructs the mindreader-node (aka. Extractor) to produce merged-blocks without a Merger
    mindreader-node-merge-and-store-directly: true
```

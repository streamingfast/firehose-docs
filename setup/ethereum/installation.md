---
description: StreamingFast Firehose Ethereum installation documentation
---

# Installation

{% tabs %}
{% tab title="Ethereum/Goerli/Ropsten" %}
<mark style="color:yellow;">**\[\[slm:]**</mark>

<mark style="color:yellow;">**As it stands this documentation is non-functional. It's creating a setup that will not work because of versioning issues with Geth and sf-ethereum.**</mark>

<mark style="color:yellow;">**Note from Matt regarding the issue:**</mark>

<mark style="color:yellow;">**"**</mark>_<mark style="color:yellow;">**With develop branch of sf-ethereum you need to use a version of geth tagged fh2.**</mark>_

_<mark style="color:yellow;">**With release/v0.10.x you need to use version tagged fh1.**</mark>_<mark style="color:yellow;">**"]**</mark>

<mark style="color:yellow;">**Need to figure out the best approach to re-wording and correctly the instructions below that will lead the reader to an actual, working Firehose. it's probably a good idea to go through ALL of the steps in the documentation in a fresh VM or something and NOT a devs box that's already known to function correctly.**</mark>



#### Install StreamingFast Geth

**StreamingFast Geth Setup in Detail**

StreamingFast's instrumented Geth version extracts raw blockchain data from Ethereum nodes.

_Note, Geth is the official_ [_Golang_](https://go.dev/) _implementation of the Ethereum Protocol._

#### Step 1. download StreamingFast Geth

**Download Binary**

Using a web browser download the StreamingFast Geth binary. Download the latest Geth binary or the one with the corresponding Ethereum versioning to match existing node deployments.

Specific binaries for [Binance Smart Chain](https://github.com/streamingfast/go-ethereum/releases/tag/bsc-v1.1.12-fh2) (BSC) and [Polygon](https://github.com/streamingfast/go-ethereum/releases/tag/polygon-v0.2.16-fh2.1) (MATIC) are also provided. Be sure to download the corresponding version for existing node deployments.

Binaries are available for both Linux and macOS.

[https://github.com/streamingfast/go-ethereum/releases?q=geth](https://github.com/streamingfast/go-ethereum/releases?q=geth)

#### Step 2. update Geth binary permissions

**Terminal & chmod to Update**

After the download has been completed, open a Terminal window and navigate to the directory where it was saved.

The permissions on the binary file must be set to be executable for the desired user account on the target computer.

```shell
chmod +x geth_linux
```

#### Step 3. run the Geth binary

**Run Binary & Check Version**

Now, run the binary and check its version to ensure it was properly downloaded and the permissions were correctly set. _Note, if issues are encountered on macOS for this step see the Problems section of this document._

```shell
./geth_linux version
```

**Success Message**

A message similar to the following should be displayed in the Terminal window If everything is working correctly.

```shell
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

**Geth Binary Source Code**

Full source code is available for the StreamingFast instrumented version of Geth in its official Git repository.

[https://github.com/streamingfast/sf-ethereum](https://github.com/streamingfast/sf-ethereum)

**Standard Node Documentation**

Installation instructions for the standard, non-instrumented version of Geth are available on the Ethereum website. Installing the standard version of Geth is not required to run Firehose.

**More Information**

_Note, the_ [_Ethereum documentation_](https://geth.ethereum.org/docs/install-and-build/installing-geth) _provides a deeper understanding of the blockchain and node operation in general._

**Next Steps**

The next step for completing the setup is to download and install StreamingFast sfeth.

#### Install StreamingFast sfeth

**StreamingFast sfeth Setup in Detail**

StreamingFast sfeth contains all of the Firehose components including the Extractor, Merger, Relayer, and gRPC Server and is central to a functioning Firehose system. \_\_

#### **Step 1. download StreamingFast sfeth**

**Download Binary**

Using a web browser download the StreamingFast sfeth archive relevant to the target computer's operating system.

[https://github.com/streamingfast/sf-ethereum/releases/latest](https://github.com/streamingfast/sf-ethereum/releases/latest)

#### **Step 2. extract sfeth archive and update permissions**

**Extract Archive**

After sfeth has completed downloading issue the following command in the Terminal window to untar, or extract, the archive.

_Note, the file name for the archive must match the version that was downloaded._

```shell
tar -xvzf sf-ethereum_0.9.0_linux_x86_64.tar.gz
```

**Archive Extraction Success Message**

The following message will be displayed in the Terminal window after the archive has been extracted.

```shell
r.gz
x LICENSE
x README.md
x sfeth
```

**Run Binary & Check Version**

To verify sfeth was completely downloaded and the application is functional, issue the following command to the Terminal window.

```shell
./sfeth --version
```

**Success Message**

The following message will be displayed in the Terminal window if sfeth is working correctly.

```shell
sfeth version 0.10.2 (Commit f0a8987, Built 2022-08-09T12:43:08-07:00)
```

**Next steps**

At this point, both the StreamingFast sfeth and an instrumented version of Geth have been successfully set up on the target computer.

To complete the full Firehose setup and begin syncing the node with the Ethereum Mainnet specific configuration files still need to be edited.

#### Firehose Working Directory

**Working Directory in Detail**

Firehose needs a home. This will be the main working directory for the Firehose application and files.

#### **Step 1. choose location on target computer**

**Select Destination for Files**

Using a Terminal window navigate to the location where the full StreamingFast Firehose system will be stored on the target computer.

```shell
cd ~; pwd // navigate to home directory
```

_Note, use the target computer's home directory to begin If a dedicated directory hasn't yet been identified or selected._

#### **Step 2. Create directory for Firehose**

**Create New Directory**

Create a new directory in the location chosen in the previous setup. In the example, the name sf-firehose will be used.

```shell
mkdir sf-firehose
```

_Note, commands for the remaining steps use the newly created sf-firehose directory as the main, base working directory._

#### **Step 3. copy binary files into the sf-firehose directory**

**Copy Binaries to Working Directory**

Using the Terminal window copy the files downloaded in the previous steps to the newly created sf-firehose directory.

```shell
cp <path-to-binary>/geth_linux ./sf-firehose/geth_linux
cp <path-to-binary>/sfeth ./sf-firehose/sfeth
```

#### **StreamingFast sfeth Configuration**

**Step 1. create Config File**

To create a new file quickly issue the following command to the Terminal window.

```
touch eth-mainnet.yaml
```

**Step 2. Edit YAML Configuration Settings**

Next, open the YAML configuration file in an editor.

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

Ensure that the changes have been saved after updating the configuration file.

_Note, these settings are not production-ready._

**Synchronization in Detail**

Synchronization is the next step in the process for Ethereum Firehose setup. Additional details on [synchronization](synchronization.md) are provided in the following documentation.

#### Problems

If you are on macOS you could see a warning saying the downloaded binaries are not signed, or the binaries could do nothing at all when run from the terminal.

To fix the problem, remove the quarantine attribute on the file using the following command against the binary:

```bash
xattr -d com.apple.quarantine sfeth
xattr -d com.apple.quarantine geth_mac
```

This step will only need to be done one time.
{% endtab %}

{% tab title="Polygon" %}
_<mark style="color:purple;">**NEED CONTENT**</mark>_
{% endtab %}

{% tab title="BSC" %}
_<mark style="color:purple;">**NEED CONTENT**</mark>_
{% endtab %}
{% endtabs %}

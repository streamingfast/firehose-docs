---
description: StreamingFast Firehose Ethereum installation documentation
---

# Installation

{% tabs %}
{% tab title="Ethereum/Goerli/Ropsten" %}
### Install StreamingFast Geth

**StreamingFast Geth Setup in Detail**

StreamingFast's instrumented Geth version extracts raw blockchain data from Ethereum nodes.

_Note, Geth is the official_ [_Golang_](https://go.dev/) _implementation of the Ethereum Protocol._

### Step 1. Download StreamingFast Geth

**Download Binary**

Use the following link to download the instrumented version of Geth compatible with Firehose version 1.0.

[https://github.com/streamingfast/go-ethereum/releases/tag/geth-v1.10.21-fh1](https://github.com/streamingfast/go-ethereum/releases/tag/geth-v1.10.21-fh1)

#### Binance & Polygon Support

Specific binaries for [Binance Smart Chain](https://github.com/streamingfast/go-ethereum/releases/tag/bsc-v1.1.12-fh2) (BSC) and [Polygon](https://github.com/streamingfast/go-ethereum/releases/tag/polygon-v0.2.16-fh2.1) (MATIC) are also provided.&#x20;

#### Existing Node Deployments

Download the corresponding versions for existing node deployments.

[https://github.com/streamingfast/go-ethereum/releases?q=geth](https://github.com/streamingfast/go-ethereum/releases?q=geth)

Geth binaries are available for both Linux and macOS.

### Step 2. Update Geth binary permissions

**Terminal & chmod to Update**

After the download has been completed, open a terminal window and navigate to the directory where it was saved.

The permissions on the binary file must be set to be executable for the desired user account on the target computer.

```shell
chmod +x geth_linux
```

### Step 3. Run the Geth binary

**Run Binary & Check Version**

Now, run the binary and check its version to ensure it was properly downloaded and the permissions were correctly set.&#x20;

_Note, if issues are encountered on macOS for this step see the_ [_Problems_](installation.md#problems) _section of this document._

```shell
./geth_linux version
```

**Success Message**

A message similar to the following should be displayed in the Terminal window If everything is working correctly.

```shell-session
INFO [08-17|13:09:27.848] Initializing deep mind 
INFO [08-17|13:09:27.848] Deep mind initialized                    enabled=false sync_instrumentation_enabled=true mining_enabled=false block_progress_enabled=false compaction_disabled=false archive_blocks_to_keep=0
Geth
Version: 1.10.21-dm-stable
Git Commit: 5557196d722fa8388df151ddf90a32b9e7c9ae65
Architecture: amd64
Go Version: go1.17.12
Operating System: darwin
GOPATH=/Users/<User Account>sh/go
GOROOT=go
```

_Note, the version will contain the letters "fh" to indicate that this is the instrumented StreamingFast Firehose version of the Geth binary._

**More Information**

_Note, the_ [_Ethereum documentation_](https://geth.ethereum.org/docs/install-and-build/installing-geth) _provides a deeper understanding of the blockchain and node operation in general._

### Install StreamingFast sfeth

**StreamingFast sfeth Setup in Detail**

StreamingFast sfeth contains all of the Firehose components including the Extractor, Merger, Relayer, and gRPC Server and is central to a functioning Firehose __ setup_._

### **Step 1. Download StreamingFast sfeth**

**Download Binary**

Using a web browser download the StreamingFast sfeth archive relevant to the target computer's operating system.

[https://github.com/streamingfast/sf-ethereum/releases/latest](https://github.com/streamingfast/sf-ethereum/releases/latest)

### **Step 2. Extract sfeth archive and update permissions**

**Extract Archive**

After sfeth has completed downloading issue the following command in the terminal window to untar, or extract, the archive.

_Note, the file name for the archive must match the version that was downloaded._

```shell-session
tar -xvzf sf-ethereum_0.9.0_linux_x86_64.tar.gz
```

**Archive Extraction Success Message**

The following message will be displayed in the terminal window after the archive has been extracted.

```shell-session
r.gz
x LICENSE
x README.md
x sfeth
```

**Run Binary & Check Version**

Issue the following command to the terminal window to verify sfeth was completely downloaded and the application fully operational.

```shell-session
./sfeth --version
```

**Success Message**

The following message will be displayed in the terminal window if sfeth is working correctly.

```shell-session
sfeth version 0.10.2 (Commit f0a8987, Built 2022-08-09T12:43:08-07:00)
```

**Next steps**

At this point, both the StreamingFast sfeth and an instrumented version of Geth have been successfully set up on the target computer.

To complete the full Firehose setup and begin syncing the node with the Ethereum Mainnet specific configuration files still need to be edited.

### Firehose Working Directory

**Working Directory in Detail**

Firehose needs a home. This will be the main working directory for the Firehose application and files.

### **Step 1. Choose location on target computer**

**Select Destination for Files**

Using a terminal window navigate to the location where Firehose will be stored on the target computer.

```shell-session
cd ~; pwd // navigate to home directory
```

_Note, use the target computer's home directory to begin If a dedicated directory hasn't yet been identified or selected._

### **Step 2. Create directory for Firehose**

**Create New Directory**

Create a new directory in the location chosen in the previous setup. In the example, the name sf-firehose will be used.

```shell-session
mkdir sf-firehose
```

_Note, commands for the remaining steps use the newly created sf-firehose directory as the main, base working directory._

### **Step 3. copy binary files into the sf-firehose directory**

**Copy Binaries to Working Directory**

Using the Terminal window copy the files downloaded in the previous steps to the newly created sf-firehose directory.

```shell-session
cp <path-to-binary>/geth_linux ./sf-firehose/geth_linux
cp <path-to-binary>/sfeth ./sf-firehose/sfeth
```

### **StreamingFast sfeth Configuration**

#### **Configuration in Detail**

To run sfeth a YAML configuration file is required. This file drives core information needed to get Firehose up and running.

### **Step 1. Create Config File**

#### New Configuration File

To create a new file quickly issue the following command to the terminal window.

```shell-session
touch eth-mainnet.yaml
```

### **Step 2. Edit YAML Configuration Settings**

#### YAML Config

Next, open the YAML configuration file in a text editor.&#x20;

Copy the contents below into the newly created configuration file and save the changes.

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

_Note, these settings are not production-ready._

#### Next Steps

The next step will be dependent on [local](local-deployment.md) or [production](production-deployment.md)-based Firehose deployments. Follow the documentation provided for each to contine.

### Problems

#### macOS Signing Issues

If you are on macOS you could see a warning saying the downloaded binaries are not signed, or the binaries could do nothing at all when run from the terminal.

To fix the problem, remove the quarantine attribute on the file using the following command against the binary:

```bash
xattr -d com.apple.quarantine sfeth
xattr -d com.apple.quarantine geth_mac
```

_This step will only need to be done one time._
{% endtab %}

{% tab title="Polygon" %}
_<mark style="color:purple;">****</mark>_
{% endtab %}

{% tab title="BSC" %}
_<mark style="color:purple;">****</mark>_
{% endtab %}
{% endtabs %}

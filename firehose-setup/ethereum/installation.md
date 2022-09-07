---
description: StreamingFast Firehose Installation
---

# Installation

### Select Blockchain

Geth is the official Golang implementation of the Ethereum Protocol. The Geth binary used with Firehose is an instrumented, customized version provided by StreamingFast.

Geth extracts raw blockchain data from Ethereum nodes. The Firehose-enabled Blockchain Node is an instrumented, or customized, version of the official Geth implementation.&#x20;

#### Blockchain Specific Considerations

StreamingFast provides support for various Ethereum-compatible blockchains ready to use with Firehose. The overall setup and installation process is very similar across the different Ethereum-compatible blockchains.

Each blockchain also has specific requirements for processing power, RAM, available disk space, and write speed that need to be considered.

Every Ethereum-compatible blockchain has specific requirements and other differences that should be taken into consideration before rolling out a production Firehose solution. Some **** blockchains, such as Binance, have specific requirements for disk size or write speed for example.

#### Available Geth Releases

All Firehose instrumented Geth binaries are provided on the Firehose go-ethereum [releases page](https://github.com/streamingfast/go-ethereum). Direct links to the latest Geth binaries for the supported Ethereum-compatible blockchains are also provided below.

Obtaining the Firehose instrumented version of Geth for the target blockchain is the next step in the Firehose setup process. The setup process differs slightly for the different blockchains.

**Default Blockchain for Geth**

_Ethereum is the default implementation for firehose-ethereum_ and uses the Geth version that does not contain references to any other blockchains in its release title or file name. The Geth binaries provided by StreamingFast have “fh” within the version to indicate they’re not the standard, non-instrumented, community-developed node version.

_**Firehose Versions**_

Firehose v1.0.0 is the most recent release of Firehose. Release versions are also provided for legacy versions of Firehose. It is recommended that new setups use the latest version and existing setups are upgraded as soon as possible.

It’s important that the Geth binary file’s version matches the Firehose for Ethereum binary file version. Firehose for Ethereum binaries v1.0.0 and above will only work with Firehose-instrumented Geth versions tagged with “fh2". The older Firehose-instrumented Geth versions tagged “fh1” are legacy versions and should not be used anymore.

Ensure that the Geth Firehose and fireeth versions match. When errors are encountered during Firehose setup it’s often because of this versioning of Geth and fireeth. Double-check both binaries using the appropriate versioning commands provided in this documentation.

Current legacy **** Firehose operators can find additional information in the [Update Firehose](https://docs.google.com/document/d/1PMf\_od2VuGirl8VS3rH-WO9OrPKkZ5rAQb28BcmeN18/edit) section of the documentation.

Once the target blockchain has been identified the next step is to download the binary version of Geth provided by StreamingFast.

### Install Geth

#### Download Binary

Choose the Geth binary associated with the blockchain being targeted for the Firehose implementation being created. Firehose is currently available for Linux and macOS and binaries are provided for each operating system.

Save the Geth binary to a convenient location on the computer Firehose is being set up on. StreamingFast recommends simply saving binaries to the default Go/bin directory on the target machine. This will enable system-wide calls to the apps within the StreamingFast suite, such as Firehose.

_**Ethereum Geth**_

Linux

[https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_linux](https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_linux)

macOS

[https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_mac](https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_mac)

_**Binance Geth**_

Linux

[https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_linux](https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_linux)

macOS

****[https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_mac](https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_mac)

_**Polygon Geth**_

Linux

****[https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_linux](https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_linux)

macOS

[https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_mac](https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_mac)

#### Run Binary & Check Version

The next step is to run the binary, passing the version flag. The Geth version will be displayed in the terminal window. This aids in ensuring the correct Geth version was downloaded.

_Note, see the_ [_Problems_](https://docs.google.com/document/d/1PMf\_od2VuGirl8VS3rH-WO9OrPKkZ5rAQb28BcmeN18/edit) _section of this document to resolve issues related to signing, or digital signatures, encountered on macOS for this step._

`./geth_linux version`

_**Success Message**_

A message similar to the following should be displayed in the terminal window If everything is working correctly.

The version seen in the message printed to the terminal should match the version of the Firehose binary downloaded in the following steps.

```shell-session
INFO [09-02|09:42:23.128] Initializing firehose 
INFO [09-02|09:42:23.136] Firehose initialized                     enabled=false sync_instrumentation_enabled=true mining_enabled=false block_progress_enabled=false compaction_disabled=false archive_blocks_to_keep=0 genesis_provenance="Geth Default" firehose_version=2.0 geth_version=1.10.23-fh2 chain_variant=geth
Geth
Version: 1.10.23-fh2
Git Commit: e7f3686b2f8955a0824140c98f88c4e3c94f9741
Architecture: amd64
Go Version: go1.17.13
Operating System: darwin
GOPATH=/Users/<User Account>/go
GOROOT=go
```

### Install Firehose

#### Download Firehose Binary

Save the Firehose binary to the main Firehose directory created in the first step of the setup process. After the file has completed downloading extract the archive to obtain the binary file contained within.

_**Firehose for Linux**_&#x20;

[https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_linux\_x86\_64.tar.gz](https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_linux\_x86\_64.tar.gz)

_**Firehose for macOS**_&#x20;

[https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_x86\_64.tar.gz](https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_x86\_64.tar.gz)

_**Firehose for macOS ARM**_

[https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_arm64.tar.gz](https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_arm64.tar.gz)

#### Run Binary & Check Version

The next step is to run the binary, passing the version flag. The Firehose version will be displayed in the terminal window. This aids in ensuring the correct Firehose version was downloaded.

_Note, see the Problems section of this document to resolve issues related to signing, or digital signatures, encountered on macOS for this step._

`./fireeth --version`

_**Success Message**_

The following message will be displayed in the terminal window if Firehose is working correctly.

```shell-session
fireeth version 1.0.0 (Commit 42f870c, Built 2022-09-02T17:07:45Z)
```

#### Next Steps

The following steps will differ slightly for each blockchain. Specific configuration steps, settings, and processes are outlined for blockchains currently supported by StreamingFast. Other blockchains beyond the ones currently supported can be used with Firehose through the process of instrumentation. Information is provided for the instrumentation process of [new blockchains](https://firehose.streamingfast.io/integrate-new-chains/new-blockchains).

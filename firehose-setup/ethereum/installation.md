---
description: StreamingFast Firehose Ethereum Installation
---

# Installation

## Firehose Installation

### Installation Intro

Firehose installation is accomplished through a few fairly simple tasks including obtaining specific binaries and some configuration steps.

It's important to note that Firehose comes in many different flavors for different blockchains. Firehose also has a legacy version and a new version. The setup process isn't difficult however having a clear idea and path in mind before you begin is recommended.

After Firehose has been installed, configured, and synchronized with the target blockchain operating the software becomes the primary goal.

Documentation is provided for the various blockchains and versions of Firehose to get operators up and running as quickly as possible.

## Docker Installation

Firehose for Ethereum is available as a Docker image for quick and easy installation. Visit the following link to install Firehose through Docker.

[https://github.com/streamingfast/firehose-ethereum/pkgs/container/firehose-ethereum](https://github.com/streamingfast/firehose-ethereum/pkgs/container/firehose-ethereum)

Install Firehose using Docker through the terminal using the following command.

```
docker pull ghcr.io/streamingfast/firehose-ethereum:40d5054
```

## StreamingFast Geth

Geth extracts raw blockchain data from Ethereum nodes. The StreamingFast Firehose-enabled Blockchain Node is an instrumented, version of the official Geth implementation.

{% hint style="info" %}
**Note**_: Geth is the official Golang implementation of the Ethereum Protocol._
{% endhint %}

StreamingFast provides support for various Ethereum-compatible blockchains ready to use with Firehose. The overall setup and installation process is very similar across the different Ethereum-compatible blockchains.

Every Ethereum-compatible blockchain has specific requirements and other differences that should be taken into consideration before rolling out a production Firehose solution.

{% hint style="warning" %}
**Important**_: Each blockchain has specific requirements for processing power, RAM, available disk space, and write speed that need to be considered._
{% endhint %}

### Available StreamingFast Geth Releases

All Firehose instrumented Geth binaries are provided on the Firehose go-ethereum [releases page](https://github.com/streamingfast/go-ethereum). Direct links to the latest Geth binaries for the supported Ethereum-compatible blockchains are also provided below.

Obtaining the instrumented version of Geth for the target blockchain is the first step in the Firehose setup process. The setup process differs slightly for the different blockchains.

### **Default Blockchain for Geth**

_Ethereum is the default implementation for firehose-ethereum_ and uses the Geth version that _does not_ contain references to any other blockchains in its release title or file name.

The Geth binaries provided by StreamingFast have “fh” within the version to indicate they’re not the standard, non-instrumented, community-developed node version.

### **Firehose Versions**

Firehose v1.0.0 is the most recent release of Firehose. Release versions are also provided for legacy versions of Firehose. It is recommended that new setups use the latest version and existing setups are upgraded as soon as possible.

It’s important that the Geth binary file’s version matches the Firehose for Ethereum binary file version. Firehose for Ethereum binaries v1.0.0 and above will only work with Firehose-instrumented Geth versions tagged with “fh2". The older Firehose-instrumented Geth versions tagged “fh1” are legacy versions and should not be used anymore.

Ensure that the Geth Firehose and fireeth versions match. When errors are encountered during Firehose setup it’s often because of this versioning between Geth and fireeth. Double-check both binaries using the appropriate versioning commands provided in this documentation.

{% hint style="info" %}
_Note: Current legacy Firehose operators can find additional information in the Update Firehose section of the documentation._
{% endhint %}

## Install Geth

### Download Binary

Choose the Geth binary associated with the blockchain being targeted for the Firehose implementation being created. Firehose is currently available for Linux and macOS and binaries are provided for each operating system.

Save the Geth binary to a convenient location on the computer Firehose is being set up on. StreamingFast recommends simply saving binaries to the `/usr/local/bin` directory on the target machine. This will enable system-wide calls to the apps within the StreamingFast suite, such as Firehose.

### _**Ethereum Geth**_

#### Linux

[https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_linux](https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_linux)

#### macOS

[https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_mac](https://github.com/streamingfast/go-ethereum/releases/download/geth-v1.10.23-fh2.1/geth\_mac)

### **Binance Geth**

#### Linux

[https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_linux](https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_linux)

#### macOS

[https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_mac](https://github.com/streamingfast/go-ethereum/releases/download/bsc-v1.1.12-fh2.2/geth\_mac)

### **Polygon Geth**

#### Linux

[https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_linux](https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_linux)

#### macOS

[https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_mac](https://github.com/streamingfast/go-ethereum/releases/download/polygon-v0.2.16-fh2.3/geth\_mac)

### Run Binary & Check Version

To check the status of the Geth setup run the binary and pass it the version flag. The Geth version will be displayed in the terminal window. This aids in ensuring the correct Geth version was downloaded.

{% hint style="info" %}
_Note: see the Problems section of this document to resolve issues related to signing, or digital signatures, encountered on macOS for this step._
{% endhint %}

`./geth_linux version`

### **Success Message**

A message similar to the following should be displayed in the terminal window If everything is working correctly.

The version seen in the message printed to the terminal should match the version of the Firehose binary downloaded in the following steps.

```bash
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

## Install Firehose

### Download Firehose Binary

Save the Firehose binary to the main Firehose directory. After the archive has completed downloading extract it to obtain the Firehose binary.

### **Firehose for Linux**

[https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_linux\_x86\_64.tar.gz](https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_linux\_x86\_64.tar.gz)

### **Firehose for macOS**

[https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_x86\_64.tar.gz](https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_x86\_64.tar.gz)

### **Firehose for macOS ARM**

[https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_arm64.tar.gz](https://github.com/streamingfast/firehose-ethereum/releases/download/v1.0.0/fireeth\_1.0.0\_macOS\_arm64.tar.gz)

### Run Binary & Check Version

To check the status of the Firehose setup run the binary and pass it the version flag. The Firehose version will be displayed in the terminal window. This aids in ensuring the correct Firehose version was downloaded.

`./fireeth --version`

{% hint style="info" %}
**Note**_: see the Problems section of this document to resolve issues related to signing, or digital signatures, encountered on macOS for this step._
{% endhint %}

### **Success Message**

The following message will be displayed in the terminal window if Firehose is working correctly.

```bash
fireeth version 1.0.0 (Commit 42f870c, Built 2022-09-02T17:07:45Z)
```

### Next Steps

The following steps will differ slightly for each blockchain. Specific configuration steps, settings, and processes are outlined for blockchains currently supported by StreamingFast.

Another consideration is where the Firehose setup will be deployed. The next steps for full setup are determined by specifics for the target environment and blockchain. Documentation is provided for [single-machine deployment](./local-deployment.md) for now.

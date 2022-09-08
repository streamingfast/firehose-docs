---
description: StreamingFast Firehose template
---

# Firehose ACME

### Firehose ACME

#### Firehose AMCE Intro

Firehose-ACME is the main starting point for instrumenting new, unsupported blockchain nodes.

It consists of basic code and a faux data provision application called the Dummy Blockchain, or `dchain.`

Firehose ACME is available on GitHub. Clone the repo to obtain the source code.

```shell-session
git clone git@github.com:streamingfast/firehose-acme
```

### Firehose-ACME Installation

#### Installation

The following command is used to install Firehose-ACME.

```shell-session
go install -v ./cmd/fireacme
```

The installation process copies the `fireacme` binary file into the computer's default Go binary directory, `~/go/bin`.&#x20;

Additional information can be generated from Firehose when the --`version` flag is passed into the `fireacme` command.

```shell-session
fireacme --version
```

Firehose versioning information will display as follows.

```shell-session
fireacme version dev (Built 2022-08-05T15:36:44-07:00) 
```

### Dummy Blockchain

#### Dummy Blockchain Setup

The Dummy Blockchain can be set up anywhere on the target computer.

The Dummy Blockchain should be started and allowed to run for at least a few minutes. This will enable the application enough time and processing facilities to generate faux blockchain data for Firehose to consume.

Obtain the Dummy Blockchain from GitHub.

[https://github.com/streamingfast/dummy-blockchain](https://github.com/streamingfast/dummy-blockchain)

### Testing Firehose-ACME

#### YAML Configuration

The full path into the dchain directory must be used. The path needs to be in quotes.

Example path:

```shell-session
extractor-node-path: "/Users/<User Account>/Desktop/SFFireshose/dummy-blockchain/dchain"
```

The shell script that starts Firehose-ACME is located inside the devel/standard directory.&#x20;

The following messages will be printed to the terminal window if&#x20;

* all of the configuration changes were made correctly,&#x20;
* all system paths have been set correctly,
* &#x20;and the Dummy Blockchain was installed and set up correctly.

```shell-session
2022-08-03T11:22:30.744-0700 INFO (fireacme) starting Firehose on Acme with config file 'standard.yaml'
2022-08-03T11:22:30.750-0700 INFO (fireacme) launching applications: extractor-node,firehose,merger,relayer
start --store-dir=/Users/<User Account>/Desktop/dfuse/integrate/firehose-acme/devel/standard/firehose-data/extractor/data --dm-enabled --block-rate=6
2022-08-03T11:22:31.924-0700 INFO (extractor.acme) level=info msg="initializing node"
2022-08-03T11:22:31.927-0700 INFO (extractor.acme) level=info msg="initializing store"
2022-08-03T11:22:31.928-0700 INFO (extractor.acme) level=info msg="loading last block" tip=165
2022-08-03T11:22:31.929-0700 INFO (extractor.acme) level=info msg="initializing engine"
2022-08-03T11:22:31.948-0700 INFO (extractor.acme) level=info msg="starting block producer" rate=10s
2022-08-03T11:22:31.948-0700 INFO (extractor.acme) level=info msg="starting server" addr="0.0.0.0:8080"
2022-08-03T11:22:41.931-0700 INFO (extractor.acme) level=info msg="processing block" hash=e0f05da93a0f5a86a3be5fc0e301606513c9f7e59dac2357348aa0f2f47db984 height=166
```

Real-world implementations don't use or rely on the Dummy Blockchain application or its data.

Existing, current, and knowledgable node operators can take advantage of the pre-instrumented blockchain solutions provided by StreamingFast for their specific blockchain.

Blockchains that do not currently have a StreamingFast instrumented node client solution can create their own.

### Problems

#### Incorrect Example Blockchain Path

The following message will be displayed in the shell if the path to the example blockchain application is incorrect.

```shell-session
2022-08-02T14:50:42.153-0700 INFO (fireacme) starting Firehose on Acme with config file 'standard.yaml'
2022-08-02T14:50:42.171-0700 INFO (fireacme) launching applications: extractor-node,firehose,merger,relayer
start --store-dir=/Users/<User Account>/Desktop/SFFirehose/firehose-acme/devel/standard/firehose-data/extractor/data --dm-enabled --block-rate=6
2022-08-02T14:50:43.181-0700 ERRO (fireacme) 
################################################################
Fatal error in app extractor-node:
instance "acme" stopped (exit code: -1), shutting down
################################################################
2022-08-02T14:50:43.181-0700 ERRO (extractor) {"status": {"Cmd":"/Users/<User Account>/Desktop/SFFirehose/dummy-blockchain","PID":0,"Exit":-1,"Error":{"Op":"fork/exec","Path":"/Users/<User Account>/Desktop/SFFirehose/dummy-blockchain","Err":13},"StartTs":1659477043178396000,"StopTs":1659477043181083000,"Runtime":0,"Stdout":null,"Stderr":null}} command terminated with non-zero status, last log lines:
<None>
```

---
description: StreamingFast Firehose Demo setup documentation
---

# Firehose Demo

The Firehose Demo can be run without a fully functioning blockchain node. The demo is a quick way to evaluate and better understand a real, live-running Firehose system.&#x20;

The demo consists of a basic templated Firehose system and a faux data provision application called the Dummy Blockchain, or DChain.

Note, that the _Firehose-ACME demo template is also the starting point for instrumenting new, unsupported blockchain nodes. Additional information is available in the Unsupported Blockchains documentation._

The following steps explain how to set up the Firehose-ACME demo.

#### Step 1. Create Firehose directory

Find a location on the target computer to download and store the Firehose application's source code and related files. Create a new directory in the chosen location and name it something like "Firehose."

Open a new Terminal window. Navigate to the destination on the target computer where the Firehose files will be stored.

```
cd /Users/<User Account>/Desktop/ 
// Just an example, choose a directory 
// on the target computer
```

Create the new directory and navigate into it. The pwd command will print the full path to the new directory to the Terminal. This will be the working directory for the remaining steps in the installation process.

```
mkdir SFFirehose; cd SFFirehose; pwd
```

#### Step 2. Clone the Firehose-ACME repo

Next, clone the Firehose-ACME project into the directory created in step one.

```
git clone git@github.com:streamingfast/firehose-acme
```

#### Step 3. Install Firehose-ACME

Run the installation process for the Firehose-ACME Demo.

```
go install -v ./cmd/fireacme
```

The installation process copies the fireacme binary file into the computer's default Go binary directory.

The standard default Go binary directory is `~/go/bin`.&#x20;

The GOPATH can be checked by issuing the echo command followed by the system variable preceded by a dollar sign.

```
echo $GOPATH
```

To ensure the Firehose-ACME Demo binary is executable on the command line through the shell run the binary and pass the version flag.&#x20;

```
fireacme --version
```

If everything has been set up correctly the version will be printed to the Terminal window.

```
fireacme version dev (Built 2022-08-05T15:36:44-07:00) 
```

_Ensure the Firehose-ACME path is in the system's PATH before continuing._

#### Step 4. Set up the example blockchain application

Follow the installation instructions located on the example blockchain's official Git repository.

[https://github.com/streamingfast/dummy-blockchain](https://github.com/streamingfast/dummy-blockchain)

_**--- CONTINUE EDITING HERE --->**_

#### Step 5. Test with the example blockchain application data

Modify `devel/standard/standard.yaml` to point to the dummy chain implementation.&#x20;

The full path into the dchain directory must be used. The path needs to be in quotes.

Example path:

```
extractor-node-path: "/Users/<User Account>/Desktop/dfuse/integrate/dummy-blockchain/dchain"
```

#### Problems

Ensure there is a space between the colon after the extractor-node-path field and the quote that starts the path to the dchain binary on the target computer. Notice the missing space in the example directly below. &#x20;

**extractor-node-path**:"/&#x20;

The following error will be displayed for an incorrectly formatted field in the YAML config file.&#x20;

Error: unable to read config file "standard.yaml": reading json: yaml: line 10: did not find expected key

The following message will be displayed in the shell if the path to the example blockchain application is incorrect.

2022-08-02T14:50:42.153-0700 INFO (fireacme) starting Firehose on Acme with config file 'standard.yaml'

2022-08-02T14:50:42.171-0700 INFO (fireacme) launching applications: extractor-node,firehose,merger,relayer

start --store-dir=/Users/seanmoore-mpb/Desktop/dfuse/integrate/firehose-acme/devel/standard/firehose-data/extractor/data --dm-enabled --block-rate=6

2022-08-02T14:50:43.181-0700 ERRO (fireacme)&#x20;

\################################################################

Fatal error in app extractor-node:

instance "acme" stopped (exit code: -1), shutting down

\################################################################

2022-08-02T14:50:43.181-0700 ERRO (extractor) {"status": {"Cmd":"/Users/seanmoore-mpb/Desktop/dfuse/integrate/dummy-blockchain","PID":0,"Exit":-1,"Error":{"Op":"fork/exec","Path":"/Users/seanmoore-mpb/Desktop/dfuse/integrate/dummy-blockchain","Err":13},"StartTs":1659477043178396000,"StopTs":1659477043181083000,"Runtime":0,"Stdout":null,"Stderr":null\}} command terminated with non-zero status, last log lines:

\<None>

_--- DEV NOTE ---_

_The content below was pulled over from the GitHub repo. Some of it may be useful for the content on this page._

_--- /DEV NOTE ---_

We have built an end-to-end template, to start the on-boarding process of new chains. This solution consist of:

firehose-acme As mentioned above, the Extractor process consumes the data that is extracted and streamed from Deeepmind. In Actuality the Extractor is one process out of multiple ones that creates the Firehose. These processes are launched by one application. This application is chain specific and by convention, we name is "firehose-". Though this application is chain specific, the structure of the application is standardized and is quite similar from chain to chain. For convenience, we have create a boiler plate app to help you get started. We named our chain Acme this the app is firehose-acme

DeepMind Deepmind consist of an instrumented syncing node. We have created a "dummy" chain to simulate a node process syncing that can be found https://github.com/streamingfast/dummy-blockchain.

Additional links:

* https://github.com/streamingfast/firehose-acme
* https://github.com/streamingfast/dummy-blockchain

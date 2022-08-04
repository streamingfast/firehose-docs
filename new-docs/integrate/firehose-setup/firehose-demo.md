---
description: StreamingFast Firehose Demo setup documentation
---

# Firehose Demo

The Firehose Demo can be run without a full blockchain node and is a great introduction to a real, live-running Firehose system.&#x20;

The demo consists of a basic templated Firehose system and a faux data provision application called the Dummy Blockchain, or DChain.

Note, that the _Firehose-ACME demo template is also the starting point for instrumenting new, unsupported blockchain nodes._

Follow the steps below to get started with the Firehose Demo.

#### Step 1. Create Firehose directory

Find a suitable location on the computer Firehose is being installed. Use that location to store the application's source code and related files. A new directory can be created on the target computer, such as "Firehose".

#### Step 2. Clone the Firehose-ACME repo

Navigate to the directory chosen or created in step one.

Using a Linux-based shell, such as Bash or Z shell, clone the Firehose-ACME project. GitDesktop can also be used to clone the project however using a shell is required for the subsequent steps.

```
git clone git@github.com:streamingfast/firehose-acme
```

#### Step 3. Install Firehose-ACME

Run the installation process for the Firehose-ACME project.

```
go install -v ./cmd/fireacme
```

\--- DEV NOTE ---

I can't see where this was updated on my system after installation. I'm not sure about the accuracy of this part. Need to check with team on these next couple of paragraphs.

I'll have to double-check but I think the latest installation of Go changed how it sets the PATH somehow.

\--- /DEV NOTE ---

The `fireacme` binary will be added to the computer's `GOPATH`. The typical GOPATH directory is `~/go/bin`.&#x20;

_Ensure the Firehose-ACME path is in the systems `PATH` before continuing._

#### Step 4. Set up the example blockchain application

Follow the installation instructions located on the example blockchain's official Git repository.

\--- DEV NOTE ---

Need to either add new, working instructions on this page or update the existing documentation in the dummy blockchain Git repo.

Also, need to remember to hunt back through the existing Git repositories to remove outdated instructions and information. Those areas can link to this new documentation where appropriate.

\--- /DEV NOTE ---

#### Step 5. Test with the example blockchain application data

Modify `devel/standard/standard.yaml` to point to the dummy chain implementation.&#x20;

The full path into the dchain directory must be used. The path needs to be in quotes.

\--- DEV NOTE ---

Make sure to account for old, outdated, non-working references to "dummy-blockchain", it's now "dchain." This is applicable to code, so it impacts functionality.

Include instructions for running the example blockchain to generate data for Firehose-ACME to use. I let mine create around three hundred blocks.

\--- /DEV NOTE ---

**Example path:**

**extractor-node-path**: "/Users/janes-macbook/Desktop/dfuse/integrate/dummy-blockchain/dchain"

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

\--- CONTINUE HERE ---

\--- DEV NOTE ---

Firehose-ACME and Dummy Blockchain run on the same http port so they can't be running at the same time. Be sure to mention this somewhere, it caused me a bit of trouble.

The content below was pulled over from the GitHub repo. Some of it may be useful for the content on this page.

\--- /DEV NOTE ---

We have built an end-to-end template, to start the on-boarding process of new chains. This solution consist of:

firehose-acme As mentioned above, the Extractor process consumes the data that is extracted and streamed from Deeepmind. In Actuality the Extractor is one process out of multiple ones that creates the Firehose. These processes are launched by one application. This application is chain specific and by convention, we name is "firehose-". Though this application is chain specific, the structure of the application is standardized and is quite similar from chain to chain. For convenience, we have create a boiler plate app to help you get started. We named our chain Acme this the app is firehose-acme

DeepMind Deepmind consist of an instrumented syncing node. We have created a "dummy" chain to simulate a node process syncing that can be found https://github.com/streamingfast/dummy-blockchain.

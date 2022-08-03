---
description: StreamingFast Firehose base setup documentation
---

# Firehose Setup

The first step in creating a fully functional, custom Firehose system is setting up the core application using a template provided by StreamingFast.

The template, called Firehose-ACME, is also the starting point for instrumenting a new blockchain node.

The Firehose system can be connected to a simple example blockchain to ensure the setup is working properly.

Custom instrumentation can begin after the Firehose template and base have been set up and tested with the example blockchain application.

#### Step 1. Create Firehose directory

Find a suitable location on the computer Firehose is being installed on to store the application's source code and related files. A new directory can be created such as Firehose.

#### Step 2. Clone the Firehose-ACME repo

Navigate to the directory choosen or created in step one.

Using a Linux-based shell, such as Bash or Z shell, clone the Firehose-ACME project. GitDesktop can also be used to clone the project however using a shell is required for the following steps.

```
git clone git@github.com:streamingfast/firehose-acme
```

#### Step 3. Install Firehose-ACME

Run the installation process for the Firehose-ACME project.

```
go install -v ./cmd/fireacme
```

\--- NOTE ---

I can't see where this was updated on my system after installation. I'm not sure about the accuracy of this part. Need to check with team on these next couple of paragraphs.

_--- /NOTE ---_

The `fireacme` binary will be added to the computer's `GOPATH`. The typical GOPATH directory is `~/go/bin`.&#x20;

_Ensure the Firehose-ACME path is in the systems `PATH` before continuing._

#### Step 4. Set up the example blockchain application

Follow the installation instructions located on the example blockchain's official Git repository.

\--- NOTE ---

Need to either add new, working instructions on this page or update the existing documentation in the dummy blockchain Git repo.

Also, need to remember to hunt back through the existing Git repositories to remove outdated instructions and information. Those areas can link to this new documentation where appropriate.

\--- /NOTE ---

#### Step 5. Test with the example blockchain application data

Modify `devel/standard/standard.yaml` to point to the dummy chain implementation.&#x20;

\--- NOTE ---

The full path into the dchain directory must be used. The path needs to be in quotes.

Make sure to account for old, outdated, non-working references to "dummy-blockchain", it's now "dchain."

Include instructions for running the example blockchain to generate data for Firehose-ACME to use. I let mine create around three hundred blocks.

\--- /NOTE ---

**Example path:**

**extractor-node-path**: "/Users/janes-macbook/Desktop/dfuse/integrate/dummy-blockchain/dchain"

Ensure there is a space between the colon after the extractor-node-path field and the quote that starts the path to the dchain binary on the target computer. Notice the missing space in the example directly below. &#x20;

**extractor-node-path**:"/&#x20;

The following error will be displayed for an incorrectly formatted field in the YAML config file.&#x20;

Error: unable to read config file "standard.yaml": reading json: yaml: line 10: did not find expected key

Also, show the output from Firehose when the path is wrong; the error isn't representative of what the issue actually is.

The following message will be displayed in the Terminal if the path to the example blockchain application is incorrect.

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

\--- NOTE ---

Firehose-ACME and Dummy Blockchain run on the same http port so they can't be running at the same time. Be sure to mention this somewhere, it caused me a bit of trouble.

\--- /NOTE ---

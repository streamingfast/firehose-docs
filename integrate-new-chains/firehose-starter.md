---
description: StreamingFast Firehose template
---

# Firehose Template

### Firehose Template Project&#x20;

#### Firehose Template in Detail

The Firehose-ACME template is the main starting point for instrumenting new, unsupported blockchain nodes.

#### Firehose Template & Faux Data

The template consists of basic code and a faux data provision application called the Dummy Blockchain, or dchain.

### Firehose Template Setup

The following steps explain how to set up the Firehose-ACME template with the Dummy Blockchain.

### Step 1. Create Firehose directory

#### Select Location

Find a location on the target computer to download and store the Firehose-ACME template application's source code and related files.

#### Navigate to Location

Open a new terminal window. Navigate to the destination on the target computer where Firehose files will be stored.

```shell-session
cd /Users/<User Account>/Desktop/
```

#### Create Directory

Create a new directory in the chosen location and name it something like "SFFirehose."

Create the new directory and navigate into it.&#x20;

```shell-session
mkdir SFFirehose; cd SFFirehose; pwd
```

The pwd command will print the full path to the new directory to the Terminal. This will be the working directory for the remaining steps in the installation process.

### Step 2. Clone the Firehose-ACME repo

#### Clone Repo

Next, clone the Firehose-ACME template into the SFFirehose directory created in step one.

```shell-session
git clone git@github.com:streamingfast/firehose-acme
```

### Step 3. Install Firehose-ACME

#### Firehose-ACME Installation

Run the installation process for the Firehose-ACME starter.

```shell-session
go install -v ./cmd/fireacme
```

The installation process copies the fireacme binary file into the computer's default Go binary directory.

#### Standard Go Binary Location

The standard default Go binary directory is `~/go/bin`.&#x20;

#### Go PATH Settings

The GOPATH can be checked by issuing the echo command followed by the system variable preceded by a dollar sign.

```shell-session
echo $GOPATH
```

#### Check Firehose-ACME Version

To ensure the Firehose-ACME binary is executable on the command line through the shell run the binary and pass the version flag.&#x20;

```shell-session
fireacme --version
```

#### Success Message

If everything has been set up correctly the version will be printed to the Terminal window.

```shell-session
fireacme version dev (Built 2022-08-05T15:36:44-07:00) 
```

_Ensure the Firehose-ACME path is in the system's PATH before continuing._

### Step 4. Set up the Dummy Blockchain application

#### Dummy Blockchain Setup in Detail

Follow the installation instructions located on the example blockchain's official Git repository.

[https://github.com/streamingfast/dummy-blockchain](https://github.com/streamingfast/dummy-blockchain)

The Dummy Blockchain can be set up anywhere on the target computer. Make a note of the full path where the Dummy Blockchain is located. The path is needed in the following steps.

#### Run Dummy Blockchain

The Dummy Blockchain should be started and allowed to run for at least a few minutes. This will enable the application enough time and processing facilities to generate faux blockchain data for Firehose to consume in the following steps.

### Step 5. Test the Firehose-ACME template

#### Navigate to Firehose-ACME Location

Using a terminal window navigate to the directory that Firehose was downloaded and set up within. The path will look something similar to the following.

```shell-session
/Users//Desktop/<User Account>/SFFirehose/
```

#### Standard Directory

Next, navigate into the directory named "standard", inside of the directory named "devel", under the main firehose-acme directory.

```shell-session
cd /Users//Desktop/<User Account>/SFFirehose/standard/devel
```

#### YAML Configuration

Open the Firehose-ACME template standard.yaml configuration file to update the path to the Dummy Blockchain.

#### Update Path

The full path into the dchain directory must be used. The path needs to be in quotes.

Example path:

```shell-session
extractor-node-path: "/Users/<User Account>/Desktop/SFFireshose/dummy-blockchain/dchain"
```

#### Save Changes

Ensure the file has been saved with the updated path information and then return to the Terminal window.

_Note, for real-world Firehose setups, the path that points at the Dummy Blockchain would typically be directed at an actual blockchain node that has been instrumented for Firehose._

### Step 6. Start Firehose

#### Start Firehose-ACME

The shell script that starts the Firehose-ACME template is located inside the devel/standard directory. The terminal's shell session should still be using this directory.

Issue the following command in the terminal window to start the Firehose-ACME template.

```shell-session
./start.sh
```

To stop the Firehose-ACME template at any time press down on the Control key and then press the C key.&#x20;

The following messages will be printed to the terminal window if&#x20;

* all of the configuration changes were made correctly,&#x20;
* all system paths have been set correctly,
* &#x20;and the Dummy Blockchain was installed and set up correctly.

```shell-session
2022-08-03T11:22:30.744-0700 INFO (fireacme) starting Firehose on Acme with config file 'standard.yaml'
2022-08-03T11:22:30.750-0700 INFO (fireacme) launching applications: extractor-node,firehose,merger,relayer
start --store-dir=/Users/seanmoore-mpb/Desktop/dfuse/integrate/firehose-acme/devel/standard/firehose-data/extractor/data --dm-enabled --block-rate=6
2022-08-03T11:22:31.924-0700 INFO (extractor.acme) level=info msg="initializing node"
2022-08-03T11:22:31.927-0700 INFO (extractor.acme) level=info msg="initializing store"
2022-08-03T11:22:31.928-0700 INFO (extractor.acme) level=info msg="loading last block" tip=165
2022-08-03T11:22:31.929-0700 INFO (extractor.acme) level=info msg="initializing engine"
2022-08-03T11:22:31.948-0700 INFO (extractor.acme) level=info msg="starting block producer" rate=10s
2022-08-03T11:22:31.948-0700 INFO (extractor.acme) level=info msg="starting server" addr="0.0.0.0:8080"
2022-08-03T11:22:41.931-0700 INFO (extractor.acme) level=info msg="processing block" hash=e0f05da93a0f5a86a3be5fc0e301606513c9f7e59dac2357348aa0f2f47db984 height=166
```

If the output seen in the target computer's Terminal looks resembles the sample above the Firehose-ACME template has been successfully set up and is functional. _Congratulations!_&#x20;

### Conclusion

#### Firehose Template in Review

This is the basic process for setting up a Firehose. Real-world implementations don't use or rely on the Dummy Blockchain application or its data.

Existing, current, and knowledgable node operators can take advantage of the pre-instrumented blockchain solutions provided by StreamingFast for their specific blockchain.

Blockchains that do not currently have a StreamingFast instrumented node client solution can create their own.

### Problems

#### Formatting Issues in YAML

Ensure there is a space between the colon after the extractor-node-path field and the quote that starts the path to the dchain binary on the target computer. Notice the missing space in the example directly below.

```shell
extractor-node-path:"/   
```

The following error will be displayed for an incorrectly formatted field in the YAML config file. Note, this is a YAML error, however, if it's a new topic this could potentially cause issues.

```shell-session
Error: unable to read config file "standard.yaml": reading json: yaml: line 10: did not find expected key   
```

#### Incorrect Example Blockchain Path

The following message will be displayed in the shell if the path to the example blockchain application is incorrect.

```shell
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

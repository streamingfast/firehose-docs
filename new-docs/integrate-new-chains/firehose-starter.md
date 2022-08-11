---
description: StreamingFast Firehose Starter setup documentation
---

# Firehose Starter

_<mark style="color:yellow;">**\[\[slm:] edits, and add links, subtitles, etc.]**</mark>_

### Firehose Starter Project&#x20;

#### Firehose Starter in Detail

The Firehose-ACME starter is a quick and low-resource way to evaluate and better understand a real, live-running Firehose.

The Firehose-ACME starter can even be run without a fully functioning blockchain node.

#### Firehose Starter & Faux Data

The starter consists of a basic templated Firehose and a faux data provision application called the Dummy Blockchain, or dchain.

Note, that the _Firehose-ACME_ starter _template is the main starting point for instrumenting new, unsupported blockchain nodes. Additional information is available in the_ [_Unsupported Blockchains_ ](new-blockchains.md)_documentation._

### Firehose Starter Setup

The following steps explain how to set up the Firehose-ACME starter with the Dummy Blockchain.

### Step 1. Create Firehose directory

Find a location on the target computer to download and store the Firehose-ACME starter application's source code and related files.

Create a new directory in the chosen location and name it something like "SFFirehose."

Open a new Terminal window. Navigate to the destination on the target computer where the Firehose files will be stored.

```
cd /Users/<User Account>/Desktop/ 
// Just an example, choose a directory 
// on the target computer
```

Create the new directory and navigate into it.&#x20;

The pwd command will print the full path to the new directory to the Terminal. This will be the working directory for the remaining steps in the installation process.

```
mkdir SFFirehose; cd SFFirehose; pwd
```

### Step 2. Clone the Firehose-ACME repo

Next, clone the Firehose-ACME starter project into the SFFirehose directory created in step one.

```
git clone git@github.com:streamingfast/firehose-acme
```

### Step 3. Install Firehose-ACME

Run the installation process for the Firehose-ACME starter.

```
go install -v ./cmd/fireacme
```

The installation process copies the fireacme binary file into the computer's default Go binary directory.

The standard default Go binary directory is `~/go/bin`.&#x20;

The GOPATH can be checked by issuing the echo command followed by the system variable preceded by a dollar sign.

```
echo $GOPATH
```

To ensure the Firehose-ACME starter binary is executable on the command line through the shell run the binary and pass the version flag.&#x20;

```
fireacme --version
```

If everything has been set up correctly the version will be printed to the Terminal window.

```
fireacme version dev (Built 2022-08-05T15:36:44-07:00) 
```

_Ensure the Firehose-ACME path is in the system's PATH before continuing._

### Step 4. Set up the Dummy Blockchain application

Follow the installation instructions located on the example blockchain's official Git repository.

[https://github.com/streamingfast/dummy-blockchain](https://github.com/streamingfast/dummy-blockchain)

The Dummy Blockchain can be set up anywhere on the target computer. Make a note of the full path where the Dummy Blockchain is located. The path is needed in the following steps.

The Dummy Blockchain should be started and allowed to run for at least a few minutes. This will enable the application enough time and processing facilities to generate faux blockchain data for Firehose to consume in the following steps.

### Step 5. Test the Firehose-ACME starter

Using a Terminal window navigate to the directory that Firehose was downloaded and set up within. The path will look something similar to the following.

```
/Users//Desktop/<User Account>/SFFirehose/
```

Next, navigate into the directory named "standard", inside of the directory named "devel", under the main firehose-acme directory.

```
cd /Users//Desktop/<User Account>/SFFirehose/standard/devel
```

Open the Firehose-ACME starter standard.yaml configuration file to update the path to the Dummy Blockchain.

The full path into the dchain directory must be used. The path needs to be in quotes.

Example path:

```
extractor-node-path: "/Users/<User Account>/Desktop/SFFireshose/dummy-blockchain/dchain"
```

Ensure the file has been saved with the updated path information and then return to the Terminal window.

Note, for real-world Firehose setups, the path that points at the Dummy Blockchain would typically be directed at an actual blockchain node that has been instrumented for Firehose.

### Step 6. Start Firehose

The shell script that starts the Firehose-ACME starter is located inside the devel/standard directory. The Terminal's shell session should still be using this directory.

Issue the following command in the Terminal window to start the Firehose-ACME starter.

```
./start.sh
```

To stop the Firehose-ACME starter at any time press down on the Control key and then press the C key. This will send an interrupt to the application to exit and discontinue data processing.

If all of the configuration changes were made correctly, all system paths have been set correctly and the Dummy Blockchain was installed and set up correctly something similar to the following will be printed to the Terminal window.

```
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

If the output seen in the target computer's Terminal looks resembles the sample above the Firehose-ACME starter has been successfully set up and is functional. Congratulations!&#x20;

### Conclusion

This is the basic process for setting up a Firehose. Real-world implementations don't use or rely on the Dummy Blockchain application or its data.

The next steps will be determined by the end goals of any Firehose user. Existing, current, and knowledgable node operators can take advantage of the pre-instrumented blockchain solutions provided by StreamingFast for their specific blockchain.

### Problems

#### Formatting Issues in YAML

Ensure there is a space between the colon after the extractor-node-path field and the quote that starts the path to the dchain binary on the target computer. Notice the missing space in the example directly below.

```
extractor-node-path:"/   
```

The following error will be displayed for an incorrectly formatted field in the YAML config file. Note, this is a YAML error, however, if it's a new topic this could potentially cause issues.

```
Error: unable to read config file "standard.yaml": reading json: yaml: line 10: did not find expected key   
```

#### Incorrect Example Blockchain Path

The following message will be displayed in the shell if the path to the example blockchain application is incorrect.

```
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

---
description: StreamingFast Firehose new blockchains
---

# New Blockchains

### Working with New Blockchains

#### Firehose & New Blockchains in Detail

Firehose was specifically designed to work with multiple blockchains beyond the existing implementations.

The [Firehose-ACME template's](firehose-starter.md) codebase is the starting point for working with blockchains that do not have a pre-existing StreamingFast instrumented node client solution.

The process of instrumenting a node is mandatory for blockchains without existing StreamingFast instrumentation support.

#### Detailed Design

Integrating new blockchains is an intricate process. Attention to detail is paramount during node instrumentation and while creating Protocol Buffer schemas.

### Firehose-ACME Template

#### Template for Creating New Chain Integrations

StreamingFast provides the Firehose-ACME template repository to stand as a starting point to create the required chain-specific code.

#### Search & Replace

The first step in the process is to conduct a global search and replace of the template's references to "_ACME_" to reflect the new blockchain's name. _Note, three exact reference types need to be updated, acme, Acme and ACME._

#### Rename Files

Follow the steps below to conduct the search and replace tasks and rename the necessary files.

### Step 1. Create Main Integration Directory

#### Custom Integration Main Directory

Select a location on the target computer for all Firehose files including the data that will be extracted and stored, and all other integration artifacts. The name is flexible however this directory is an important location and will be frequented often during integration and operation of Firehose. _This directory is the home directory of the custom integration being created._

```shell-session
mkdir /Users/<User Account>/Desktop/custom-firehose-integration
```

### Step 2. Clone Firehose-ACME

#### Establishing the New Integration Codebase

Using a terminal, navigate into the directory created in the previous step. Issue the following command to complete the cloning process.

_Note, Using a sensible name for the new project that the Firehose-ACME template is being cloned into is imperative._&#x20;

Replace the reference to "_\<newchainname>_" with the name of the new chain being integrated.

```shell-session
git clone git@github.com:streamingfast/firehose-acme.git firehose-<newchainname>
```

#### Naviate Into Cloned Directory

Using a terminal, navigate into the directory by cloning the Firehose-ACME template repository.

```shell-session
cd firehose-<newchainname>
```

#### Remove Git History

Next, remove the `.git` directory to erradicate the previous history associated with the Firehose-ACME repository. Note, the reference to "_\<newchainname>_", seen in the example, needs to reflect the name of the new blockchain being integrated.

```
cd firehose-<newchainname>
rm -rf .git
git init
```

#### Initial Repo Commit

Following best practice for development, this is a good point to make an initial commit to Git. The initial commit stands as a clean point in time the repository can be reverted to if need be. Again, update the reference to "_\<chain>_" to reflect the name of the new blockchain being integrated.

```
cd firehose-<newchainname>
git add -A .
git commit -m "Initial commit"
```

### Step 3. Update ACME References

Perform a _case-sensitive_ search and replace for the following references to ACME.

* acme -> \<newchainname>
* Acme -> \<Newchainname>
* ACME -> \<NEWCHAINNAME>

> Don't forget to update all variants of "_\<chain>_" to the name of the new chain being integrated. For example, if the chain's name was "aptos" the updates will be "aptos", "Aptos" and "APTOS", respectively.

### Step 4. Rename Project Files

In addition to the previous global search and replace tasks, a handful of files also need to be updated to reflect the name of the new chain. The following example shows the name being update to "_aptos_" for reference purposes.

```
git mv ./devel/fireacme ./devel/fireaptos
git mv ./cmd/fireacme ./cmd/fireaptos
git mv ./tools/fireacme/scripts/acme-is-running ./tools/fireacme/scripts/aptos-is-running
git mv ./tools/fireacme/scripts/acme-rpc-head-block ./tools/fireacme/scripts/aptos-rpc-head-block
git mv ./tools/fireacme/scripts/acme-resume ./tools/fireacme/scripts/aptos-resume
git mv ./tools/fireacme/scripts/acme-command ./tools/fireacme/scripts/aptos-command
git mv ./tools/fireacme/scripts/acme-debug-deep-mind-30s ./tools/fireacme/scripts/aptos-debug-deep-mind-30s
git mv ./tools/fireacme/scripts/acme-maintenance ./tools/fireacme/scripts/aptos-maintenance
git mv ./tools/fireacme ./tools/fireaptos
git mv ./types/pb/sf/acme ./types/pb/sf/aptos
```

### Step 5. Regenerate Protocol Buffers

After updating the references to "ACME" the Protocol Buffers need to be regenerated. Issue the following command to the terminal window. _Note, the terminal session should be in the firehose-newchainname directory._

```
./types/pb/generate.sh
```

#### Protocol Buffer Requirements

Requirements for Protocol Buffer regeneration include `protoc`, `protoc-gen-go` and `protoc-gen-go-grpc`.

Installation instructions for `protoc` are available at the project official website.&#x20;

[https://grpc.io/docs/protoc-installation/](https://grpc.io/docs/protoc-installation/)

Install `protoc-gen-go` by issuing the following command to the terminal.

```
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.25.0
```

Install `protoc-gen-go-grpc` by issuing the following command to the terminal.

```
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1.0.
```

### Step 6. Test Changes&#x20;

#### Ensure Changes Complie Correctly

After completing all of the previous steps the base integration is ready for initial testing. Issue the following command to the terminal to test the changes made so far.

```
go test ./...
```

If all changes were made correctly the updated project should compile successfully.

### Step 7. Commit Working Code

Upon sucessful project compliation the updated code should be commited to the repository.&#x20;

```
git add -A .
git commit -m "Renamed Acme to <Newchainname>"
git add remote origin <url>
git push
```

### Step 8. Protobuf Data Modeling&#x20;

Designing the Google Protobuf Structures for your given blockchain is one of the most important steps in an integrators journey.&#x20;

Data structures need to represented as precisely as possible.&#x20;

Careful design and consideration taken while creating the Protocol Buffer will aid with the following integration tasks.

Additional information ia available in the [StreamingFast Ethereum ProtoBuff structure implementation](https://github.com/streamingfast/sf-ethereum/blob/develop/proto/sf/ethereum/type/v1/type.proto).

#### &#x20;Integrate the target blockchain&#x20;

Modify `devel/standard/standard.yaml` and change the `start.flags.mindreader-node-path` flag to point to your blockchain node's binary.&#x20;

Modify `devel/standard/start.sh` to

Run it with:&#x20;

### Step 9. Define types

Go to the `proto` directory, and modify `sf/acme/type/v1/type.proto` to match your chain's types. More details in specs for chain's protobuf model definitions

### Step 10. Modify the Ingestor's `Read()`

Inside `codec`, is a file called `reader.go`. This file is the boundary between your process and the firehose's ingestion process.

Read the source of the `ConsoleReader` and make sure you understand how it works. This will be the bulk of your integration work.

Do X, Y, Z

### Step 11. Make sure data is produced

As you iterate, check that files are produced under `xyz` directory.

### Step 12. Rename everything

Pick two names, the long form and short form for your chain, following the naming conventions.

For example:

* `arweave` and `arw`

Then finalize the rename:

* Rename `cmd/fireacme` -> `cmd/firearw` (short form)
* Search and replace `fireacme` => `firearw` (short form)
* Do massive search and replace from: `acme` => `arweave` (long form)


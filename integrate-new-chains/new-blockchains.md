---
description: StreamingFast Firehose new blockchains
---

# New Blockchains

### Intro

Firehose was specifically designed to work with multiple blockchains beyond the existing implementations.

[Firehose-ACME](firehose-starter.md) is the starting point for working with blockchains that do not have a pre-existing StreamingFast instrumented node client solution.

The process of instrumenting a node is mandatory for blockchains without existing StreamingFast instrumentation support.

Integrating new blockchains is an intricate process. Attention to detail is paramount during node instrumentation and while creating Protocol Buffer schemas.

### Integration Directory

Select a location on the target computer for all Firehose files including the data that will be extracted and stored, and all other integration artifacts.&#x20;

The name is flexible however this directory is an important location and will be frequented often during the integration and operation of Firehose.&#x20;

This directory is the home directory of the custom integration being created.

### Firehose-ACME

StreamingFast provides the Firehose-ACME repository to serve as a starting point to create the required chain-specific code and files. To use Firehose-ACME as starting point many aspects of the project and code need to be renamed. __ Three exact reference types need to be updated, acme, Acme, and ACME.

The new Firehose setup will replace "_\<newchainname>_" with the name of the new chain being integrated.

Firehose-ACME is available through GitHub and can be obtained through cloning the project.

```shell-session
git clone git@github.com:streamingfast/firehose-acme.git firehose-<newchainname>
```

To eradicate the previous history associated with the Firehose-ACME repository remove the `.git` directory.

```
cd firehose-<newchainname>
rm -rf .git
git init
```

The first commit of the project will serve as a clean point in time the repository can be reverted to if need be.&#x20;

```
cd firehose-<newchainname>
git add -A .
git commit -m "Initial commit"
```

### ACME References

Three references to "ACME" exist within Firehose-ACME that need to be updated to reflect the new chain name. _Note, the capitalization of letters, or casing, is different for all three versions of "ACME."_

* acme -> \<newchainname>
* Acme -> \<Newchainname>
* ACME -> \<NEWCHAINNAME>

> Don't forget to update all variants of "_\<chain>_" to the name of the new chain being integrated. For example, if the chain's name was "aptos" the updates will be "aptos", "Aptos" and "APTOS", respectively.

### Project File Naming

A handful of files need to be updated to reflect the name of the new chain. The following example shows the name being updated to "_aptos_".

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

### Protocol Buffer Regeneration

After updating the references to "ACME" the Protocol Buffers need to be regenerated. Use the `generate` shell script to make the updates.&#x20;

```
./types/pb/generate.sh
```

### Running Tests&#x20;

After completing all of the previous steps the base integration is ready for initial testing.&#x20;

```
go test ./...
```

If all changes were made correctly the updated project should compile successfully.

### Protobuf Data Modeling&#x20;

Designing the protobuf structures for your given blockchain is one of the most important steps in an integrator's journey. It's imperative that the data structures in the protobuf's of the custom integration are represented as precisely as possible.&#x20;

The success of the integration will be proportionate to the amount of time spent on the design and implementation phase of the protobuf definitions.

Additional information is available in the [StreamingFast Ethereum protobuf implementation](https://github.com/streamingfast/firehose-ethereum/blob/develop/proto/sf/ethereum/type/v2/type.proto).

&#x20;To integrate the target blockchain modify `devel/standard/standard.yaml` and change the `start.flags.mindreader-node-path` flag to point to the custom integration's blockchain node binary.&#x20;

#### Type Definitions

The proto file `sf/acme/type/v1/type.proto` needs to be updated to match the target chain's types.&#x20;

### Reader

`reader.go` is the boundary between the custom integration process and the Firehose ingestion process.

[Read the source](https://github.com/streamingfast/firehose-acme/blob/master/nodemanager/codec/consolereader.go) of the `ConsoleReader` to gain a better understanding of how it works. The majority of the customization work will be conducted in this file.

Each blockchain has specific design and implementation details. There isn't a single standard or language that blockchains are written in or follow. For these reasons, it's virtually impossible to provide instructions for the instrumentation steps involved with each blockchain in the world.

Studying the StreamingFast Ethereum and other implementations and instrumentations should serve as a foundation for other custom integrations. _Ensure the custom integration has set aside a good amount of time to plan and execute the steps and tasks involved for researching and instrumenting the blockchain being targeted._&#x20;

### Data Production

As the integration progresses ensure that files are being produced under the appropriate Firehose-specific data directory.

### Renaming

Choose two names, a long-form and a short form for the custom integration following the naming conventions outlined below.

For example:

* `arweave` and `arw`

Then finalize the rename:

* Rename `cmd/fireacme` -> `cmd/firearw` (short form)
* Search and replace `fireacme` => `firearw` (short form)
* Conduct a global search and replace from: `acme` => `arweave` (long form)


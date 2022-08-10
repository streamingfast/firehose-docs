---
description: StreamingFast Firehose node instrumentation documentation
---

# New Blockchains

Firehose was designed to work with multiple blockchains beyond the existing implementations.

The process of instrumenting a node is mandatory for using an unsupported blockchain with Firehose.

The Firehose-ACME starter application's codebase is the starting point for working with unsupported blockchains.

A node that has been instrumented producing data is consumed by Firehose is also required.&#x20;

Close attention to detail is crucial when instrumenting nodes with new blockchains and working with custom Protocol Buffer schemas.

_<mark style="color:yellow;">**\[\[slm:] content has not been updated below this line.]**</mark>_

{% hint style="success" %}
_Input will be needed for the more detailed aspects of instrumenting new blockchains._&#x20;

_The content below was pulled from the github repo. It could be useful here but needs to be updated._
{% endhint %}

#### Using `firehose-acme` as a template

One of the main reason we provide a `firehose-acme` repository is to act as a template element that integrators can use to bootstrap creating the required Firehose chain specific code.

We purposely used `Acme` (and also `acme` and `ACME`) throughout this repository so that integrators can simply copy everything and perform a global search/replace of this word and use their chain name instead.

As well as this, there is a few files that requires a renaming. Would will find below the instructions to properly make the search/replace as well as the list of files that should be renamed.

#### Cloning

First step is to clone again `firehose-acme` this time to a dedicated repository that will be the one of your chain:

```
git clone git@github.com:streamingfast/firehose-acme.git firehose-<chain>
```

> Don't forget to change `<chain>` by the name of your exact chain like `aptos` so it would became `firehose-aptos`

Then we are going to remove the `.git` folder to start fresh:

```
cd firehose-<chain>
rm -rf .git
git init
```

While not required, I suggest to create an initial commit so it's easier to revert back if you make a mistake or delete a wrong file:

```
cd firehose-<chain>
git add -A .
git commit -m "Initial commit"
```

#### Renaming

Perform a **case-sensitive** search/replace for the following terms:

* `acme` -> `<chain>`
* `Acme` -> `<Chain>`
* `ACME` -> `<CHAIN>`

> Don't forget to change `<chain>` (and their variants) by the name of your exact chain like `aptos` so it would became `aptos`, `Aptos` and `APTOS` respectively.

#### Files

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

#### Re-generate Protobuf

Once you have performed the renamed of all 3 terms above and file renames, you should re-generate the Protobuf code:

```
cd firehose-<chain>
./types/pb/generate.sh
```

> You will require `protoc`, `protoc-gen-go` and `protoc-gen-go-grpc`. The former can be installed following [https://grpc.io/docs/protoc-installation/](https://grpc.io/docs/protoc-installation/), the last two can be installed respectively with `go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.25.0` and `go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1.0`.

#### Testing

Once everything is done, normally tests should be all good and everything should compile properly:

```
go test ./...
```

#### Commit

If everything is fine at that point, you are ready to commit everything and push

```
git add -A .
git commit -m "Renamed Acme to <Chain>"
git add remote origin <url>
git push
```

#### Data Modeling&#x20;

Designing the Google Protobuf Structures for your given blockchain is one of the most important steps in an integrators journey. The data structures needs to represent as precisely as possible the on chain data and concepts. By carefully crafting the Protobuf structure, the next steps will be a lot simpler. The data model need.

As a reference, here is Ethereum's Protobuf Structure: https://github.com/streamingfast/proto-ethereum/blob/develop/sf/ethereum/codec/v1/codec.proto&#x20;

_--- DEV NOTE ---_

_Double-check everything below to make sure it's correct and belongs here. There's more than likely overlap with the information above._

_--- /DEV NOTE ---_

#### Integrate the target blockchain&#x20;

Modify `devel/standard/standard.yaml` and change the `start.flags.mindreader-node-path` flag to point to your blockchain node's binary. Learn more about those parameters in the \[Operator's manual]\(\{{#< ref "/operate/running-the-node" >#\}}).

Modify `devel/standard/start.sh` to

Run it with:&#x20;

_--- DEV NOTE ---_

_Run it with what?_&#x20;

_--- /DEV NOTE ---_

#### Define types

Go to the `proto` directory, and modify `sf/acme/type/v1/type.proto` to match your chain's types. More details in [specs for chain's protobuf model definitions](../integrate/protobuf-defs/)

#### Modify the Ingestor's `Read()`

Inside `codec`, is a file called `reader.go`. This file is the boundary between your process and the firehose's ingestion process.

Read the source of the `ConsoleReader` and make sure you understand how it works. This will be the bulk of your integration work.

Do X, Y, Z

_--- DEV NOTE ---_

_What does this mean? "Do X, Y, Z"_

_--- /DEV NOTE ---_

#### Make sure data is produced

As you iterate, check that files are produced under `xyz` directory.

#### Rename everything

Pick two names, the long form and short form for your chain, following the [naming conventions](../integrate/names/).

For example:

* `arweave` and `arw`

Then finalize the rename:

* Rename `cmd/fireacme` -> `cmd/firearw` (short form)
* Search and replace `fireacme` => `firearw` (short form)
* Do massive search and replace from: `acme` => `arweave` (long form)


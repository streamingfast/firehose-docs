---
description: StreamingFast Firehose naming conventions
---

# Naming Conventions

## Firehose Naming Conventions

### Naming Conventions Intro

Each Firehose setup has unique naming conventions depending on versioning and the blockchain being targeted.

{% hint style="info" %}
_Note: This page serves as a resource to provide a unified experience for developers working between the Firehose versions._
{% endhint %}

### Short & Long Form Naming

Each Firehose setup uses two forms of naming. The naming is taken from the target blockchain's protocol name. The two forms establish a _long_ and a _short_ form of the protocol name.

The short form will be the shortest abbreviation of the chain name possible. For Ethereum, the long form would be `ethereum` and the short form would be `eth`.

{% hint style="warning" %}
_Important: These naming forms will be referenced throughout the Firehose naming conventions documentation._
{% endhint %}

## Firehose Instrumentation Naming

### Instrumentation Naming in Detail

For line-based Firehose instrumentations, each line of output should start with the word `FIRE` followed by a simple word defining what data to expect on each line.

### Libraries

Code used for instrumentation within the native node should be bundled together using `firehose` as the name of the module/crate/package is preferable.

{% hint style="warning" %}
**Important**: _The top-level flag  `--firehose-enabled` can be used for quickly dumping massive quantities of data to standard output from Firehose._
{% endhint %}

## Chain-specific Binary Changes

### Chain-specific Binary Changes Intro

Replace `acme` with the chain you are instrumenting for the following items.

In a sample scenario instrumenting the Tezos blockchain acme would be replaced by the two forms of Tezos; something similar to `tezos` and `tez`.

### Repository Name - `firehose-acme`

If the target blockchain were Tezos the name would be `firehose-tezos`.

### Binary Name -`fireeth`

The binary name will be the first half of the Firehose product name "fire" combined with the short form of the target blockchain. If the target blockchain were Tezos, the name of the binary would be something similar to `firetez`.

### Protocol Buffers Schema

The top-level Block protobuf definition convention for a new chain is `sf.[chain].type.v1.Block.`\
``\
``For Tezos it would be `sf.tezos.type.v1.Block`

### Directory Layouts

_**Proto Directory -**_ `/proto`

The proto directory contains properly namespaced protobuf definitions for the target chain. \
\
For example  `proto/sf/acme/type/v1/type.proto` as the first, and often only, file.\
\
For Tezos it would be `proto/sf/tezos/type/v1/type.proto`\


_**Types Directory -**_ `/types`

The types directory contains rendered protobuf types and some helpers. \
\
For example:

`/types/pb/sf/acme/type/v1;pbacme`, using the _short form_ package name prefixed with `pb`.\
\
For Tezos it would be something similar to:\
`/types/pb/sf/acme/type/v1;pbtezos`\

`/types/go.mod`: to be able to import `github.com/streamingfast/firehose-acme/types` and pull only a limited number of dependencies.

_**Codec Directory -**_ `/codec`

The `codec` directory contains all of the coding and decoding methods used to manipulate the stream of data coming from the Firehose-enabled Blockchain Node. _Note,_ t_his library is concerned only with the data wrangling, and not the management of nodes._

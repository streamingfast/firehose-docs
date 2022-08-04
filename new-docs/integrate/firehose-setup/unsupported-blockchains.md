---
description: StreamingFast Firehose node instrumentation documentation
---

# Unsupported Blockchains

#### Node Instrumentation

Instrumenting a node is the process of applying specialized code to the core of the codebase for the given node.&#x20;

StreamingFast provides the instrumented code for Ethereum, NEAR, Solana, and Cosmos nodes.

\--- DEV NOTE ---

Does it make sense to show the reader the integration piece first or the node instrumentation? Isn't an instrumented node required for integration? For instance, the path to the node binary is required.

A potential, very rough outline could be:

* Set up hardware/server/node&#x20;
* Download SF chain-specific node code&#x20;
* Update SF code and compile&#x20;
* Start up, run, and test node hardware with SF code&#x20;
* Protocol Buffer updates and compilation&#x20;
* Update config files
* Probably some other things I don't know about yet

Input will be needed for the more detailed aspects of instrumenting new blockchains. Could we call that something like Instrumentation Design and make a separate page?

\--- /DEV NOTE ---

Firehose was designed to work with multiple blockchains beyond the existing implementations.

\--- DEV NOTE ---

The content below was pulled from the github repo. It needs to be updated.

\--- /DEV NOTE ---

#### Data Modeling&#x20;

Designing the Google Protobuf Structures for your given blockchain is one of the most important steps in an integrators journey. The data structures needs to represent as precisely as possible the on chain data and concepts. By carefully crafting the Protobuf structure, the next steps will be a lot simpler. The data model need.

As a reference, here is Ethereum's Protobuf Structure: https://github.com/streamingfast/proto-ethereum/blob/develop/sf/ethereum/codec/v1/codec.proto&#x20;


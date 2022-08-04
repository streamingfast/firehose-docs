---
description: StreamingFast Firehose node instrumentation documentation
---

# Firehose & Unsupported Blockchains

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

Firehose was designed to work with multiple blockchains beyond the existing implementations.&#x20;


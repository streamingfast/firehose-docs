---
description: StreamingFast Firehose setup documentation
---

# Firehose Setup

Setting up Firehose differs depending on the specific needs of your target application or infrastructure. The three top-level paths to setup and integration are as follows.

#### Basic Firehose with Fake Data App

The Firehose system can be set up with an application designed to replicate an actual instrumented blockchain node. Use this path if you don't have the computational power or need to run a full blockchain node.

#### Use Firehose with a supported blockchain

Alternatively, Firehose can be set up for blockchains that have already been instrumented by StreamingFast. Use this path if the target blockchain has already been decided upon and an instrumented codebase is available. StreamingFast currently supports Ethereum, NEAR, Solana, and Cosmos.

#### Use Firehose with an unsupported blockchain

Unsupported blockchains can also be instrumented to feed the Firehose system with the necessary data. The Firehose-ACME demo application, custom Google Protocol Buffs, and instrumenting a node are the steps required for an unsupported blockchain.

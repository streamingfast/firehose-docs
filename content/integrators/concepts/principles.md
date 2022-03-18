---
weight: 20
title: Principles & Approach
---

This section discusses the design principles of the `Firehose` system, which were heavily inspired by the large-scale 
data-science machinery and processes previously developed by the StreamingFast team.

---

## Data science approach

Our North Star when designing the `Firehose` system consisted of a few ground truths:

- A flat file is better than a CPU/RAM-consuming process
- Data is messy, thus design for fast iteration of any data processes
- Separate concerns, isolate tasks, build small and robust components
- Always try to make tasks/processes parallelizable or shardable
- Define clear “data contracts” between tasks/processes (APIs, RPC query formats, data model definitions)
- Be excruciatingly precise when defining, referencing, or identifying concepts or data models. Leave no stone unturned.
- The only guarantee in data-science is that your data processes will change and evolve
- Migrating data is annoying, thus we must be thorough when considering:
    - File formats
    - Forward/backward-compatibility
    - Versioning
    - Performance

---

## Principles

### Extraction

We aim to find the shortest path from deterministic execution of blocks/transactions to a flat file.

- Develop laser-focused processes which are simple and robust (`Extractor`, `Merger`, `Relayer`, `Firehose`).
- Avoid coupling extraction with indexing itself (or other services).
- Ensure minimal impact on performance on the node executing the write operations of a given protocol.

---

### Data Completeness

We strive to Extract All The Data from the nodes, so we literally never need to go back and query them. 
We want our data to be complete, rich and verifiable.

When a transaction changes the balance for a given address from `100` to `200`, we store the storage key that was 
changed, as well as the previous and next values. This allows atomic updates in forward and backwards directions. 
It also allows for integrity checks to ensure no data is inconsistent. For example, the next mutation for that key 
should have a `previous_data` of `200` before it changes to something else, otherwise there’s a problem with 
the extraction mechanisms, and data quality will suffer.

Making the data complete means that the relationships between a transaction, its block’s schedule, its execution, 
its expiration, the events produced by its side effects, the call tree, and each call’s state transition and effects, 
are all known and accounted for. Figuring out relations after the fact can only be a source of pain, and of missed 
opportunities for potential data applications.

Some protocols offer JSON-RPC requests that allow querying either transaction status or state, but separately. 
A data process that is triggered by an Ethereum Log event might greatly benefit from checking if the parent contract 
of the call which produced the given log event is mine, or another one I know and trust.

Without easy access to this kind of data, developers inevitably work around the issue by emitting more events, 
increasing gas costs, only to circumvent the fact that enriched data is not readily available. Availability of such data 
even has effects on contract design, as a contract designer needs to think about how the stored data will be 
queried and consumed, often by his own application.

Richer external data processes allow devs to simplify contracts, and lower on-chain operation costs.

---

### Modeling With Extreme Care

The data model we use to ingest protocol data was modeled with extreme care. We discovered peculiarities of 
several protocols the hard way.

Some subtle interpretations of bits of data produced by a blockchain (e.g.: the meaning of a reverted call within the 
call stack of an Ethereum transaction) are such that, if enough information is not surfaced from the source, 
it can be impossible to interpret the data downstream. It is only when the model definitions (protobuf schemas) 
are complete and leave no bit of data in a node that we know that we can serve all needs: that no other solution is needed.

Conceptually, the data extracted from a node should be so complete that one could write a program that takes 
that data, and rebuilds a full archive node out of it, and is able to boot it.

---

### Use Files and Streams of Pure Data

As opposed to requests/responses model, we've chosen to use flat-files and data streams, to alleviate the challenges 
of querying pools of (often load-balanced) nodes in a master-to-master replication configuration.

This avoids massive consistency issues, their retries, the incurred latency, and greatly simplifies the consuming code.

Additionally, by adopting the flat-file and data stream abstractions we adhere to the Unix philosophy of 
writing programs that do one thing, do it well, and work together with other programs by handling streams of 
data as input and output.

---

### State Transition Hiearchy

We use state transitions scoped to a call, indexed within a transaction, indexed within a block.

Most blockchains “round up” state changes for all transactions into a block to facilitate consensus.
But the basic unit of execution remains a single smart contract execution 
(a single EVM call alone, where calling another contract means a second execution).

Precision in state is therefore lost for what happens mid-block, i.e. when the state of a contract changes in the 
middle of a transaction, in the middle of a block. If you want to know the balance at the *exact* point because 
it's required for some calculations (when you’re processing a log event for instance), you’re out of luck, because the 
node will provide the response that is true at the *end* of that block. It's thus impossible to know if there are 
other transactions after the one you are indexing that mutated the same state again. Querying a node will potentially 
throw you off, sometimes egregiously so.

Not all chains make consuming the actual state easy. For example, Solidity makes such an endeavor rather opaque, 
in the form of a `bytes32` => `bytes32` mapping, although there are ways to decode it. However, making that state 
usable creates tremendous opportunities for indexing.

Regarding versioning, compatibility and speed of file content, we found Google’s Protocol Buffers version 3 
to meet these last requirements, while striving for simplicity (e.g. as attested by their removal of optional/required 
fields in version 3).

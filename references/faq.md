---
description: StreamingFast Firehose frequently asked questions
---

# FAQ

## **What is Firehose?**

Firehose is an extremely efficient blockchain data indexing solution. Rich data is extracted from blockchain nodes and saved to simple flat files providing capture and processing speeds previously thought to be impossible. Firehose is primarily written in the Go programming language and takes full advantage of the parallel computing aspects available. Firehose makes paramount improvements in the speed and performance of data availability for any blockchain.

## **What is Firehose for?**

Firehose is available for developers creating decentralized applications, creating blockchain data-related solutions, or wanting to capture data from non-Firehose instrumented blockchains.

## **Do I need Substreams to use Firehose?**

Substreams and Firehose can be used together and typically are. The two complement each other in terms of the functionality they provide. Substreams uses blockchain data extracted and provided by Firehose. Firehose is responsible for extraction and provision and Substreams handles transforming and manipulating the data.

## **Does Firehose work with GraphQL?**

Firehose does not work directly with GraphQL. Subgraphs use GraphQL and Substreams can be used to populate subgraphs. Firehose extracts data from blockchain nodes and provides it to Substreams. Substreams sinks are responsible for bringing data to storage engines that can then be queries by different means.

## **Do subgraphs work with Firehose?**

In a way, the `graph-node` software, which powers Subgraphs, can connect directly to Firehose for Ethereum and Cosmos, and power the traditional Subgraphs there. Substreams can also be used directly to power Subgraphs, in which case Firehose is not directly involved (only as an implementation detail within Substreams).

## **Is Firehose made by The Graph?**

Firehose was created by StreamingFast working as a core developer with The Graph Foundation.

## **How do I get a Firehose authentication token?**

Authentication tokens are required to connect to the public Firehose endpoint provided by StreamingFast made available to developers for testing. Full instructions for obtaining a StreamingFast authentication token are available in the Substreams documentation.

[https://substreams.streamingfast.io/reference-and-specs/authentication](https://substreams.streamingfast.io/reference-and-specs/authentication)

## **My Firehose authentication token isn’t working, what do I do?**

The StreamingFast team is available in Discord to assist with problems related to obtaining or using authentication tokens.

[https://discord.gg/Ugc7KtkA](https://discord.gg/jZwqxJAvRs)

The authentication documentation also provides general instructions surrounding authentication tokens.

[https://substreams.streamingfast.io/reference-and-specs/authentication](https://substreams.streamingfast.io/reference-and-specs/authentication)

## **How much does Firehose cost?**

Firehose is made available as an open-source project, published under the Apache 2.0 license. As such, there are no direct fees involved. Running the Firehose and serving live blockchain data is a service that is offered by StreamingFast and other providers, with the goal of being served directly on The Graph network.

## **Does StreamingFast have a Discord?**

Yes! [Join the StreamingFast Discord today](https://discord.gg/jZwqxJAvRs)!

## **Is StreamingFast on Twitter?**

Yes! Find StreamingFast on their official Twitter account: [https://twitter.com/streamingfastio](https://twitter.com/streamingfastio)

## **Is StreamingFast on YouTube?**

Yes! Find StreamingFast on their official YouTube account: [https://www.youtube.com/c/streamingfast](https://www.youtube.com/c/streamingfast)

## **Who is dfuse?**

StreamingFast was originally called dfuse. The company changed the name and is in the process of phasing the old brand out.

## **Who is StreamingFast?**

[StreamingFast](https://streamingfast.io) is a protocol infrastructure company that provides a massively scalable architecture for streaming blockchain data. StreamingFast is one of the core developers working within [The Graph ](https://thegraph.com)ecosystem.

## What limits and SLAs are there for Firehose API keys?

The public StreamingFast endpoints are rate-limited and offer no guaranteed support or SLAs. Reach out to us for production usage keys.

## Is Firehose a production-ready service?

Yes, the Firehose has been battle tested for many years and is ready for prime time. Its sibling technology, [Substreams](http://localhost:5000/o/rLHDhggcHly9IAY4HRzU/s/erQrzMtqELZRGAdugCR2/), is also ready for prime time. Reach out to us for production usages.

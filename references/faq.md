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

Firehose does not work directly with GraphQL. Subgraphs use GraphQL and Substreams can be used with subgraphs. Firehose extracts data from blockchain nodes and provides it to Substreams.

## **Do subgraphs work with Firehose?**

Yes, Firehose provides data for subgraphs through the Graph Node and subgraphs. Substreams can also be used between Firehose and subgraphs to provide features and functionality that are not available using only subgraphs.

## **Is Firehose made by The Graph?**

Firehose was created by StreamingFast working as a core developer with The Graph Foundation.

## **Can I use Firehose for production deployments?**

Firehose is currently in development and the source code available is provided as a developer preview. Fully deployed Firehose setups are not recommended or supported at this time. The StreamingFast team is diligently working to bring production support to Firehose.

## **How do I get a Firehose authentication token?**

Authentication tokens are required to connect to the public Firehose endpoint provided by StreamingFast made available to developers for testing. Full instructions for obtaining a StreamingFast authentication token are available in the Substreams documentation.

[https://substreams.streamingfast.io/reference-and-specs/authentication](https://substreams.streamingfast.io/reference-and-specs/authentication)

## **My Firehose authentication token isn’t working, what do I do?**

The StreamingFast team is available in Discord to assist with problems related to obtaining or using authentication tokens.

[https://discord.gg/Ugc7KtkA](https://discord.gg/Ugc7KtkA)

The authentication documentation also provides general instructions surrounding authentication tokens.

[https://substreams.streamingfast.io/reference-and-specs/authentication](https://substreams.streamingfast.io/reference-and-specs/authentication)

## **How much does Firehose cost?**

Firehose is made available as an open-source project and there are no fees involved.

## **Does StreamingFast have a Discord?**

Yes! Join the StreamingFast Discord by clicking the link below.

[https://discord.gg/Ugc7KtkA](https://discord.gg/mYPcRAzeVN)

## **Is StreamingFast on Twitter?**

Yes! Find StreamingFast on their official Twitter account.

[https://twitter.com/streamingfastio](https://twitter.com/streamingfastio)

## **Is StreamingFast on YouTube?**

Yes! Find StreamingFast on their official YouTube account.

[https://www.youtube.com/c/streamingfast](https://www.youtube.com/c/streamingfast)

## **Who is dfuse?**

StreamingFast was originally called dfuse. The company changed the name and is in the process of phasing the old brand out.

## **Who is StreamingFast?**

StreamingFast is a protocol infrastructure company that provides a massively scalable architecture for streaming blockchain data. StreamingFast is one of the core developers working alongside The Graph Foundation.

## What limits and SLAs are there for Firehose API keys?

There are no rate limits for now and the endpoint should be used diligently. StreamingFast does not offer any SLAs, uptime support or uptime guarantees.

## Is Firehose a production ready service?

No, the public Firehose endpoint is not production ready at this point in time.

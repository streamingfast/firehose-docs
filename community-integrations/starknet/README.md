---
description: Firehose for Starknet
---

Setting up Firehose for Starknet shares a very similar process as setups for other chains. This section provides resources and instructions for successfully running it.

{% hint style="success" %}
**Tip**: If you want to have a quick peek at what a complete stack including `graph-node` for subgraph indexing looks like, look no further than the [`quickstart` tutorial](https://github.com/starknet-graph/quickstart), which features an end-to-end guide for getting everything up and running in under 5 minutes. This section here focuses on Firehose itself only.
{% endhint %}

The first step for running Starknet Firehose is to decide on the network to run on and the node to use. More details can be found on the [Networks and nodes](./networks-and-nodes.md) page.

From there, depending on whether you want to use Docker or not, there are 2 different routes:

- [**Local deployment with Docker**](./local-deployment-with-docker.md): Everything you need to run a successful Firehose is in multi-arch (AMD64 and ARM64) Docker images. Deploying with Docker is extremely easy.

- [**Local deployment without Docker**](./local-deployment-without-docker.md): This page guides you through setting up your machine for running the stack without using Docker.

  {% hint style="success" %}
  **Tip**: If you run into issues trying to run the stack without Docker, consider trying with the Docker approach to see if the issues persist, as the Docker setup has way fewer moving parts that can lead to failures. This could be helpful in diagnosing the issues even if you eventually still choose to deploy without Docker.
  {% endhint %}

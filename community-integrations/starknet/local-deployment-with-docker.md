---
description: Firehose Starknet local deployment with Docker
---

{% hint style="info" %}
**Note**: As an example, this page uses the `pathfinder` full node on the `starknet-mainnet` network. See the [Networks and nodes](./networks-and-nodes.md) page for details.

If you use a different node, command arguments will also need to be changed accordingly. Please refer to the node's own documentation for details.
{% endhint %}

# Overview

In this guide, you'll first be shown how to run the entire Firehose stack with a single `docker run` command. After validating that the stack is functioning, it will be demonstrated that different components in the stack can be easily broken down into separate services, glued together with [Docker Compose](https://docs.docker.com/compose/).

While this guide stops right there with all the services still running on the same machine, with the services separated, it would be rather trivial to further distribute them into different nodes with container orchestration tools (e.g. Kubernetes).

# Prerequisites

You need these to get started:

- [Docker](https://docs.docker.com/engine/install/)
- A JSON-RPC endpoint URL for the Ethereum Mainnet network

{% hint style="success" %}
**Tip**: An example [Infura](https://www.infura.io/) URL for Ethereum Mainnet looks like this: `https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY`
{% endhint %}

# Running everything with a single command

Before running the `docker` command, a new data directory should be created for persisting Firehose and node data. This can be any folder you want, here we create a `firestark-data` folder in the current working directory:

```console
mkdir ./firestark-data
```

Then, make 4 sub-directories inside it to store data from different components:

```console
mkdir ./firestark-data/node ./firestark-data/one-blocks ./firestark-data/merged-blocks ./firestark-data/forked-blocks
```

Now run the following `docker` command, where `YOUR_ETHEREUM_URL` must be replaced with your own URL for Ethereum Mainnet RPC, and `$(pwd)/firestark-data` should be replaced with your own directory if you decided to use a different one:

```console
docker run -it --rm --name firestark \
    -p "10015:10015" \
    -v "$(pwd)/firestark-data:/data" \
    --entrypoint firestark \
    starknet/firestark:0.2.1-pathfinder-0.10.2 \
    --config-file "" \
    start firehose reader-node merger relayer \
    --reader-node-path pathfinder \
    --reader-node-arguments "--data-directory /data/node --ethereum.url YOUR_ETHEREUM_URL" \
    --common-one-block-store-url "file:///data/one-blocks" \
    --common-merged-blocks-store-url "file:///data/merged-blocks" \
    --common-forked-blocks-store-url "file:///data/forked-blocks"
```

Once the container is up and running, the Firehose stack will start producing blocks. You can verify that it's working by running this `grpcurl` command:

```console
grpcurl -plaintext -d '{"start_block_num": 0}' localhost:10015 sf.firehose.v2.Stream.Blocks
```

{% hint style="success" %}
**Tip**: You need to have [`grpcurl`](https://github.com/fullstorydev/grpcurl) installed for this command to work.
{% endhint %}

The `grpcurl` command subscribes to the block stream, and you should be able to see new blocks being printed to the console as they become available.

To tear down the stack, simply stop and remove the container, and delete the `firestark-data` folder.

# Running separate services with Docker Compose

In the [section above](#running-everything-with-a-single-command), we're running all 4 components of a Firehose stack in a single container:

- reader-node
- merger
- relayer
- firehose

Firehose was designed to support [high availability deployment](https://xjonathanlei.gitbook.io/firehose/architecture/components/high-availability). In this section, we demonstrate how to run the components seperately with [Docker Compose](https://docs.docker.com/compose/).

{% hint style="success" %}
**Tip**: If you're following along from the last section, you might want to remove the data folder first to start afresh:

```console
rm -rf ./firestark-data
```

{% endhint %}

The first step, same as single-container deployment, is to create a new folder for persisting data:

```console
mkdir -p ./firestark-data/node ./firestark-data/one-blocks ./firestark-data/merged-blocks ./firestark-data/forked-blocks
```

Now, create a `docker-compose.yml` file in the current directory with the following content, where `YOUR_ETHEREUM_URL` must be replaced with your own URL for Ethereum Mainnet RPC:

```yaml
version: "3.8"
services:
  reader:
    image: "starknet/firestark:0.2.1-pathfinder-0.10.2"
    command:
      - "--config-file"
      - ""
      - "start"
      - "reader-node"
      - "--common-one-block-store-url"
      - "file:///data/one-blocks"
      - "--reader-node-path"
      - "pathfinder"
      - "--reader-node-arguments"
      - "--data-directory /data/node --ethereum.url YOUR_ETHEREUM_URL"
    volumes:
      - "./firestark-data:/data"

  merger:
    image: "starknet/firestark:0.2.1"
    command:
      - "--config-file"
      - ""
      - "start"
      - "merger"
      - "--common-one-block-store-url"
      - "file:///data/one-blocks"
      - "--common-merged-blocks-store-url"
      - "file:///data/merged-blocks"
      - "--common-forked-blocks-store-url"
      - "file:///data/forked-blocks"
    volumes:
      - "./firestark-data:/data"

  relayer:
    image: "starknet/firestark:0.2.1"
    command:
      - "--config-file"
      - ""
      - "start"
      - "relayer"
      - "--common-one-block-store-url"
      - "file:///data/one-blocks"
      - "--relayer-source"
      - "reader:10010"
    volumes:
      - "./firestark-data:/data"

  firehose:
    image: "starknet/firestark:0.2.1"
    command:
      - "--config-file"
      - ""
      - "start"
      - "firehose"
      - "--common-one-block-store-url"
      - "file:///data/one-blocks"
      - "--common-merged-blocks-store-url"
      - "file:///data/merged-blocks"
      - "--common-forked-blocks-store-url"
      - "file:///data/forked-blocks"
      - "--common-live-blocks-addr"
      - "relayer:10014"
    ports:
      - "10015:10015"
    volumes:
      - "./firestark-data:/data"
```

Once it's all set up, run this command in the current directory:

```console
docker compose up
```

Once the node starts synchronizing, you can validate it's working by using the same `grpcurl` command:

```console
grpcurl -plaintext -d '{"start_block_num": 0}' localhost:10015 sf.firehose.v2.Stream.Blocks
```

and you should see the blocks being streamed to the console.

# Further steps

Now the 4 different components have been seperated, yet it's not a high-availability deployment:

1. all the files are stored locally on the same drive;
2. only one copy is run for each component, and everything runs on the same machine.

For `1`, thanks to the support for object storage, the `file:` scheme can be swapped out with a highly available object storage system. And `2` can be achieved with a container orchestration system.

The detailed steps of adding high availability to this setup is out of scope for this guide, and are not elaborated here.

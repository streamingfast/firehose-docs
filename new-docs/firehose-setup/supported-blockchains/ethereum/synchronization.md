---
description: StreamingFast Firehose for Ethereum Synchronization documentation
---

# Synchronization

#### Sync eth-mainnet

Launch `sfeth` to start indexing the chain.

```bash
./sfeth -c eth-mainnet.yaml start
```

You should start seeing logs similar to this:

```bash
2022-03-19T10:28:26.666-0400 (sfeth) starting atomic level switcher {"listen_addr": "localhost:1065"}
2022-03-19T10:28:26.666-0400 (<n/a>) registering development exporters from environment variables
2022-03-19T10:28:26.666-0400 (sfeth) starting with config file 'eth-mainnet.yaml'
2022-03-19T10:28:26.666-0400 (sfeth) launching applications: mindreader-node
2022-03-19T10:28:26.666-0400 (mindreader) adding superviser shutdown to plugins {"plugin_name": "log plug func"}
2022-03-19T10:28:26.666-0400 (mindreader) registered log plugin {"plugin count": 1}
2022-03-19T10:28:26.666-0400 (mindreader) adding superviser shutdown to plugins {"plugin_name": "ToZapLogPlugin"}
2022-03-19T10:28:26.666-0400 (mindreader) registered log plugin {"plugin count": 2}
2022-03-19T10:28:26.666-0400 (mindreader) enforcing peering by dns {"peers": ["localhost:13041"]}
2022-03-19T10:28:26.666-0400 (mindreader) created geth superviser {"superviser": {"binary": "./geth", "arguments": ["--networkid=1", "--datadir=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/data", "--ipcpath=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/ipc", "--port=30305", "--http", "--http.api=eth,net,web3", "--http.port=8547", "--http.addr=0.0.0.0", "--http.vhosts=*", "--firehose-deep-mind"], "data_dir": "/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/data", "ipc_file_path": "/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/ipc", "last_block_seen": 0, "enode_str": ""}}
2022-03-19T10:28:26.666-0400 (mindreader) creating operator {"options": {"Bootstrapper":null,"EnableSupervisorMonitoring":true,"ShutdownDelay":0}}
2022-03-19T10:28:26.666-0400 (mindreader) parsing backup configs {"configs": [], "factory_count": 0}
2022-03-19T10:28:26.666-0400 (mindreader) backup config {"config": [], "backup_module_count": 0, "backup_schedule_count": 0}
2022-03-19T10:28:26.666-0400 (mindreader) creating new mindreader plugin
2022-03-19T10:28:26.666-0400 (mindreader) adding superviser shutdown to plugins {"plugin_name": "MindReaderPlugin"}
2022-03-19T10:28:26.666-0400 (mindreader) registered log plugin {"plugin count": 3}
2022-03-19T10:28:26.666-0400 (mindreader) adding superviser shutdown to plugins {"plugin_name": "TrxPoolLogPlugin"}
2022-03-19T10:28:26.666-0400 (mindreader) registered log plugin {"plugin count": 4}
2022-03-19T10:28:26.666-0400 (mindreader) launching nodeos mindreader {"config": {"ManagerAPIAddress":":13009","ConnectionWatchdog":false,"GRPCAddr":":13010"}}
2022-03-19T10:28:26.666-0400 (mindreader) retrieved hostname from os {"hostname": "0xACED"}
2022-03-19T10:28:26.666-0400 (mindreader) starting grpc listener {"listen_addr": ":13010"}
2022-03-19T10:28:27.668-0400 (mindreader) grpc server listener ready
2022-03-19T10:28:27.668-0400 (mindreader) launching metrics and readinessManager
2022-03-19T10:28:27.668-0400 (mindreader) launching operator
2022-03-19T10:28:27.668-0400 (mindreader) launching operator HTTP server {"http_listen_addr": ":13009"}
2022-03-19T10:28:27.668-0400 (mindreader) starting webserver {"http_addr": ":13009"}
2022-03-19T10:28:27.669-0400 (mindreader) operator ready to receive commands
2022-03-19T10:28:27.669-0400 (mindreader) received operator command {"command": "start", "params": null}
2022-03-19T10:28:27.669-0400 (mindreader) preparing for start
2022-03-19T10:28:27.669-0400 (mindreader) preparing to start chain
2022-03-19T10:28:27.669-0400 (mindreader) starting mindreader
2022-03-19T10:28:27.676-0400 (mindreader) creating new command instance and launch read loop {"binary": "./geth", "arguments": ["--networkid=1", "--datadir=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/data", "--ipcpath=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/ipc", "--port=30305", "--http", "--http.api=eth,net,web3", "--http.port=8547", "--http.addr=0.0.0.0", "--http.vhosts=*", "--firehose-deep-mind"]}
2022-03-19T10:28:27.676-0400 (mindreader) successfully start service
2022-03-19T10:28:27.676-0400 (mindreader) operator ready to receive commands
2022-03-19T10:28:27.676-0400 (mindreader) starting consume flow
2022-03-19T10:28:28.055-0400 (mindreader.geth) initializing deep mind
2022-03-19T10:28:28.055-0400 (mindreader.geth) deep mind initialized                    enabled=true sync_instrumentation_enabled=true mining_enabled=false block_progress_enabled=false compaction_disabled=false archive_blocks_to_keep=0
2022-03-19T10:28:28.057-0400 (mindreader.geth) maximum peer count                       ETH=50 LES=0 total=50
2022-03-19T10:28:28.058-0400 (mindreader.geth) set global gas cap                       cap=50,000,000
2022-03-19T10:28:28.058-0400 (mindreader.geth) allocated trie memory caches             clean=154.00MiB dirty=256.00MiB
2022-03-19T10:28:28.058-0400 (mindreader.geth) allocated cache and file handles         database=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/data/geth/chaindata cache=512.00MiB handles=5120
2022-03-19T10:28:28.395-0400 (mindreader.geth) opened ancient database                  database=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/data/geth/chaindata/ancient readonly=false
2022-03-19T10:28:28.395-0400 (mindreader.geth) writing default main-net genesis block
2022-03-19T10:28:28.610-0400 (mindreader.geth) persisted trie from memory database      nodes=12356 size=1.78MiB time=48.465792ms gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
2022-03-19T10:28:28.610-0400 (mindreader.geth) initialised chain configuration          config="{ChainID: 1 Homestead: 1150000 DAO: 1920000 DAOSupport: true EIP150: 2463000 EIP155: 2675000 EIP158: 2675000 Byzantium: 4370000 Constantinople: 7280000 Petersburg: 7280000 Istanbul: 9069000, Muir Glacier: 9200000, Berlin: 12244000, London: 12965000, Arrow Glacier: 13773000, MergeFork: <nil>, Engine: ethash}"
2022-03-19T10:28:28.610-0400 (mindreader.geth) disk storage enabled for ethash caches   dir=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/data/geth/ethash count=3
2022-03-19T10:28:28.610-0400 (mindreader.geth) disk storage enabled for ethash DAGs     dir=/Users/froch/Library/Ethash count=2
2022-03-19T10:28:28.610-0400 (mindreader.geth) initialising Ethereum protocol           network=1 dbversion=<nil>
2022-03-19T10:28:28.611-0400 (mindreader.geth) loaded most recent local header          number=0 hash=d4e567..cb8fa3 td=17,179,869,184 age=52y11mo2w
2022-03-19T10:28:28.611-0400 (mindreader.geth) loaded most recent local full block      number=0 hash=d4e567..cb8fa3 td=17,179,869,184 age=52y11mo2w
2022-03-19T10:28:28.611-0400 (mindreader.geth) loaded most recent local fast block      number=0 hash=d4e567..cb8fa3 td=17,179,869,184 age=52y11mo2w
2022-03-19T10:28:28.611-0400 (mindreader.geth) failed to load snapshot, regenerating    err="missing or corrupted snapshot"
2022-03-19T10:28:28.611-0400 (mindreader.geth) rebuilding state snapshot
2022-03-19T10:28:28.611-0400 (mindreader.geth) resuming state snapshot generation       root=d7f897..0f0544 accounts=0 slots=0 storage=0.00B elapsed="140.25µs"
2022-03-19T10:28:28.611-0400 (mindreader.geth) regenerated local transaction journal    transactions=0 accounts=0
2022-03-19T10:28:28.612-0400 (mindreader.geth) gasprice oracle is ignoring threshold set threshold=2
2022-03-19T10:28:28.612-0400 (mindreader.geth) error reading unclean shutdown markers   error="leveldb: not found"
2022-03-19T10:28:28.612-0400 (mindreader.geth) starting peer-to-peer node               instance=Geth/v1.10.16-dm-stable-21e9fa4c-20220215/darwin-arm64/go1.17.8
2022-03-19T10:28:28.748-0400 (mindreader.geth) generated state snapshot                 accounts=8893 slots=0 storage=409.64KiB elapsed=136.648ms
2022-03-19T10:28:28.771-0400 (mindreader.geth) new local node record                    seq=1,647,700,108,770 id=7d27815dfed825bd ip=127.0.0.1 udp=30305 tcp=30305
2022-03-19T10:28:28.771-0400 (mindreader.geth) started P2P networking                   self=enode://d4136ec7b136025f14760c49f7b51625c44a9cc9e47d24d175995a6db66e4d744fe1a80b5028b2e1c1723006caa25a856541edfd5dd29670868679ed862f1f83@127.0.0.1:30305
2022-03-19T10:28:28.772-0400 (mindreader.geth) iPC endpoint opened                      url=/Users/froch/Development/io.streamingfast/firehose-ethereum-mainnet/eth-data/mindreader/ipc
2022-03-19T10:28:28.772-0400 (mindreader.geth) hTTP server started                      endpoint=[::]:8547 prefix= cors= vhosts=*
2022-03-19T10:28:30.592-0400 (mindreader.geth) new local node record                    seq=1,647,700,108,771 id=7d27815dfed825bd ip=107.190.37.205 udp=30305 tcp=30305
2022-03-19T10:28:36.670-0400 (mindreader) got enode {"hostname": "localhost:13041", "enodes": []}
2022-03-19T10:28:38.957-0400 (mindreader.geth) looking for peers                        peercount=0 tried=11 static=0
2022-03-19T10:28:46.674-0400 (mindreader) got enode {"hostname": "localhost:13041", "enodes": []}
2022-03-19T10:28:49.623-0400 (mindreader.geth) looking for peers                        peercount=0 tried=27 static=0
2022-03-19T10:28:54.187-0400 (mindreader.geth) block synchronisation started
...
```

After a short delay, you should start to see the blocks syncing in:

```bash
...
2022-03-19T10:28:57.497-0400 (merger) downloading one block file {"canonical_name": "0000000038-20150730T153109.0-b624ded0-d3f13e32-1"}
2022-03-19T10:28:57.498-0400 (merger) downloading one block file {"canonical_name": "0000000039-20150730T153112.0-5c99c0f7-b624ded0-1"}
2022-03-19T10:28:57.499-0400 (merger) downloading one block file {"canonical_name": "0000000040-20150730T153113.0-a852d084-5c99c0f7-1"}
...
```

{% hint style="warning" %}
At any point in time you can stop the process with `Ctrl + C`.

The process will shutdown gracefully and on restart it will continue where it left off.
{% endhint %}

Once you have synced 10,000 blocks, you can run the following command in a separate terminal to introspect the block data

```bash
./sfeth tools print blocks --store ./eth-data/storage/merged-blocks 100000

Block #10000 (dc2d938) (prev: b9ecd2d): 0 transactions, 1 balance changes
Block #10001 (7e86236) (prev: dc2d938): 0 transactions, 1 balance changes
Block #10002 (d2be089) (prev: 7e86236): 0 transactions, 1 balance changes
Block #10003 (666b0b3) (prev: d2be089): 0 transactions, 2 balance changes
Block #10004 (c191297) (prev: 666b0b3): 0 transactions, 1 balance changes
Block #10005 (7cd875c) (prev: c191297): 0 transactions, 1 balance changes
Block #10006 (dffaa95) (prev: 7cd875c): 0 transactions, 2 balance changes
...
```

#### Overview and Explanation

The `mindreader-node` is a process that runs and manages the blockchain node `Geth`. It consumes the blockchain data that is extracted from our instrumented `Geth` node. The instrumented `Geth` node outputs individual block data.

The `mindreader-node` process will either write individual block data into separate files called one-block files, or merge 100 blocks data together and write into a file called a `100-blocks file`.

This behaviour is configurable with the `mindreader-node-merge-and-store-directly` flag. When running the `mindreader-node` process with `mindreader-node-merge-and-store-directly` flag enabled, we say the "mindreader is running in merged mode". When the flag is disabled, we will refer to the mindreader as running in its normal mode of operation.

In the scenario where the `mindreader-node` process stores one-block files, we can run a `merger` process on the side which would merge the one-block files into 100-block files. When we are syncing the chain we will run the `mindreader-node` process in merged mode.

When we are synced we will run the `mindreader-node` in its regular mode of operation (storing one-block files)

The one-block files and 100-block files will be stored in `data-dir/storage/merged-blocks` and `data-dir/storage/one-blocks` respectively. The naming convention of the file is the number of the first block in the file.

Finally, we have built tools that allow you to introspect the block files:

```bash
./sfeth tools print blocks --store ./eth-data/storage/merged-blocks 10000
```

```bash
./sfeth tools print one-block --store ./eth-data/storage/one-blocks 10000
```

#### Launch the Firehose

Let's pick up where we left off, assuming we're no longer syncing eth-mainnet:

```bash
./sfeth -c eth-mainnet.yaml start mindreader-node
```

The current state of affairs is that we have an `sfeth` running a `mindreader-node` process. The process is extracting and merging 100-bock data.

While still running the `mindreader-node` process in a separate terminal (still in the working directory), launch the firehose:

```bash
./sfeth -c eth-mainnet.yaml start relayer firehose
```

The `sfeth` command launches 2 processes, the `Relayer` and `Firehose`. Both processes work together to provide the `Firehose` data stream. Once the `Firehose` process is running, it will be listening on port `13042`.

At its core, the `Firehose` is a gRPC stream. We can list the available gRPC services with `grpcurl`

```bash
grpcurl -plaintext localhost:13042 list
```

We can start streaming blocks with the `sf.firehose.v1.Stream` Service:

{% code overflow="wrap" %}
```bash
grpcurl -plaintext -d '{"start_block_num": 10}' localhost:13042 sf.firehose.v1.Stream.Blocks
```
{% endcode %}

You should see block streaming. Like so

```json
{
  "block": {
    "@type": "type.googleapis.com/sf.ethereum.codec.v1.Block",
    "balanceChanges": [
      {
        "address": "KJIeTiydhPTA8MDOuZH0V1Gg/pM=",
        "oldValue": {
          "bytes": "M//VkvdcOeAA"
        },
        "newValue": {
          "bytes": "NEU5JHmhLeAA"
        },
        "reason": "REASON_REWARD_MINE_BLOCK"
      }
    ],
    "hash": "rWCqFYquYxvCh1Iy3w4OPNjtdRWloidwH+aAy7Cp6I8=",
    "header": {
      "parentHash": "2UDI+9iNUQ6fR13LTotFhgw9tYW3AP7gIjSNAIo/MWg=",
      "uncleHash": "HcxN6N7HXXqrhbVntszUGtMSRRuUinQT8KFC/UDUk0c=",
      "coi^Cnbase": "KJIeTiydhPTA8MDOuZH0V1Gg/pM=",
      "stateRoot": "RSVmg4SxOM9mawD5Z4isp+mRTPmb+gxfAmNu00UBEog=",
      "transactionsRoot": "VugfFxvMVab/g0XmksD4bltI4BuZbK3AAWIvteNjtCE=",
      "receiptRoot": "VugfFxvMVab/g0XmksD4bltI4BuZbK3AAWIvteNjtCE=",
      "logsBloom": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",
      "difficulty": {
        "bytes": "CDbKnao="
      },
      "number": "1488",
      "gasLimit": "5000",
      "timestamp": "2015-07-30T16:20:30Z",
      "extraData": "R2V0aC92MS4wLjAvbGludXgvZ28xLjQuMg==",
      "mixHash": "zMVn27pvcFYbAQsBJNFNjsQCIOV03Wv5s2z6QBuIV5c=",
      "nonce": "8306990282153570439",
      "hash": "rWCqFYquYxvCh1Iy3w4OPNjtdRWloidwH+aAy7Cp6I8="
    },
    "number": "1488",
    "size": "539",
    "ver": 1
  },
  "step": "STEP_NEW",
  "cursor": "CFAZVtrTEjPGpZJWNJE2h6WwLpcyB15nXQG0fhdB1Nr39XqUjMigA2AnOx_Yl6zy3he_HVr53orORypzp5RXudDvkr017yM_QXstxdzo87S8KqHyaANOebM0VeuMat_RXT_eZw3_frMD5tSzMqWPbkI1NsEgL2exiWwBotRdc6ESu3E0xD71c8aE0amR8oJA-LNxRbepkymgBzZ8fx0Maw=="
}
```

#### What's next

The target computer is now successfully streaming ETH block data from mainnet. Congratulations!

Full searchability and discoverability of Ethereum and ERC20 networks have now been attained. The underlying blockchain data can be sliced and diced in just about any way imaginable.

Don't forget that StreamingFast also provides pre-instrumented and ready-to-go solutions for several other blockchains.

#### System Requirements

The Firehose stack is extremely elastic, and supports handling networks of varied sizes and shapes. It is also heavy on data, so **make sure you have a good understanding** of the different data stores, artifacts, and databases required to run the Firehose stack.

The deployment efforts will be proportional to the size of history, and the density of the chain at hand.

#### Network shapes

This document outlines requirements for different shapes of networks

#### Persistent chains

In order to scale easily, you will want to decouple \[components]\(\{{< ref "/operate/concepts/components" >\}}) that run in a single process.

The storage requirements will vary depending on these metrics:

* **The length of history**: whether or not you are serving all the blocks through the firehose
* **Throughput in transactions and calls**: Calls on Ethereum are the smallest units of execution to produce meaningful data, transaction overhead becomes negligible once you have 2-3 calls in a transaction. A single ERC20 transfer generally has 1 call, 2 calls when there is a proxy contract involved. A Uniswap swap is usually composes of a few dozens of calls.

The CPU/RAM requirements will depend on these factors:

* **High Availability**: highly available deployments will require **2 times the resources** (or more) listed in the following examples, as a general rule.
* **Throughput of queries**: the Firehose stack is built for horizontal scalability, the more requests per second you want to fulfill, the larger the deployment, the more CPU/RAM you will need to allocate to your cluster.

These stats are from March 2022, but chains of similar density and similar age will behave similarly.

**Ethereum Mainnet**

`This section is incomplete.`

#### Problems

If you are on macOS you could see a warning saying the downloaded binaries are not signed, or the binaries could do nothing at all when run from the terminal.

To fix the problem, remove the quarantine attribute on the file using the following command against the binary:

```bash
xattr -d com.apple.quarantine sfeth
xattr -d com.apple.quarantine geth_macos
```

You'll only need to do this once.

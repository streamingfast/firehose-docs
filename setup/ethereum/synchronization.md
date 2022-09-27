---
description: StreamingFast Firehose Ethereum synchronization
---

# Synchronization

### Ethereum Synchronization

#### Sync in Detail

Synchronization is the process of:

* collecting data from other peer nodes on the network,&#x20;
* verifying node integrity through cryptography,&#x20;
* and building the working node's blockchain data store.&#x20;

### Ethereum Mainnet Synchronization

#### Start fireeth

The `fireeth` command is used to start Firehose and begin synchronization with the desired network. In this case, it's the Ethereum Mainnet.

```bash
./fireeth -c eth-mainnet.yaml start
```

The data being processed by the connected node will be displayed as processing occurs. The data los will be presented in the following format.

```shell-session
2022-03-19T10:28:26.666-0400 (fireeth) starting atomic level switcher {"listen_addr": "localhost:1065"}
2022-03-19T10:28:26.666-0400 (<n/a>) registering development exporters from environment variables
2022-03-19T10:28:26.666-0400 (fireeth) starting with config file 'eth-mainnet.yaml'
2022-03-19T10:28:26.666-0400 (fireeth) launching applications: mindreader-node
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

After a short delay, the blocks begin syncing.

```shell-session
...
2022-03-19T10:28:57.497-0400 (merger) downloading one block file {"canonical_name": "0000000038-20150730T153109.0-b624ded0-d3f13e32-1"}
2022-03-19T10:28:57.498-0400 (merger) downloading one block file {"canonical_name": "0000000039-20150730T153112.0-5c99c0f7-b624ded0-1"}
2022-03-19T10:28:57.499-0400 (merger) downloading one block file {"canonical_name": "0000000040-20150730T153113.0-a852d084-5c99c0f7-1"}
...
```

{% hint style="success" %}
_Tip: To terminate the Firehose processing and connection to the Ethereum network press the Control + C keys._

_The Firehose sync process will shut down gracefully and continue where it left off upon the next restart._
{% endhint %}

### Synchronization Processes

#### Data Extraction in Detail

The `mindreader-node` is a process that runs and manages the Geth blockchain node. The `mindreader-node` also consumes the blockchain data that is extracted from the instrumented Geth node and outputs individual block data.

The `mindreader-node` process will either write individual block data into separate files called one-block files, or merge one hundred blocks of data together creating a 100-blocks file.

#### Merged Mode

This behavior is configurable with the `mindreader-node-merge-and-store-directly` flag.&#x20;

When running the `mindreader-node` process with the `mindreader-node-merge-and-store-directly` flag enabled, the mindreader is running in merged mode. When the flag is disabled it's running in normal mode.

#### Block Mergers

In the scenario where the `mindreader-node` process stores one-block files the merger process can be run on the side. When the merger process is running in this fashion one-block files are merged into 100-block files.&#x20;

The `mindreader-node` process is run in merged mode during chain synchronization. After the synchronization process has completed the `mindreader-node` will store one-block files running in its regular mode of operation.

#### Block File Data Storage

The one-block files and 100-block files will be stored in the `data-dir/storage/merged-blocks` and `data-dir/storage/one-blocks` directories, respectively. The naming convention of the block files uses the number of the first block in the file.

### Data Introspection Tools

#### Data Introspection in Detail

The Firehose data introspection tools allow you to introspect one-blocks and merged blocks files.

Data inspection becomes possible through special sfeth tooling.&#x20;

The `tools print block` can be used to introspect the synchronized block data.

{% hint style="info" %}
_Note: Data inspection can be run after 10,000 blocks have been synced._
{% endhint %}

```shell-session
./fireeth tools print blocks --store ./eth-data/storage/merged-blocks 100000
```

Block data will be displayed in the following format.

```shell-session
...
Block #10000 (dc2d938) (prev: b9ecd2d): 0 transactions, 1 balance changes
Block #10001 (7e86236) (prev: dc2d938): 0 transactions, 1 balance changes
Block #10002 (d2be089) (prev: 7e86236): 0 transactions, 1 balance changes
Block #10003 (666b0b3) (prev: d2be089): 0 transactions, 2 balance changes
Block #10004 (c191297) (prev: 666b0b3): 0 transactions, 1 balance changes
Block #10005 (7cd875c) (prev: c191297): 0 transactions, 1 balance changes
Block #10006 (dffaa95) (prev: 7cd875c): 0 transactions, 2 balance changes
...
```

In addition, one-block files can be inspected using the `tools print one-block` command.

```shell-session
./fireeth tools print one-block --store ./eth-data/storage/one-blocks 0000000000
```

### Running Firehose

#### Data Analyzation & Streaming

After the Ethereum network has finished synchronization the data collected can be analyzed and streamed through the `mindreader` process.

```shell-session
./fireeth -c eth-mainnet.yaml start mindreader-node
```

Firehose, `fireeth`, is now running a `mindreader-node` process that is extracting and merging the 100-blocks of data at a time.

#### Firehose & Relayer

The `fireeth` command launches both the Relayer and Firehose.

The two processes work together to provide the Firehose data stream. The Firehose process is running and listening on port 13042.

```shell-session
./fireeth -c eth-mainnet.yaml start relayer firehose
```

The following message will be printed to the terminal window after launching Firehose.

```shell-session
2022-08-17T09:51:26.807-0700 (<n/a>) registering development exporters from environment variables
2022-08-17T09:51:26.807-0700 (fireeth) starting atomic level switcher {"listen_addr": "localhost:1065"}
2022-08-17T09:51:26.807-0700 (fireeth) ulimit max open files before adjustment {"current_value": 256}
2022-08-17T09:51:26.807-0700 (fireeth) ulimit max open files after adjustment {"current_value": 1000000}
2022-08-17T09:51:26.807-0700 (fireeth) sfeth binary started {"data_dir": "eth-data"}
2022-08-17T09:51:26.807-0700 (fireeth) starting with config file 'eth-mainnet.yaml'
2022-08-17T09:51:26.807-0700 (fireeth) launcher created
2022-08-17T09:51:26.807-0700 (fireeth) launching applications: firehose,relayer
2022-08-17T09:51:26.807-0700 (fireeth) creating application {"app": "firehose"}
2022-08-17T09:51:26.807-0700 (dmetrics) can't listen on the metrics endpoint
2022-08-17T09:51:26.807-0700 (fireeth) creating application {"app": "relayer"}
2022-08-17T09:51:26.808-0700 (fireeth) launching app {"app": "firehose"}
2022-08-17T09:51:26.808-0700 (fireeth) launching app {"app": "relayer"}
2022-08-17T09:51:26.808-0700 (fireeth) unable to start profiling server {"error": "listen tcp 127.0.0.1:6060: bind: address already in use", "listen_addr": "localhost:6060"}
2022-08-17T09:51:26.808-0700 (relayer) starting relayer {"sources_addr": [":13010"], "grpc_listen_addr": ":13011", "merger_addr": ":13012", "buffer_size": 300, "source_request_burst": 0, "max_source_latency": "10m0s", "min_start_offset": 120, "source_store_url": "file:///Users/seanmoore-mpb/Desktop/dfuse/Firehose-Setup/sf-firehose/eth-data/storage/merged-blocks"}
2022-08-17T09:51:26.808-0700 (fireeth) app status switching to warning {"app_id": "relayer"}
2022-08-17T09:51:26.808-0700 (firehose) running firehose {"config": {"BlockStoreURLs":["file:///Users/seanmoore-mpb/Desktop/dfuse/Firehose-Setup/sf-firehose/eth-data/storage/merged-blocks"],"IrreversibleBlocksIndexStoreURL":"","IrreversibleBlocksBundleSizes":[100000,10000,1000,100],"BlockStreamAddr":"","GRPCListenAddr":":13042","GRPCShutdownGracePeriod":1000000000,"RealtimeTolerance":120000000000}}
2022-08-17T09:51:26.808-0700 (fireeth) failed starting atomic level switcher {"error": "listen tcp 127.0.0.1:1065: bind: address already in use", "listen_addr": "localhost:1065"}
2022-08-17T09:51:26.808-0700 (dstore) sanitized base path {"original_base_path": "/Users/seanmoore-mpb/Desktop/dfuse/Firehose-Setup/sf-firehose/eth-data/storage/merged-blocks", "sanitized_base_path": "/Users/seanmoore-mpb/Desktop/dfuse/Firehose-Setup/sf-firehose/eth-data/storage/merged-blocks"}
2022-08-17T09:51:26.808-0700 (relayer) tcp listener created
2022-08-17T09:51:26.808-0700 (firehose) creating gRPC server {"live_support": false}
2022-08-17T09:51:26.808-0700 (dstore) sanitized base path {"original_base_path": "/Users/seanmoore-mpb/Desktop/dfuse/Firehose-Setup/sf-firehose/eth-data/storage/merged-blocks", "sanitized_base_path": "/Users/seanmoore-mpb/Desktop/dfuse/Firehose-Setup/sf-firehose/eth-data/storage/merged-blocks"}
2022-08-17T09:51:26.808-0700 (firehose) registering grpc services
2022-08-17T09:51:26.808-0700 (relayer) listening & serving grpc content {"grpc_listen_addr": ":13011"}
2022-08-17T09:51:26.808-0700 (firehose) firehose is now ready to accept request
2022-08-17T09:51:26.808-0700 (firehose) launching gRPC server {"listen_addr": ":13042"}
2022-08-17T09:51:26.808-0700 (firehose) serving gRPC (over HTTP router) (plain-text) {"listen_addr": ":13042"}
2022-08-17T09:51:26.810-0700 (relayer) source head latency too high {"sources_addr": [":13010"], "max_source_latency": "10m0s", "observed_latency": "61798h38m5.810142s"}
2022-08-17T09:51:27.312-0700 (relayer) source head latency too high {"sources_addr": [":13010"], "max_source_latency": "10m0s", "observed_latency": "61798h32m45.312764s"}
2022-08-17T09:51:27.808-0700 (fireeth) app status switching to running {"app_id": "relayer"}
2022-08-17T09:51:27.814-0700 (relayer) source head latency too high {"sources_addr": [":13010"], "max_source_latency": "10m0s", "observed_latency": "61798h29m12.814542s"}
...
```

At its core, Firehose is a gRPC stream. The available gRPC services can be displayed using `grpcurl`.&#x20;

{% hint style="info" %}
_Note: Installation instructions for grpcurl can be found in its_ [_official GitHub repository_](https://github.com/fullstorydev/grpcurl)_._
{% endhint %}

```bash
grpcurl -plaintext localhost:13042 list
```

The available gRPC services will print the following message to the terminal window.&#x20;

```shell-session
dfuse.bstream.v1.BlockStreamV2 
grpc.health.v1.Health 
grpc.reflection.v1alpha.ServerReflection 
sf.firehose.v1.Stream
```

Block streaming can be accomplished through the `sf.firehose.v1.Stream` service.&#x20;

The following command will begin the Firehose block streaming capability.

{% code overflow="wrap" %}
```shell-session
grpcurl -plaintext -d '{"start_block_num": 10}' localhost:13042 sf.firehose.v1.Stream.Blocks
```
{% endcode %}

Block data formed into a JSON representation resembling the following.

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
      "coinbase": "KJIeTiydhPTA8MDOuZH0V1Gg/pM=",
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

Full searchability and discoverability of Ethereum and ERC20 networks are now possible and the underlying blockchain data can be sliced and diced into a myriad of different solutions.

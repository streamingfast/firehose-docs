---
description: StreamingFast Firehose local deployment
---

# Local Deployment

## Ethereum Local Deployment

### Local Deployments Intro

Firehose setups that are created on a computer directly, as opposed to cloud-based setups, are considered "local deployments." Local deployments remain on the computer the operators have direct access to and management over.

Use the target computer's home directory to begin If a dedicated directory hasn't yet been identified or selected for the Firehose setup. Create a directory named “firehome”, or something similar that's reflective of the target setup being created.

## Firehose Configuration

### Config File in Detail

The configuration file for Firehose is stored in the main Firehose directory. The name of the file can be anything, however, using the name of the specific chain and version of Firehose is recommended for clarity.

The example below assumes a default Ethereum-based Firehose configuration is being created. For Binance use a filename similar to “bnb-firehose-config.yaml.”

Use the content provided below for the configuration file. The settings provided are ready-to-go for default Ethereum setups. Additional information is provided for the other Ethereum-compatible chains.

```bash
start:
  args:
  # Define Firehose components that will be used for this setup
  - merger
  - firehose
  - reader-node
  - relayer
  - combined-index-builder
  flags:
    # Prevent creation of file for logging (logs from previous sessions are not visible with this setting)
    log-to-file: false

    # Ethereum is the default chain, its id is 1. Update these flags for different chains such as Binance
    common-chain-id: "1"
    common-network-id: "1"
    # Update the reader-node-path to reference the geth binary for the chain and OS being targeted
    reader-node-path: ./geth_linux
    # Update the reader-code-arguments for the chain being targeted
    # Find specific values in the Firehose Ethereum Setup Documentation
    reader-node-arguments: "+--cache 8192 --maxpeers 100 --metrics --metrics.port 6061 --port=30303 --http.port=8545 --snapshot=true --txlookuplimit=1000"
    reader-node-log-to-zap: false
```

### Geth Binary Path

Firehose needs to know the location of the Geth binary. The configuration file contains a reader-node-path flag specifically designed to point Firehose to the Geth binary. The binary name will be the same for the different blockchains.

{% hint style="info" %}
_Note: the names of the Geth binaries differ depending on the target operating system. The differences are indicated by “\_linux” or “\_mac” in the binaries file name. Geth can be used directly on the command line without specifying a path if it has been installed globally on the system in the `user/local/bin` directory._
{% endhint %}

The updated flag in the configuration file for a macOS-based Firehose setup should reflect the following.

`reader-node-path: ./geth_mac`

### Unique chain and network ID

Each blockchain has a unique, numeric ID for the chain and network. Ethereum is the default blockchain implementation; the chain and network ID for it are the numeric value of 1. The numeric value is different for the other Ethereum-compatible chains.

Use the table below to locate the chain and network ID for the blockchain used in the Firehose setup. Both of the following flags need to be updated in the configuration file.

`common-chain-id`

`common-network-id`

| Blockchain | chainID | networkID |
| ---------- | ------- | --------- |
| Ethereum   | 1       | 1         |
| Binance    | 56      | 56        |
| Polygon    | 137     | 137       |
| Goerli     | 5       | 5         |

The numbers for the network and chain need to be enclosed in quotes. The update for Ethereum, for example, will read as the following. Note, the space between the colon and the starting quote.

`common-chain-id: “1”`

`common-network-id: “1”`

{% hint style="info" %}
**Note**_: The chain and network ID will be different for each of the different Ethereum-compatible chains._
{% endhint %}

### **Default Ethereum Firehose Setups**

Ethereum Mainnet is the default Geth version provided by StreamingFast. For Firehose setups targeting Ethereum Mainnet the genesis file and reader-node-arguments steps below are not applicable. Proceed to the step for running Firehose.

For Firehose setups targeting other Ethereum-compatible blockchains, such as Polygon, further action is required. Additional information is provided to explain the genesis file creation process and reader-node-arguments modifications.

Firehose setups targeting Goerli do not require genesis files however further modifications to the reader-node-arguments value are necessary. Additional information specific to Goerli setups is provided below.

### Download genesis JSON File

Firehose requires genesis block information to begin indexing for Ethereum-compatible blockchains. The genesis block information is provided in JSON files available for download. Find the JSON file relevant to the blockchain for the Firehose setup being created.

#### **Binance genesis JSON file**

Right-click and save the JSON file to the main Firehose directory created in the first step of the setup process.

[https://raw.githubusercontent.com/streamingfast/firehose-docs/master/configs/binance/genesis.json](https://raw.githubusercontent.com/streamingfast/firehose-docs/master/configs/binance/genesis.json)

Alternatively, the JSON file can be downloaded with curl using a terminal window. Issue the following command to the terminal, making sure the shell session is in the main Firehose setup directory.

```bash
curl https://raw.githubusercontent.com/streamingfast/firehose-docs/master/configs/binance/genesis.json --output genesis.json
```

#### **Polygon genesis JSON file**

Right-click and save the JSON file to the main Firehose directory created in the first step of the setup process.

[https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FVgApTPXzd7Z9BUUosaeF%2Fuploads%2FyshZBel3YKwFIOYYvyGf%2Fgenesis.json](https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FVgApTPXzd7Z9BUUosaeF%2Fuploads%2FyshZBel3YKwFIOYYvyGf%2Fgenesis.json)

Alternatively, the JSON file can be downloaded with curl using a terminal window. Issue the following command to the terminal, making sure the shell session is in the main Firehose setup directory.

```bash
curl https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FVgApTPXzd7Z9BUUosaeF%2Fuploads%2FyshZBel3YKwFIOYYvyGf%2Fgenesis.json --output genesis.json
```

### Add Genesis File Reference to Config File

After the JSON files have been downloaded the configuration file needs to be updated to inform Firehose where the file is located. Add the following flag to the configuration file.

`reader-node-bootstrap-data-url: ./genesis.json`

### Update reader-node-arguments in Config File

The reader-node-arguments flag provides Firehose with information it needs for startup. Use the flags provided below specific to the chain being targeted.

#### **Binance reader-node-arguments**

The reader-node-arguments flag for Binance need to be updated to reflect the following.

```bash
reader-node-arguments: "+--maxpeers 300 --cache 16368 --snapshot=false  --bootnodes=enode://1cc4534b14cfe351ab740a1418ab944a234ca2f702915eadb7e558a02010cb7c5a8c295a3b56bcefa7701c07752acd5539cb13df2aab8ae2d98934d712611443@52.71.43.172:30311,enode://28b1d16562dac280dacaaf45d54516b85bc6c994252a9825c5cc4e080d3e53446d05f63ba495ea7d44d6c316b54cd92b245c5c328c37da24605c4a93a0d099c4@34.246.65.14:30311,enode://5a7b996048d1b0a07683a949662c87c09b55247ce774aeee10bb886892e586e3c604564393292e38ef43c023ee9981e1f8b335766ec4f0f256e57f8640b079d5@35.73.137.11:30311"
```

#### **Polygon reader-node-arguments**

The reader-node-arguments flag for Polygon need to be updated to reflect the following.

```bash
reader-node-arguments: "+--bor.heimdall=https://heimdall.api.matic.network --bootnodes=enode://0cb82b395094ee4a2915e9714894627de9ed8498fb881cec6db7c65e8b9a5bd7f2f25cc84e71e89d0947e51c76e85d0847de848c7782b13c0255247a6758178c@44.232.55.71:30303,enode://88116f4295f5a31538ae409e4d44ad40d22e44ee9342869e7d68bdec55b0f83c1530355ce8b41fbec0928a7d75a5745d528450d30aec92066ab6ba1ee351d710@159.203.9.164:30303"
```

#### **Goerli reader-node-arguments**

As previously mentioned, Goerli does not require specific JSON files. The config file does however require modifications. The reader-node-arguments flag should be updated to reflect the value provided below. _Note, Goreli setups do not need to pass values for bootsnotes as with the Binance and Polygon setups._

```bash
reader-node-arguments: +--goerli --http.port=9545 --ws.port=9546 --port=40303
```

{% hint style="warning" %}
**Important**_: The cache argument passed to fireeth should be updated to 1024. This is due to the smaller size of the Goreli test network_.
{% endhint %}

## Test Installation

The following command is used to start Firehose. Run the command from the directory that Firehose was installed to if other than `usr/local/bin`.

```bash
./fireeth -c eth-mainnet.yaml start
```

### **Successful Installation Logging**

After issuing the start command to the terminal it can take up to thirty seconds for Firehose to begin connecting to peers and processing block data.

Logging will be rapidly printed to the terminal window. See the log below for example logging.

Press and hold the Control key and then press the C key three times to terminate Firehose and end all processes.

```bash
2022-09-05T12:25:01.208-0700 INFO (<n/a>) registering development exporters from environment variables
2022-09-05T12:25:01.208-0700 INFO (fireeth) starting with config file 'config.yaml'
2022-09-05T12:25:01.209-0700 INFO (fireeth) launching applications: combined-index-builder,firehose,merger,reader-node,relayer
2022-09-05T12:25:01.209-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/index", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/index"}
2022-09-05T12:25:01.209-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/index", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/index"}
2022-09-05T12:25:01.209-0700 INFO (fireeth) looked for GRPC_XDS_BOOTSTRAP {"filename": ""}
2022-09-05T12:25:01.210-0700 INFO (reader) adding superviser shutdown to plugins {"plugin_name": "log plug func"}
2022-09-05T12:25:01.210-0700 INFO (reader) registered log plugin {"plugin count": 1}
2022-09-05T12:25:01.210-0700 INFO (reader) adding superviser shutdown to plugins {"plugin_name": "ToConsoleLogPlugin"}
2022-09-05T12:25:01.210-0700 INFO (reader) registered log plugin {"plugin count": 2}
2022-09-05T12:25:01.210-0700 INFO (reader) created geth superviser {"superviser": {"binary": "./geth_mac", "arguments": ["--networkid=1", "--datadir=/Users/<User Account>/sf-firehose/sf-data/reader/data", "--ipcpath=/Users/<User Account>/sf-firehose/sf-data/reader/ipc", "--port=30305", "--http", "--http.api=eth,net,web3", "--http.port=8547", "--http.addr=0.0.0.0", "--http.vhosts=*", "--firehose-enabled", "--cache", "8192", "--maxpeers", "100", "--metrics", "--metrics.port", "6061", "--port=30303", "--http.port=8545", "--snapshot=true", "--txlookuplimit=1000"], "data_dir": "/Users/<User Account>/sf-firehose/sf-data/reader/data", "ipc_file_path": "/Users/<User Account>/sf-firehose/sf-data/reader/ipc", "last_block_seen": 0, "enode_str": ""}}
2022-09-05T12:25:01.210-0700 INFO (reader) creating operator {"options": {"Bootstrapper":null,"EnableSupervisorMonitoring":true,"ShutdownDelay":0}}
2022-09-05T12:25:01.210-0700 INFO (reader) parsing backup configs {"configs": [], "factory_count": 1}
2022-09-05T12:25:01.210-0700 INFO (reader) parsing backup known factory {"name": "gke-pvc-snapshot"}
2022-09-05T12:25:01.210-0700 INFO (reader) backup config {"config": [], "backup_module_count": 0, "backup_schedule_count": 0}
2022-09-05T12:25:01.210-0700 INFO (reader) creating mindreader plugin {"one_blocks_store_url": "file:///Users/<User Account>/sf-firehose/sf-data/storage/one-blocks", "one_block_suffix": "default", "working_directory": "/Users/<User Account>/sf-firehose/sf-data/reader/work", "start_block_num": 0, "stop_block_num": 0, "channel_capacity": 100, "with_head_block_updater": true, "with_shutdown_func": true}
2022-09-05T12:25:01.210-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/reader/work/uploadable-oneblock", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/reader/work/uploadable-oneblock"}
2022-09-05T12:25:01.210-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks"}
2022-09-05T12:25:01.210-0700 INFO (reader) creating new mindreader plugin
2022-09-05T12:25:01.210-0700 INFO (reader) adding superviser shutdown to plugins {"plugin_name": "MindReaderPlugin"}
2022-09-05T12:25:01.210-0700 INFO (reader) registered log plugin {"plugin count": 3}
2022-09-05T12:25:01.210-0700 INFO (reader) adding superviser shutdown to plugins {"plugin_name": "TrxPoolLogPlugin"}
2022-09-05T12:25:01.210-0700 INFO (reader) registered log plugin {"plugin count": 4}
2022-09-05T12:25:01.210-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks"}
2022-09-05T12:25:01.211-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks"}
2022-09-05T12:25:01.210-0700 INFO (firehose) running firehose {"config": {"MergedBlocksStoreURL":"file:///Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks","OneBlocksStoreURL":"file:///Users/<User Account>/sf-firehose/sf-data/storage/one-blocks","ForkedBlocksStoreURL":"file:///Users/<User Account>/sf-firehose/sf-data/storage/forked-blocks","BlockStreamAddr":":13011","GRPCListenAddr":":13042","GRPCShutdownGracePeriod":1000000000}}
2022-09-05T12:25:01.211-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks"}
2022-09-05T12:25:01.211-0700 INFO (relayer) starting relayer {"sources_addr": [":13010"], "grpc_listen_addr": ":13011", "source_request_burst": 0, "max_source_latency": "999999h0m0s", "one_blocks_url": "file:///Users/<User Account>/sf-firehose/sf-data/storage/one-blocks"}
2022-09-05T12:25:01.211-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks"}
2022-09-05T12:25:01.211-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/forked-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/forked-blocks"}
2022-09-05T12:25:01.210-0700 INFO (reader) launching nodeos mindreader {"config": {"ManagerAPIAddress":":13009","ConnectionWatchdog":false,"GRPCAddr":":13010"}}
2022-09-05T12:25:01.211-0700 INFO (reader) retrieved hostname from os {"hostname": "NSA-Lab-x01.local"}
2022-09-05T12:25:01.211-0700 INFO (reader) starting grpc listener {"listen_addr": ":13010"}
2022-09-05T12:25:01.211-0700 INFO (relayer) waiting for hub to be ready...
2022-09-05T12:25:01.211-0700 INFO (relayer) new source factory created
2022-09-05T12:25:01.210-0700 INFO (merger) running merger {"config": {"StorageOneBlockFilesPath":"file:///Users/<User Account>/sf-firehose/sf-data/storage/one-blocks","StorageMergedBlocksFilesPath":"file:///Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks","StorageForkedBlocksFilesPath":"file:///Users/<User Account>/sf-firehose/sf-data/storage/forked-blocks","GRPCListenAddr":":13012","PruneForkedBlocksAfter":50000,"TimeBetweenPruning":60000000000,"TimeBetweenPolling":1000000000,"StopBlock":0}}
2022-09-05T12:25:01.212-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/one-blocks"}
2022-09-05T12:25:01.212-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks"}
2022-09-05T12:25:01.212-0700 INFO (dstore) sanitized base path {"original_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/forked-blocks", "sanitized_base_path": "/Users/<User Account>/sf-firehose/sf-data/storage/forked-blocks"}
2022-09-05T12:25:01.212-0700 INFO (index-builder) index builder running
2022-09-05T12:25:01.212-0700 INFO (index-builder) processing incoming blocks request {"req_start_block": 0, "req_cursor": "", "req_stop_block": 0, "final_blocks_only": true}
2022-09-05T12:25:01.212-0700 INFO (index-builder) creating new joining source {"cursor": "<nil>", "start_block_num": 0}
2022-09-05T12:25:01.212-0700 INFO (merger) merger initiated
2022-09-05T12:25:01.212-0700 INFO (index-builder) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks/0000000000.dbin.zst", "base_filename": "0000000000", "retry_delay": "4s"}
2022-09-05T12:25:01.213-0700 INFO (merger) merger running
2022-09-05T12:25:01.213-0700 INFO (merger) starting merger
2022-09-05T12:25:01.213-0700 INFO (merger) grpc server created
2022-09-05T12:25:01.213-0700 INFO (relayer.src.13010) starting block source consumption {"endpoint_url": ":13010"}
2022-09-05T12:25:01.213-0700 INFO (relayer.src.13010) block stream source reading messages {"endpoint_url": ":13010"}
2022-09-05T12:25:01.213-0700 INFO (merger) tcp listener created
2022-09-05T12:25:01.213-0700 INFO (merger) server registered
2022-09-05T12:25:01.213-0700 INFO (merger) starting pruning of unused (old) one-block-files {"pruning_distance_to_lib": 100, "time_between_pruning": "1m0s"}
2022-09-05T12:25:01.213-0700 INFO (merger) starting pruning of forked files {"pruning_distance_to_lib": 50000, "time_between_pruning": "1m0s"}
2022-09-05T12:25:01.213-0700 INFO (merger) listening & serving grpc content {"grpc_listen_addr": ":13012"}
2022-09-05T12:25:01.213-0700 INFO (reader.sub.relayer) receive block request {"trace_id": "2b1266f29670d0e6fb915b9075adc1aa", "request": {"requester":"relayer"}}
2022-09-05T12:25:01.213-0700 INFO (reader.sub.relayer) sending burst {"busrt_size": 0}
2022-09-05T12:25:01.213-0700 INFO (reader) subscribed {"new_length": 1, "subscriber": "relayer"}
2022-09-05T12:25:02.212-0700 INFO (reader) grpc server listener ready
2022-09-05T12:25:02.212-0700 INFO (reader) launching metrics and readinessManager
2022-09-05T12:25:02.212-0700 INFO (reader) launching operator
2022-09-05T12:25:02.212-0700 INFO (reader) launching operator HTTP server {"http_listen_addr": ":13009"}
2022-09-05T12:25:02.212-0700 INFO (reader) starting webserver {"http_addr": ":13009"}
2022-09-05T12:25:02.212-0700 INFO (reader) operator ready to receive commands
2022-09-05T12:25:02.212-0700 INFO (reader) received operator command {"command": "start", "params": null}
2022-09-05T12:25:02.212-0700 INFO (reader) preparing for start
2022-09-05T12:25:02.212-0700 INFO (reader) preparing to start chain
2022-09-05T12:25:02.212-0700 INFO (reader) starting mindreader
2022-09-05T12:25:02.213-0700 INFO (reader) creating new command instance and launch read loop {"binary": "./geth_mac", "arguments": ["--networkid=1", "--datadir=/Users/<User Account>/sf-firehose/sf-data/reader/data", "--ipcpath=/Users/<User Account>/sf-firehose/sf-data/reader/ipc", "--port=30305", "--http", "--http.api=eth,net,web3", "--http.port=8547", "--http.addr=0.0.0.0", "--http.vhosts=*", "--firehose-enabled", "--cache", "8192", "--maxpeers", "100", "--metrics", "--metrics.port", "6061", "--port=30303", "--http.port=8545", "--snapshot=true", "--txlookuplimit=1000"]}
2022-09-05T12:25:02.213-0700 INFO (reader) starting consume flow
2022-09-05T12:25:02.213-0700 INFO (reader) successfully start service
2022-09-05T12:25:02.213-0700 INFO (reader) operator ready to receive commands
INFO [09-05|12:25:02.260] Initializing firehose
INFO [09-05|12:25:02.267] Firehose initialized                     enabled=true sync_instrumentation_enabled=true mining_enabled=false block_progress_enabled=false compaction_disabled=false archive_blocks_to_keep=0 genesis_provenance="Geth Default" firehose_version=2.0 geth_version=1.10.23-fh2 chain_variant=geth
2022-09-05T12:25:02.267-0700 INFO (reader) read firehose instrumentation init line {"dm_version": "2.0", "node_variant": "geth", "node_version": "1.10.23-fh2-e7f3686b"}
INFO [09-05|12:25:02.268] Enabling metrics collection
INFO [09-05|12:25:02.270] Maximum peer count                       ETH=100 LES=0 total=100
WARN [09-05|12:25:02.274] Sanitizing cache to Go's GC limits       provided=8192 updated=5461
INFO [09-05|12:25:02.275] Set global gas cap                       cap=50,000,000
INFO [09-05|12:25:02.276] Allocated trie memory caches             clean=819.00MiB dirty=1.33GiB
INFO [09-05|12:25:02.276] Allocated cache and file handles         database=/Users/<User Account>/sf-firehose/sf-data/reader/data/geth/chaindata cache=2.67GiB handles=5120
INFO [09-05|12:25:02.608] Opened ancient database                  database=/Users/<User Account>/sf-firehose/sf-data/reader/data/geth/chaindata/ancient/chain readonly=false
INFO [09-05|12:25:02.608] Writing default main-net genesis block
INFO [09-05|12:25:02.991] Persisted trie from memory database      nodes=12356 size=1.78MiB time=28.732231ms gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [09-05|12:25:03.008]
INFO [09-05|12:25:03.008] ---------------------------------------------------------------------------------------------------------------------------------------------------------
INFO [09-05|12:25:03.009] Chain ID:  1 (mainnet)
INFO [09-05|12:25:03.009] Consensus: Beacon (proof-of-stake), merging from Ethash (proof-of-work)
INFO [09-05|12:25:03.009]
INFO [09-05|12:25:03.009] Pre-Merge hard forks:
INFO [09-05|12:25:03.009]  - Homestead:                   1150000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/homestead.md)
INFO [09-05|12:25:03.009]  - DAO Fork:                    1920000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/dao-fork.md)
INFO [09-05|12:25:03.009]  - Tangerine Whistle (EIP 150): 2463000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/tangerine-whistle.md)
INFO [09-05|12:25:03.009]  - Spurious Dragon/1 (EIP 155): 2675000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/spurious-dragon.md)
INFO [09-05|12:25:03.009]  - Spurious Dragon/2 (EIP 158): 2675000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/spurious-dragon.md)
INFO [09-05|12:25:03.009]  - Byzantium:                   4370000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/byzantium.md)
INFO [09-05|12:25:03.009]  - Constantinople:              7280000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/constantinople.md)
INFO [09-05|12:25:03.009]  - Petersburg:                  7280000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/petersburg.md)
INFO [09-05|12:25:03.009]  - Istanbul:                    9069000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/istanbul.md)
INFO [09-05|12:25:03.009]  - Muir Glacier:                9200000  (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/muir-glacier.md)
INFO [09-05|12:25:03.009]  - Berlin:                      12244000 (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/berlin.md)
INFO [09-05|12:25:03.009]  - London:                      12965000 (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/london.md)
INFO [09-05|12:25:03.009]  - Arrow Glacier:               13773000 (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/arrow-glacier.md)
INFO [09-05|12:25:03.009]  - Gray Glacier:                15050000 (https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/gray-glacier.md)
INFO [09-05|12:25:03.009]
INFO [09-05|12:25:03.009] Merge configured:
INFO [09-05|12:25:03.009]  - Hard-fork specification:    https://github.com/ethereum/execution-specs/blob/master/network-upgrades/mainnet-upgrades/paris.md
INFO [09-05|12:25:03.009]  - Network known to be merged: false
INFO [09-05|12:25:03.009]  - Total terminal difficulty:  58750000000000000000000
INFO [09-05|12:25:03.009]  - Merge netsplit block:       <nil>
INFO [09-05|12:25:03.009] ---------------------------------------------------------------------------------------------------------------------------------------------------------
INFO [09-05|12:25:03.009]
INFO [09-05|12:25:03.010] Disk storage enabled for ethash caches   dir=/Users/<User Account>/sf-firehose/sf-data/reader/data/geth/ethash count=3
INFO [09-05|12:25:03.010] Disk storage enabled for ethash DAGs     dir=/Users/<User Account>/Library/Ethash count=2
INFO [09-05|12:25:03.010] Initialising Ethereum protocol           network=1 dbversion=<nil>
INFO [09-05|12:25:03.010] Loaded most recent local header          number=0 hash=d4e567..cb8fa3 td=17,179,869,184 age=53y5mo1w
INFO [09-05|12:25:03.010] Loaded most recent local full block      number=0 hash=d4e567..cb8fa3 td=17,179,869,184 age=53y5mo1w
INFO [09-05|12:25:03.010] Loaded most recent local fast block      number=0 hash=d4e567..cb8fa3 td=17,179,869,184 age=53y5mo1w
WARN [09-05|12:25:03.010] Failed to load snapshot, regenerating    err="missing or corrupted snapshot"
INFO [09-05|12:25:03.010] Rebuilding state snapshot
INFO [09-05|12:25:03.011] Resuming state snapshot generation       root=d7f897..0f0544 accounts=0 slots=0 storage=0.00B dangling=0 elapsed="269.406µs"
INFO [09-05|12:25:03.058] Generated state snapshot                 accounts=8893 slots=0 storage=409.64KiB dangling=0 elapsed=47.595ms
INFO [09-05|12:25:03.145] Regenerated local transaction journal    transactions=0 accounts=0
WARN [09-05|12:25:03.145] Chain pre-merge, sync via PoW (ensure beacon client is ready)
INFO [09-05|12:25:03.145] Gasprice oracle is ignoring threshold set threshold=2
WARN [09-05|12:25:03.145] Error reading unclean shutdown markers   error="leveldb: not found"
WARN [09-05|12:25:03.145] Engine API enabled                       protocol=eth
INFO [09-05|12:25:03.146] Starting peer-to-peer node               instance=Geth/v1.10.23-fh2-e7f3686b/darwin-amd64/go1.17.13
2022-09-05T12:25:03.232-0700 INFO (relayer.src.13010) realtime gate passed {"delta": "461779h25m3.232416s"}
2022-09-05T12:25:03.232-0700 INFO (bstream) loading blocks in ForkableHub from one-block-files {"start_block": 0, "head_block": "#0 (d4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3)"}
2022-09-05T12:25:03.232-0700 INFO (bstream) hub is now Ready
2022-09-05T12:25:03.232-0700 INFO (relayer) tcp listener created
2022-09-05T12:25:03.232-0700 INFO (relayer) relayer started
2022-09-05T12:25:03.232-0700 INFO (relayer) listening & serving grpc content {"grpc_listen_addr": ":13011"}
INFO [09-05|12:25:03.273] New local node record                    seq=1,662,405,903,273 id=317a15a10de82d75 ip=127.0.0.1 udp=30303 tcp=30303
INFO [09-05|12:25:03.274] Started P2P networking                   self=enode://97234bff3889634bafb9f912567a79b8fdd72ff4bc4225eed309a04d9ce99bb0bd4fbff82f65972672fd8a47191cc3c00229215695e08fe3a37e0844daa13535@127.0.0.1:30303
INFO [09-05|12:25:03.275] IPC endpoint opened                      url=/Users/<User Account>/sf-firehose/sf-data/reader/ipc
INFO [09-05|12:25:03.275] Generated JWT secret                     path=/Users/<User Account>/sf-firehose/sf-data/reader/data/geth/jwtsecret
INFO [09-05|12:25:03.276] HTTP server started                      endpoint=[::]:8545 auth=false prefix= cors= vhosts=*
INFO [09-05|12:25:03.276] WebSocket enabled                        url=ws://127.0.0.1:8551
INFO [09-05|12:25:03.277] HTTP server started                      endpoint=127.0.0.1:8551 auth=true  prefix= cors=localhost vhosts=localhost
2022-09-05T12:25:04.016-0700 INFO (firehose) registering grpc services
2022-09-05T12:25:04.016-0700 INFO (firehose) waiting until hub is real-time synced
2022-09-05T12:25:04.017-0700 INFO (bstream) starting block source consumption {"endpoint_url": ":13011"}
2022-09-05T12:25:04.017-0700 INFO (bstream) block stream source reading messages {"endpoint_url": ":13011"}
2022-09-05T12:25:04.017-0700 INFO (dgrpc.sub.firehose) receive block request {"trace_id": "e9a7c2bb146f4a043fab008bc65861e1", "request": {"burst":-1,"requester":"firehose"}}
2022-09-05T12:25:04.020-0700 INFO (bstream) loading blocks in ForkableHub from one-block-files {"start_block": 0, "head_block": "#0 (d4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3)"}
2022-09-05T12:25:04.025-0700 INFO (bstream) hub is now Ready
2022-09-05T12:25:04.025-0700 INFO (firehose) launching gRPC server {"live_support": true}
2022-09-05T12:25:04.025-0700 INFO (firehose) serving gRPC (over HTTP router) (plain-text) {"listen_addr": ":13042"}
2022-09-05T12:25:05.214-0700 INFO (index-builder) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks/0000000000.dbin.zst", "base_filename": "0000000000", "retry_delay": "4s"}
INFO [09-05|12:25:05.656] New local node record                    seq=1,662,405,903,274 id=317a15a10de82d75 ip=24.56.193.29 udp=30303 tcp=30303
2022-09-05T12:25:09.215-0700 INFO (index-builder) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks/0000000000.dbin.zst", "base_filename": "0000000000", "retry_delay": "4s"}
2022-09-05T12:25:13.217-0700 INFO (index-builder) reading from blocks store: file does not (yet?) exist, retrying in {"filename": "/Users/<User Account>/sf-firehose/sf-data/storage/merged-blocks/0000000000.dbin.zst", "base_filename": "0000000000", "retry_delay": "4s"}
INFO [09-05|12:25:13.377] Looking for peers                        peercount=0 tried=17 static=0

```

After Firehose has been set up it needs to be synchronized with the target blockchain. Full sync is a data and time-intensive process and can take several days or longer to complete for full archive nodes. Further documentation is provided for [synchronizing Firehose](../../setup/cosmos/synchronization.md).

## **Fireeth Tools**

Firehose also provides tools for operators to inspect many facets of the application. For example, the `tools check merged-blocks` command can be used to view and investigate the block data produced by Firehose.

```bash
fireeth tools check merged-blocks ./sf-data/storage/merged-blocks
```

The merged blocks tool will print to the terminal window. Look for messaging similar to what's shown below to determine if the installation was successful.

```bash
2022-09-05T12:39:20.096-0700 INFO (<n/a>) registering development exporters from environment variables
Checking block holes on ./sf-data/storage/merged-blocks
2022-09-05T12:39:20.096-0700 INFO (dstore) sanitized base path {"original_base_path": "./sf-data/storage/merged-blocks", "sanitized_base_path": "sf-data/storage/merged-blocks"}
✅ Range #0 - #7 600
🆗 No hole found

```

## **Problems**

It may be necessary to remove the quarantine attribute on the Geth and Firehose binary files to resolve signing issues on macOS.

```bash
xattr -d com.apple.quarantine fireeth
xattr -d com.apple.quarantine geth_mac
```

{% hint style="info" %}
_Note: this step will only need to be completed once._
{% endhint %}

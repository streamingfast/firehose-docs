---
description: StreamingFast Firehose Cosmos synchronization
---

# Synchronization

## Cosmos Synchronization

#### Cosmos Sync in Detail

Firehose for Cosmos, `firehose-cosmos,` is an application that funs a few small, isolated processes as a Firehose implementation.&#x20;

The latest version of `firehose-cosmos` is available in the project's [official Github repository](https://github.com/figment-networks/firehose-cosmos/releases).&#x20;

Firehose for Cosmos is also available at [Figment's Docker Hub](https://hub.docker.com/r/figmentnetworks/firehose-cosmos/tags) and the latest release is listed project's on the [Github releases page](https://github.com/figment-networks/firehose-cosmos/releases).&#x20;

StreamingFast recommends using the `firehose-cosmos` Dockerfile.

_Note, make sure to download the most recent version of `firehose-cosmos` for the latest functionality, updates, and patches._&#x20;

```shell-session
docker run --rm -it figmentnetworks/firehose-cosmos:0.4.0 /app/firehose help
```

Firehose Cosmos can also be installed from source. Navigate to the `firehose-cosmos` directory and issue the `make install` command to the terminal window.

#### Verify Installation of Cosmos

Issue the following command to the terminal window to verify that the Cosmos installation was successful.

```shell-session
firehose-cosmos --version
# or
docker run --rm -it figmentnetworks/firehose-cosmos:0.4.0 /app/firehose --version
```

#### Indexing Cosmos

To index Cosmos, the binaries must be correctly modified for the selected target blockchain.

Figment provides [binaries and pre-built Docker images](https://hub.docker.com/r/figmentnetworks/firehose-cosmos/tags) for CosmosHub and Osmosis. _Note, Mainnet and Testnet versions are available._&#x20;

The Dockerfiles will start the `firehose-cosmos` process for you.&#x20;

#### Chain Data Volume Storage Path&#x20;

Be sure to pass the path to the chain data volume storage. If the path isn't supplied the chain will begin synchronizing at the Genesis block each time the application runs.&#x20;

Modify the command below to reference the version of the chain node being indexed.&#x20;

Example command for Osmosis Testnet v7.0.4.

```shell-session
docker run --rm -it -v data:/app/osmosis_home/data figmentnetworks/firehose-cosmos:fh-v0.4.0-osmosis1-testnet-v7.0.4 /app/firehose start
```

Chain data volume storage path for CosmosHub chains.

```
/app/gaia_home/data
```

#### Running Nodes Outside Docker

To run a node outside of Docker update the configuration file for the binary. Check the Extractor Configuration Options to match them with the example below.

```ini
#######################################################
###       Extractor Configuration Options           ###
#######################################################
[extractor]
enabled = true
output_file = "stdout"
```

#### Configuration Files

Configuration files can be passed into the binary at startup. This alleviates passing in numerous command line flags, saves time and reduces errors.

Pass the configuration file to the binary at startup using the following argument.

```
-c ./configfile.yaml
```

The content below can be used for the configuration file. _Note, the path to the node binary should be updated to reflect the location on the target computer._

```
start:
  args:
    - ingestor
    - merger
    - relayer
    - firehose
  flags:
    # Common flags
    common-first-streamable-block: 1

    # Ingestor specific flags
    ingestor-mode: node
    ingestor-node-path: path/to/node_binary
    ingestor-node-args: start
```

#### Syncing your chain

The first time the node runs it will begin synchronization from the genesis block. This initial sync can generally take some time, so, give the process a minute or two to get started.

If the setup has been configured properly blocks of data will begin streaming and printing to the terminal window.

For Cosmos deployments running locally the node's status is viewable by pointing a web browser to the following address.&#x20;

[http://localhost:26657/status](http://localhost:26657/status)

Issue the following command to the terminal window to test the installation's ability to stream block data using `grpcurl.`

```
grpcurl -plaintext localhost:9030 sf.firehose.v1.Stream.Blocks | jq
```

_Note, both_ [_grpcurl_](https://github.com/fullstorydev/grpcurl) _and_ [_jq_](https://github.com/stedolan/jq) _should be installed. If they aren't available check the target computer's preferred package manager._

Issuing the `grpcurl` command will result in the following logging information being printed to the terminal.

```shell-session
2022-05-30T22:30:11.142+0100 (ingestor) creating mindreader plugin (mindreader/mindreader.go:99) {"archive_store_url": "file:///../fh-data/storage/one-blocks", "merge_archive_store_url": "file:///../fh-data/storage/merged-blocks", "oneblock_suffix": "", "batch_mode": false, "merge_threshold_age": "2562047h47m16.854775807s", "working_directory": "/../fh-data/workdir", "start_block_num": 0, "stop_block_num": 0, "channel_capacity": 0, "with_head_block_update_func": true, "with_shutdown_func": true, "fail_on_non_continuous_blocks": true, "wait_upload_complete_on_shutdown": "10s"}
2022-05-30T22:30:11.142+0100 (ingestor) creating new mindreader plugin (mindreader/mindreader.go:185)
2022-05-30T22:30:11.143+0100 (merger) running merger (merger/app.go:60) {"config": {"StorageOneBlockFilesPath":"file:///../fh-data/storage/one-blocks","StorageMergedBlocksFilesPath":"file:///../fh-data/storage/merged-blocks","GRPCListenAddr":"0.0.0.0:9020","WritersLeewayDuration":10000000000,"TimeBetweenStoreLookups":5000000000,"StateFile":"/../fh-data/merger/merger.seen.gob","OneBlockDeletionThreads":10,"MaxOneBlockOperationsBatchSize":2000,"NextExclusiveHighestBlockLimit":0}}
2022-05-30T22:30:11.143+0100 (firehose) running firehose (firehose/app.go:84) {"config": {"BlockStoreURLs":["file:///../fh-data/storage/merged-blocks"],"IrreversibleBlocksIndexStoreURL":"","IrreversibleBlocksBundleSizes":[100000,10000,1000,100],"BlockStreamAddr":"localhost:9000","GRPCListenAddr":"0.0.0.0:9030","GRPCShutdownGracePeriod":0,"RealtimeTolerance":359996400000000000}}
2022-05-30T22:30:11.144+0100 (firehose) setting up subscription hub (firehose/app.go:211)
2022-05-30T22:30:11.143+0100 (ingestor) starting mindreader (mindreader/mindreader.go:205)
2022-05-30T22:30:11.144+0100 (merger) failed to load bundle  (merger/app.go:98) {"file_name": "/../fh-data/merger/merger.seen.gob"}
2022-05-30T22:30:11.144+0100 (firehose) creating gRPC server (firehose/app.go:127) {"live_support": true}
2022-05-30T22:30:11.144+0100 (ingestor) serving gRPC (over HTTP router) (plain-text) (dgrpc/server.go:184) {"listen_addr": "0.0.0.0:9000"}
2022-05-30T22:30:11.145+0100 (ingestor) starting one block(s) uploads (mindreader/archiver_selector.go:343)
2022-05-30T22:30:11.145+0100 (ingestor) starting merged blocks(s) uploads (mindreader/archiver_selector.go:345)
2022-05-30T22:30:11.145+0100 (ingestor) starting consume flow (mindreader/mindreader.go:262)
2022-05-30T22:30:11.145+0100 (firehose) registering grpc services (server/server.go:78)
2022-05-30T22:30:11.145+0100 (merger) new bundler (bundle/bundler.go:25) {"bundle_size": 100, "first_exclusive_highest_block_limit": 5200800}
2022-05-30T22:30:11.151+0100 (firehose) retrieving live start block (firehose/app.go:153)
2022-05-30T22:30:11.151+0100 (merger) merger initiated (merger/app.go:136)
2022-05-30T22:30:11.152+0100 (merger) merger running (merger/app.go:150)
2022-05-30T22:30:11.152+0100 (merger) starting merger (merger/merger.go:64) {"bundle": {"bundle_size": 100, "inclusive_lower_block_num": 5200700, "exclusive_highest_block_limit": 5200800, "lib_num": 0, "lib_id": "", "longest_chain_length": 0}}
2022-05-30T22:30:11.152+0100 (merger) grpc server created (merger/server.go:19)
2022-05-30T22:30:11.153+0100 (merger) tcp listener created (merger/server.go:26)
2022-05-30T22:30:11.153+0100 (merger) server registered (merger/server.go:30)
2022-05-30T22:30:11.153+0100 (merger) verifying if bundle file already exist in store (merger/merger.go:79) {"bundle_inclusive_lower_block": 5200700}
2022-05-30T22:30:11.153+0100 (merger) listening & serving grpc content (merger/server.go:33) {"grpc_listen_addr": "0.0.0.0:9020"}
2022-05-30T22:30:11.153+0100 (merger) retrieved list of files (merger/merger_io.go:121) {"files_count": 0}
2022-05-30T22:30:11.153+0100 (merger) retrieved list of files (merger/merger.go:185) {"too_old_files_count": 0, "added_files_count": 0}
2022-05-30T22:30:11.153+0100 (merger) bundle not completed after retrieving one block file (merger/merger.go:119) {"bundle": {"bundle_size": 100, "inclusive_lower_block_num": 5200700, "exclusive_highest_block_limit": 5200800, "lib_num": 0, "lib_id": "", "longest_chain_length": 0}}
10:30PM INF starting ABCI with Tendermint
`10:30PM INF Starting multiAppConn service impl=multiAppConn module=proxy
10:30PM INF Starting localClient service connection=query impl=localClient module=abci-client
10:30PM INF Starting localClient service connection=snapshot impl=localClient module=abci-client
10:30PM INF Starting localClient service connection=mempool impl=localClient module=abci-client
10:30PM INF Starting localClient service connection=consensus impl=localClient module=abci-client
10:30PM INF Starting EventBus service impl=EventBus module=events
10:30PM INF Starting PubSub service impl=PubSub module=pubsub
10:30PM INF Starting IndexerService service impl=IndexerService module=txindex
10:30PM INF Initialized extractor module output=stdout
...
```

After a short delay, blocks will begin syncing and printing to the terminal window.

```shell-session
...
2022-05-30T22:39:36.919+0100 (firehose.hub.js) incoming live block (bstream/joiningsource.go:333) {"block": "#5200802 (F7FBEE7A1C978EADD63FE86DE131E72BE7E0DBC78B099FF4BFAD60FF61099A6F)", "live_pass_through": false}
2022-05-30T22:39:36.919+0100 (firehose.hub.js) added live block to buffer (bstream/joiningsource.go:374) {"block": "#5200802 (F7FBEE7A1C978EADD63FE86DE131E72BE7E0DBC78B099FF4BFAD60FF61099A6F)", "buffer_size": 11}
10:39PM INF indexed block height=5200802 module=txindex
10:39PM INF executed block height=5200803 module=state num_invalid_txs=0 num_valid_txs=0
10:39PM INF commit synced commit=436F6D6D697449447B5B31313420313433203134342031363920323133203536203232203233372031323420313131203337203233372031333520323437203720393820323532203130203232332031332031363420323220313131203130352038312037372032323420313720382033203131392035325D3A3446354241337D
10:39PM INF committed state app_hash=728F90A9D53816ED7C6F25ED87F70762FC0ADF0DA4166F69514DE01108037734 height=5200803 module=state num_txs=0
10:39PM INF finalized dmlog block block=5200803 module=deepmind
2022-05-30T22:39:37.115+0100 (firehose.hub.js) incoming live block (bstream/joiningsource.go:333) {"block": "#5200803 (E9D938A1AE9FB576155BCC99CFBE715079F0DBC3918B0E1E67B3D27E5AF6EF7A)", "live_pass_through": false}
2022-05-30T22:39:37.115+0100 (firehose.hub.js) added live block to buffer (bstream/joiningsource.go:374) {"block": "#5200803 (E9D938A1AE9FB576155BCC99CFBE715079F0DBC3918B0E1E67B3D27E5AF6EF7A)", "buffer_size": 12}
10:39PM INF indexed block height=5200803 module=txindex
10:39PM INF executed block height=5200804 module=state num_invalid_txs=0 num_valid_txs=0
10:39PM INF commit synced commit=436F6D6D697449447B5B34362032313120323334203138322031333120333320373620343020313530203235203130302031323120363620393520313434203520313233203233312032313720383120313434203233372031393720362032353120313431203230372031353420343620393620313330203132375D3A3446354241347D
10:39PM INF committed state app_hash=2ED3EAB683214C2896196479425F90057BE7D95190EDC506FB8DCF9A2E60827F height=5200804 module=state num_txs=0
10:39PM INF finalized dmlog block block=5200804 module=deepmind
2022-05-30T22:39:37.293+0100 (firehose.hub.js) incoming live block (bstream/joiningsource.go:333) {"block": "#5200804 (8B5405A8714B66E7A3DD21537E7F4C6B650123085FE06EF3018163337C6C13AF)", "live_pass_through": false}
2022-05-30T22:39:37.293+0100 (firehose.hub.js) added live block to buffer (bstream/joiningsource.go:374) {"block": "#5200804 (8B5405A8714B66E7A3DD21537E7F4C6B650123085FE06EF3018163337C6C13AF)", "buffer_size": 13}
10:39PM INF indexed block height=5200804 module=txindex
10:39PM INF executed block height=5200805 module=state num_invalid_txs=0 num_valid_txs=0
10:39PM INF commit synced commit=436F6D6D697449447B5B313535203234352031363820323130203136312031323420313835203132342031333920353620313435203234362032332035203539203130322033332032302032333120323030203130372032333120313137203136382034332031383520313420313734203231342034332033352031395D3A3446354241357D
10:39PM INF committed state app_hash=9BF5A8D2A17CB97C8B3891F617053B662114E7C86BE775A82BB90EAED62B2313 height=5200805 module=state num_txs=0
10:39PM INF finalized dmlog block block=5200805 module=deepmind
2022-05-30T22:39:37.486+0100 (firehose.hub.js) incoming live block (bstream/joiningsource.go:333) {"block": "#5200805 (0904A4BCC13F76FECBB518DD4A7483C8AF68F9D3484ECAC3B8D9294FE7253E08)", "live_pass_through": false}
2022-05-30T22:39:37.486+0100 (firehose.hub.js) added live block to buffer (bstream/joiningsource.go:374) {"block": "#5200805 (0904A4BCC13F76FECBB518DD4A7483C8AF68F9D3484ECAC3B8D9294FE7253E08)", "buffer_size": 14}
10:39PM INF indexed block height=5200805 module=txindex
10:39PM INF executed block height=5200806 module=state num_invalid_txs=0 num_valid_txs=1
10:39PM INF commit synced commit=436F6D6D697449447B5B323337203736203138322032323620313336203136302031323420313035203132352037372038302034352032343620313032203430203233332032343020313334203232352033332031353220323433203131302032333320383820313931203233382038352031323920313837203138332037325D3A3446354241367D
10:39PM INF committed state app_hash=ED4CB6E288A07C697D4D502DF66628E9F086E12198F36EE958BFEE5581BBB748 height=5200806 module=state num_txs=1
10:39PM INF finalized dmlog block block=5200806 module=deepmind
2022-05-30T22:39:37.662+0100 (firehose.hub.js) incoming live block (bstream/joiningsource.go:333) {"block": "#5200806 (3516D766EBCC3D9886CD7DA197419A079525EB2928C8D8D9FF7E96E3E846B61F)", "live_pass_through": false}
2022-05-30T22:39:37.662+0100 (firehose.hub.js) added live block to buffer (bstream/joiningsource.go:374) {"block": "#5200806 (3516D766EBCC3D9886CD7DA197419A079525EB2928C8D8D9FF7E96E3E846B61F)", "buffer_size": 15}
10:39PM INF indexed block height=5200806 module=txindex
10:39PM INF executed block height=5200807 module=state num_invalid_txs=0 num_valid_txs=0
10:39PM INF commit synced commit=436F6D6D697449447B5B3132372032303820313538203832203132332032333720313230203132382031313820313631203835203235352032343020313833203233392039382031343220312036312032302031363020313437203430203734203234302032303820323138203133382032353520323533203637203132305D3A3446354241377D
10:39PM INF committed state app_hash=7FD09E527BED788076A155FFF0B7EF628E013D14A093284AF0D0DA8AFFFD4378 height=5200807 module=state num_txs=0
10:39PM INF finalized dmlog block block=5200807 module=deepmind
...
```

{% hint style="warning" %}
To terminate the Firehose processing and connection to the Ethereum network press the Control + C keys.

The Firehose sync process will shutdown gracefully and continue where it left off upon the next restart.
{% endhint %}

A graceful shutdown will result in a message similar to the one seen below.

```shell-session
...
2022-05-30T22:39:38.322+0100 (dfuse) Received termination signal, quitting (firehose-cosmos/cmd_start.go:55)
2022-05-30T22:39:38.322+0100 (dfuse) Waiting for all apps termination... (launcher/launcher.go:259)
2022-05-30T22:39:38.322+0100 (merger) merger exited (merger/merger.go:69)
2022-05-30T22:39:38.322+0100 (firehose) forcing gRPC server (over HTTP router) to stop (dgrpc/server.go:390)
2022-05-30T22:39:38.322+0100 (firehose) firehose is now ready to accept request (firehose/app.go:177)
10:39PM INF Stopping Node service impl={"Logger":{}}
10:39PM INF Stopping Node
10:39PM INF Stopping EventBus service impl={"Logger":{}} module=events
10:39PM INF Stopping PubSub service impl={"Logger":{}} module=pubsub
10:39PM INF Stopping IndexerService service impl={"Logger":{}} module=txindex
10:39PM INF Stopping Mempool service impl={"Logger":{},"Switch":{"Logger":{}}} module=mempool
10:39PM INF Stopping BlockchainReactor service impl={"Logger":{},"Switch":{"Logger":{}}} module=blockchain
10:39PM INF Stopping BlockPool service impl={"Logger":{}} module=blockchain
2022-05-30T22:39:38.323+0100 (firehose) gRPC server (over HTTP router) terminated gracefully (dgrpc/server.go:397)
10:39PM INF executed block height=5200810 module=state num_invalid_txs=0 num_valid_txs=0
10:39PM INF commit synced commit=436F6D6D697449447B5B36312036342036392032323820363820362032382036342031333620313336203137382031313920363620313620323535203136302031322034322031332032343520313833203133342039392031373820382033362031353620323236203136372031353320323039203131385D3A3446354241417D
10:39PM INF committed state app_hash=3D4045E444061C408888B2774210FFA00C2A0DF5B78663B208249CE2A799D176 height=5200810 module=state num_txs=0
10:39PM INF finalized dmlog block block=5200810 module=deepmind
2022-05-30T22:39:38.444+0100 (firehose.hub.js) incoming live block (bstream/joiningsource.go:333) {"block": "#5200810 (119D8EC24EE734EB93895B89CA9629D721E5C63AC941933F582BDEB47BEB3107)", "live_pass_through": false}
2022-05-30T22:39:38.444+0100 (firehose.hub.js) added live block to buffer (bstream/joiningsource.go:374) {"block": "#5200810 (119D8EC24EE734EB93895B89CA9629D721E5C63AC941933F582BDEB47BEB3107)", "buffer_size": 19}
2022-05-30T22:39:38.819+0100 (firehose.hub.js.file) reading from blocks store: file does not (yet?) exist, retrying in (bstream/filesource.go:194) {"filename": "/../fh-data/storage/merged-blocks/0005200700.dbin.zst", "base_filename": "0005200700", "retry_delay": "4s", "secondary_blocks_stores_count": 0}
10:39PM INF exiting...
2022-05-30T22:39:39.414+0100 (ingestor) mindreader is stopping (mindreader/mindreader.go:241)
2022-05-30T22:39:39.414+0100 (ingestor) waiting until consume read flow (i.e. blocks) is actually done processing blocks... (mindreader/mindreader.go:255)
2022-05-30T22:39:39.414+0100 (ingestor) reached end of console reader stream, nothing more to do (mindreader/mindreader.go:228)
2022-05-30T22:39:39.414+0100 (ingestor) all blocks in channel were drained, exiting read flow (mindreader/mindreader.go:269)
2022-05-30T22:39:39.414+0100 (ingestor) archiver selector is terminating (mindreader/archiver_selector.go:88)
2022-05-30T22:39:39.414+0100 (ingestor) merger archiver is terminating (mindreader/merge_archiver.go:65)
2022-05-30T22:39:39.414+0100 (ingestor) terminating upload loop (mindreader/merge_archiver.go:100)
2022-05-30T22:39:39.414+0100 (ingestor) merger archiver is terminated (mindreader/merge_archiver.go:73)
2022-05-30T22:39:39.414+0100 (ingestor) one block archiver is terminating (mindreader/archiver.go:66)
2022-05-30T22:39:39.414+0100 (ingestor) terminating upload loop (mindreader/archiver.go:146)
2022-05-30T22:39:39.414+0100 (ingestor) one block archiver is terminated (mindreader/archiver.go:74)
2022-05-30T22:39:39.414+0100 (ingestor) archiver selector is terminated (mindreader/archiver_selector.go:98)
2022-05-30T22:39:39.414+0100 (ingestor) archiver Terminate done (mindreader/mindreader.go:275)
2022-05-30T22:39:39.414+0100 (ingestor) consume read flow terminate (mindreader/mindreader.go:257)
2022-05-30T22:39:39.414+0100 (dfuse) All apps terminated gracefully (launcher/launcher.go:273)
```

Note, the `firehose-cosmos` extractor component is labeled `ingestor` however is functionally identical. Learn more about the Firehose [components](../../concepts/components.md) and the overall [concepts and architecture](broken-reference).

### Synchronization Completion

#### Successful Sync

The target computer is now successfully streaming Cosmos block data. _Congratulations!_

Full searchability and discoverability of Cosmos is now possible and the underlying blockchain data can be sliced and diced into a myriad of different solutions.

**Cosmoshub-4 Mainnet**

Coming soon.

**Osmosis-1 Mainnet**

Coming soon.

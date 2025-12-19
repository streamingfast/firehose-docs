---
description: StreamingFast Firehose merger component
---

# Merger

## Merger Component in Detail

The Merger component is responsible for:
1. Polling and Reading "one-block store" for files written from the [Reader](./reader) component
2. Validating that the chain is complete.
3. Bundling finalized blocks into "merged-blocks bundles" 
4. Moving the forked blocks to the "forked-blocks store"

### Merged Blocks Bundles

The Merger produces "merged-blocks bundles", containing all the finalized blocks in a 100-blocks boundary, saved to the merged-blocks-store (flag `common-merged-blocks-store-url`)
The filename contains the lower boundary (ex: 0000010100.dbin.zst).
It may contain less than 100 blocks if that particular chain skips blocks (ex: solana), but never more, since forked blocks are excluded.

### One-blocks

The Merger component reads the "one-block files" from the one-block object store (flag `common-one-block-store-url`)

### Forked blocks

The merger only merges finalized blocks. No forked block (also called uncled or reorged) make it into the merged-blocks bundles, they are instead moved to the forked blocks store (flag `common-forked-blocks-store-url`).

### Merger Flow

* On boot, it looks for the first missing merged-blocks bundle since `common-first-streamable-block`.
* If available, it reads the last block from the previous merged-blocks bundle to get its ID.
* It polls the one-block store and validates the continuity of the chain. (at interval `merger-time-between-store-lookups`)
* When it has the full segment, it creates a new merged-blocks bundle.
* Any extraneous blocks are moved to the forked blocks store.
* If regularly checks the merged-blocks store to see if the bundle that it is attempting to write gets added (by someone else). If it happens, it will simply skip to the next missing one.
* It regularly deletes the one-block files that are left behind (between the `common-first-streamable-block` and the current bundle, at interval `merger-time-between-store-pruning`)
* It regularly deletes the forked blocks files older than `merger-prune-forked-blocks-after` blocks.

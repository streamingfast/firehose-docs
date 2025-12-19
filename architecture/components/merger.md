---
description: StreamingFast Firehose merger component
---

# Merger

## Merger Component in Detail

The Merger component is responsible for:
1. Polling and Reading "one-blocks store" for files written from the Reader component
2. Bundling finalized blocks into "merged blocks bundles"
3. Moving the forked blocks to the "forked-blocks store"

### Merged Blocks Bundles

The Merger produces "merged-blocks bundles", containing all the finalized blocks in a 100-blocks boundary.
The filename contains the lower boundary (ex: 0000010100.dbin.zst).
It may contain less than 100 blocks if that particular chain skips blocks

### One-blocks

The Merger component reads the one-block object store to produce the 100-blocks bundles.

### Forked blocks

The merger only merges finalized blocks. No forked block (also called uncled or reorg) make it into the merged blocks bundles, they are instead moved to the "forked-blocks-store"

### Merger Responsibilities

* Boot and try to start where it left off if a merged-seen.gob file is available.
* Boot and start the next bundle in the last merged-block in storage if there is _**not**_ a merged-seen.gob file available.
* Gather one-block-files and assemble them into a bundle. The bundle is written when the first blocks of the next bundle are older than 25 seconds or it contains at least one fully-linked segment of 100 blocks.
* Keep a list of all seen (merged) blocks in the last `{merger-max-fixable-fork}.` A "seen" block is a block that has been merged by the current Merger component or a Reader component.
* Delete one-blocks that are older than `{merger-max-fixable-fork}` or have already been seen (merged), and recorded in the `merged-seen.gob` file.
* Load missing blocks from storage if missing blocks or holes are encountered. The blocks in storage are loaded to fill the seen-blocks cache and the Merger component continues to the next bundle.
* Add any previously unaccounted-for one-block files to the subsequent bundle. For instance bundle 500 might include block 429 if it was previously missed during the merging process. Also, note that any blocks older than `{merger-max-fixable-fork}` will be deleted.

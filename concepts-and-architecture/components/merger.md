---
description: StreamingFast Firehose merger component
---

# Merger

### Merger

#### Merger Component in Detail

The Merger component is responsible for managing and shaping data flowing out of the Reader component.&#x20;

#### Blocks Files

The Merger component produces what are referred to as "100-blocks files." The Merger component receives "one-block" files from Reader components that are feeding the Merger.&#x20;

#### One-block Storage

The Merger component reads the one-block object store to produce the 100-blocks files.

#### Forks

All forks visited by a Reader component will also be merged by the Merger component.

#### Merging Blocks

The merged 100-blocks files will be created each time the Merger component receives one hundred blocks of data from its associated Reader component.&#x20;

#### Fork Data Awareness

The Merger component will produce the files when there are no additional forks that might occur. The StreamingFast bstream ForkableHandler provides support for fork data awareness in future merged blocks.

#### Merger Responsibilities

* Boot and try to start where it left off if a merged-seen.gob file is available.
* Boot and start the next bundle in the last merged-block in storage if there is _**not**_ a merged-seen.gob file available.
* Gather one-block-files and assemble them into a bundle. The bundle is written when the first blocks of the next bundle are older than 25 seconds or it contains at least one fully-linked segment of 100 blocks.
* Keep a list of all seen (merged) blocks in the last `{merger-max-fixable-fork}.` A "seen" block is a block that has been merged by the current Merger component or a Reader component.
* Delete one-blocks that are older than `{merger-max-fixable-fork}` or have already been seen (merged), and recorded in the `merged-seen.gob` file.
* Load missing blocks from storage if missing blocks or holes are encountered. The blocks in storage are loaded to fill the seen-blocks cache and the Merger component continues to the next bundle.
* Add any previously unaccounted-for one-block files to the subsequent bundle. For instance bundle 500 might include block 429 if it was previously missed during the merging process. Also, note that any blocks older than `{merger-max-fixable-fork}` will be deleted.

---
description: Firehose Protocol 3.x Specification Reference
---

# Firehose Protocol

The Firehose Protocol defines a line-based text protocol for streaming blockchain block data from an instrumented node to a Firehose reader process. This document specifies versions 3.0 and 3.1 of the protocol.

## Overview

The protocol operates over stdout/stderr, where the instrumented blockchain node emits specially formatted lines prefixed with `FIRE `. The Firehose reader process parses these lines to construct block objects that are then stored and served.

All protocol messages follow this general format:

```
FIRE <MESSAGE_TYPE> <FIELDS...>
```

## Protocol Versions

| Version | Description |
|---------|-------------|
| 3.0 | Standard protocol for tracer-based block extraction |
| 3.1 | Extends 3.0 with partial block support for large blocks |

## Message Types

The Firehose Protocol 3.x defines two message types:

| Message | Purpose |
|---------|---------|
| `INIT` | Initialization handshake establishing protocol version and block type |
| `BLOCK` | Complete or partial block data transmission |

---

## FIRE INIT

The `INIT` message must be the first Firehose message emitted by the node. It establishes the protocol version and declares the Protobuf message type used for block payloads.

### Format

```
FIRE INIT <version> <protobuf_type>
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `version` | string | Protocol version: `3.0` or `3.1` |
| `protobuf_type` | string | Fully qualified Protobuf message type for the block payload |

### Examples

```
FIRE INIT 3.0 sf.ethereum.type.v2.Block
FIRE INIT 3.1 sf.ethereum.type.v2.Block
FIRE INIT 3.0 sf.solana.type.v1.Block
```

### Behavior

- The reader validates the protocol version is supported
- The `protobuf_type` is used to construct the `type.googleapis.com/<protobuf_type>` URL in the Any wrapper
- For version 3.1, partial block parsing is enabled

---

## FIRE BLOCK

The `BLOCK` message transmits block data. The format differs slightly between versions 3.0 and 3.1.

### Version 3.0 Format

```
FIRE BLOCK <block_num> <block_hash> <parent_num> <parent_hash> <lib_num> <timestamp_unix_nano> <payload_base64>
```

**Field Count:** 7 fields after `FIRE BLOCK`

### Version 3.1 Format

```
FIRE BLOCK <block_num> <partial_idx> <block_hash> <parent_num> <parent_hash> <lib_num> <timestamp_unix_nano> <payload_base64>
```

**Field Count:** 8 fields after `FIRE BLOCK`

### Fields

| Field | Type | Version | Description |
|-------|------|---------|-------------|
| `block_num` | uint64 | 3.0, 3.1 | Block number/height |
| `partial_idx` | int64 | 3.1 only | Partial block index (see [Partial Blocks](#partial-blocks)) |
| `block_hash` | string | 3.0, 3.1 | Block identifier/hash |
| `parent_num` | uint64 | 3.0, 3.1 | Parent block number |
| `parent_hash` | string | 3.0, 3.1 | Parent block identifier/hash |
| `lib_num` | uint64 | 3.0, 3.1 | Last Irreversible Block number |
| `timestamp_unix_nano` | uint64 | 3.0, 3.1 | Block timestamp in Unix nanoseconds |
| `payload_base64` | string | 3.0, 3.1 | Base64-encoded Protobuf block payload |

### Block Hash Representation

The protocol does not mandate a specific string format for block hashes. However, **consistency is critical**:

- The chosen format (e.g., hexadecimal, base58, base64) must remain constant throughout the chain's lifetime
- Both `block_hash` and `parent_hash` must use the same encoding format
- The `parent_hash` of block N must exactly match the `block_hash` of block N-1

{% hint style="warning" %}
**Chain Continuity Requirement**

The Firehose system relies on parent hash linking to establish block continuity and detect forks. If `parent_hash` does not exactly match the previous block's `block_hash` (as a string), the reader will fail to establish the chain relationship.

This means:
- If using hex encoding, use it consistently (always lowercase or always uppercase)
- If using a prefix like `0x`, always include it
- Never change the encoding format after genesis
{% endhint %}

{% hint style="info" %}
**Recommendation for New Chains**

For new chain integrations, we strongly recommend using **lowercase hexadecimal without the `0x` prefix**:

```
abc123def456...  (recommended)
0xabc123def456...  (not recommended)
ABC123DEF456...  (not recommended)
```

This format is being considered as the canonical standard for future protocol versions. Adopting it now ensures forward compatibility and consistency across the Firehose ecosystem.
{% endhint %}

### Examples

**Version 3.0:**
```
FIRE BLOCK 12345678 abc123def456789012345678901234567890123456789012345678901234 12345677 789abcdef012345678901234567890123456789012345678901234567890 12345600 1699900000000000000 CgR0ZXN0...
```

**Version 3.1 (complete block):**
```
FIRE BLOCK 12345678 1000 abc123def456789012345678901234567890123456789012345678901234 12345677 789abcdef012345678901234567890123456789012345678901234567890 12345600 1699900000000000000 CgR0ZXN0...
```

**Version 3.1 (partial block, not final):**
```
FIRE BLOCK 12345678 0 abc123def456789012345678901234567890123456789012345678901234 12345677 789abcdef012345678901234567890123456789012345678901234567890 12345600 1699900000000000000 CgR0ZXN0...
FIRE BLOCK 12345678 1 abc123def456789012345678901234567890123456789012345678901234 12345677 789abcdef012345678901234567890123456789012345678901234567890 12345600 1699900000000000000 CgR0ZXN0...
```

---

## Partial Blocks

Protocol version 3.1 introduces support for partial blocks, enabling transmission of large blocks in multiple chunks.

### Partial Index Encoding

The `partial_idx` field uses a special encoding:

| Value | Meaning |
|-------|---------|
| `0` to `999` | Partial block chunk at index N, more chunks to follow |
| `1000` to `1999` | Final partial block chunk at index (N - 1000) |

### Examples

| `partial_idx` | Actual Index | Is Final |
|---------------|--------------|----------|
| `0` | 0 | No |
| `1` | 1 | No |
| `5` | 5 | No |
| `1000` | 0 | Yes (single complete block) |
| `1001` | 1 | Yes (2 partials, this is last) |
| `1005` | 5 | Yes (6 partials, this is last) |

### Behavior

1. When `partial_idx < 1000`: Reader accumulates the partial payload, expecting more
2. When `partial_idx >= 1000`: Reader treats this as the final chunk and assembles the complete block
3. A value of `1000` indicates a single complete block (equivalent to version 3.0 behavior)

---

## Payload Format

The `payload_base64` field contains a Base64-encoded Protobuf message. The message type is declared in the `FIRE INIT` message.

### Wrapping

The decoded payload is wrapped in a `google.protobuf.Any` message:

```protobuf
message Any {
  string type_url = 1;  // "type.googleapis.com/<protobuf_type>"
  bytes value = 2;      // The decoded payload bytes
}
```

### Block Container

The Any-wrapped payload is then placed in a `sf.bstream.v1.Block` container:

```protobuf
message Block {
  string id = 1;           // block_hash
  uint64 number = 2;       // block_num
  string parent_id = 3;    // parent_hash
  uint64 parent_num = 4;   // parent_num
  uint64 lib_num = 5;      // lib_num
  Timestamp timestamp = 6; // Converted from timestamp_unix_nano
  Any payload = 7;         // The wrapped block payload
}
```

---

## Error Handling

### Invalid Protocol Version

If the `FIRE INIT` message specifies an unsupported version, the reader should terminate with an error indicating the supported versions.

### Malformed Messages

Lines that:
- Don't start with `FIRE `
- Have incorrect field counts
- Contain unparseable numeric values
- Have invalid Base64 encoding

Should be logged and typically cause the reader to terminate, as they indicate a protocol mismatch or corrupted output.

### Missing INIT

If a `FIRE BLOCK` message is received before `FIRE INIT`, the reader should terminate with an error.

---

## Implementation Notes

### Line Parsing

1. Check line starts with `FIRE ` prefix
2. Extract message type (`INIT` or `BLOCK`)
3. Split remaining content by spaces with bounded chunks (last field accumulates all remaining content)
4. Parse fields according to their expected types

### Numeric Parsing

- All numeric fields use base-10 representation
- `block_num`, `parent_num`, `lib_num`, `timestamp_unix_nano`: Parse as unsigned 64-bit integers
- `partial_idx`: Parse as signed 64-bit integer

### Base64 Decoding

- Use standard Base64 encoding (RFC 4648)
- The decoded bytes are the raw Protobuf message (not Any-wrapped at this stage)

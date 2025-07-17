---
description: Template for integrating new blockchain networks with Firehose
---

# Integration Template

## Overview

This template provides a structured approach for integrating new blockchain networks with Firehose. Follow this guide to ensure your integration follows best practices and is consistent with existing implementations.

## Prerequisites

Before starting a new chain integration:

- **Blockchain expertise**: Deep understanding of the target blockchain
- **Go programming**: Firehose is written in Go
- **Protocol buffers**: Used for data serialization
- **gRPC**: Used for service communication
- **Firehose architecture**: Understanding of core components

## Integration Checklist

### Phase 1: Planning and Setup

- [ ] **Research blockchain architecture**
  - Block structure and format
  - Transaction types and fields
  - Consensus mechanism
  - Node software and APIs
  
- [ ] **Define integration scope**
  - Which node implementations to support
  - Required block data to extract
  - Performance requirements
  - Storage considerations

- [ ] **Set up development environment**
  - Clone firehose-core repository
  - Set up blockchain node for testing
  - Prepare test data and scenarios

### Phase 2: Core Implementation

- [ ] **Define protobuf schemas**
  - Block structure definition
  - Transaction format
  - Event/log structures
  - Chain-specific metadata

- [ ] **Implement block reader**
  - Node connection logic
  - Block extraction mechanism
  - Data transformation
  - Error handling

- [ ] **Create chain configuration**
  - Genesis block handling
  - Network parameters
  - Validation rules
  - Feature flags

### Phase 3: Testing and Validation

- [ ] **Unit tests**
  - Block parsing logic
  - Data transformation
  - Edge cases and error conditions
  - Performance benchmarks

- [ ] **Integration tests**
  - End-to-end block streaming
  - Component interaction
  - Storage operations
  - gRPC API functionality

- [ ] **Testnet validation**
  - Deploy on testnet
  - Verify data accuracy
  - Performance testing
  - Stress testing

### Phase 4: Documentation and Release

- [ ] **Create documentation**
  - Chain-specific setup guide
  - Configuration examples
  - Troubleshooting guide
  - Performance characteristics

- [ ] **Prepare release**
  - Binary builds
  - Release notes
  - Migration guides
  - Community announcement

## File Structure

Create the following directory structure for your integration:

```
firehose-<chain>/
├── cmd/
│   └── fire<chain>/
│       └── main.go
├── proto/
│   └── sf/
│       └── <chain>/
│           └── type/
│               └── v1/
│                   └── type.proto
├── types/
│   ├── block.go
│   ├── transaction.go
│   └── codec.go
├── reader/
│   ├── node_reader.go
│   └── block_mapper.go
├── devel/
│   ├── standard/
│   │   ├── standard.yaml
│   │   └── start.sh
│   └── docker/
│       └── Dockerfile
├── docs/
│   ├── README.md
│   ├── setup.md
│   └── troubleshooting.md
└── README.md
```

## Implementation Guide

### 1. Define Protobuf Schema

Create the block structure definition:

```protobuf
// proto/sf/<chain>/type/v1/type.proto
syntax = "proto3";

package sf.<chain>.type.v1;

message Block {
  string id = 1;
  uint64 number = 2;
  string parent_id = 3;
  google.protobuf.Timestamp timestamp = 4;
  repeated Transaction transactions = 5;
  // Chain-specific fields...
}

message Transaction {
  string id = 1;
  string from = 2;
  string to = 3;
  // Chain-specific fields...
}
```

### 2. Implement Block Reader

Create the node reader implementation:

```go
// reader/node_reader.go
package reader

import (
    "context"
    "github.com/streamingfast/firehose-core/reader"
)

type NodeReader struct {
    // Node connection details
    nodeURL string
    client  NodeClient
}

func (r *NodeReader) ReadBlock(ctx context.Context, blockNum uint64) (*Block, error) {
    // Implement block reading logic
    rawBlock, err := r.client.GetBlock(blockNum)
    if err != nil {
        return nil, err
    }
    
    // Transform to Firehose block format
    return r.transformBlock(rawBlock)
}
```

### 3. Create Chain Configuration

Define chain-specific parameters:

```go
// chain.go
package main

import (
    firecore "github.com/streamingfast/firehose-core"
)

func init() {
    Chain = &firecore.Chain[*Block]{
        ShortName:            "<chain>",
        LongName:             "<Chain Name>",
        ExecutableName:       "fire<chain>",
        FullyQualifiedModule: "github.com/streamingfast/firehose-<chain>",
        Version:              version,
        
        FirstStreamableBlock: 1,
        BlockFactory:         func() *Block { return &Block{} },
        ConsoleReaderFactory: NewConsoleReader,
        
        // Chain-specific configuration...
    }
}
```

### 4. Implement Console Reader

Create the console reader for extracting data from node logs:

```go
// console_reader.go
func NewConsoleReader(lines chan string, blockEncoder firecore.BlockEncoder, logger *zap.Logger, tracer logging.Tracer) (firecore.ConsolerReader, error) {
    return &ConsoleReader{
        lines:        lines,
        blockEncoder: blockEncoder,
        logger:       logger,
        tracer:       tracer,
    }, nil
}

func (r *ConsoleReader) ReadBlock() (out *firecore.Block, err error) {
    // Parse node output and extract block data
    // Transform to Firehose format
    // Return structured block
}
```

### 5. Add Tools and Utilities

Implement chain-specific tools:

```go
// tools/tools.go
func init() {
    tools.Register("check-<chain>-node", &cobra.Command{
        Use:   "check-<chain>-node",
        Short: "Check <chain> node connectivity and status",
        RunE:  checkNodeCmd,
    })
}
```

## Testing Strategy

### Unit Tests

Test individual components:

```go
func TestBlockTransformation(t *testing.T) {
    rawBlock := &RawBlock{
        // Test data
    }
    
    block, err := transformBlock(rawBlock)
    require.NoError(t, err)
    assert.Equal(t, expectedBlock, block)
}
```

### Integration Tests

Test full pipeline:

```go
func TestEndToEndStreaming(t *testing.T) {
    // Set up test environment
    // Start components
    // Stream blocks
    // Verify output
}
```

## Configuration Examples

### Basic Configuration

```yaml
# <chain>-firehose.yaml
start:
  args:
    - reader-node
  flags:
    data-dir: /var/firehose-data
    reader-node-path: /usr/local/bin/<chain>-node
    reader-node-arguments: "--config=/etc/<chain>/config.toml"
    common-one-block-store-url: file:///var/firehose-data/one-blocks
    common-merged-blocks-store-url: file:///var/firehose-data/merged-blocks
```

### Production Configuration

```yaml
# production-<chain>.yaml
start:
  args:
    - reader-node
  flags:
    data-dir: /var/firehose-data
    reader-node-path: /usr/local/bin/<chain>-node
    reader-node-arguments: "--config=/etc/<chain>/config.toml --archive"
    common-one-block-store-url: gs://my-bucket/one-blocks
    common-merged-blocks-store-url: gs://my-bucket/merged-blocks
    metrics-listen-addr: :9102
    log-format: stackdriver
```

## Performance Considerations

### Optimization Areas

1. **Block Processing Speed**
   - Parallel processing where possible
   - Efficient data structures
   - Minimal memory allocations

2. **Storage Efficiency**
   - Compact binary formats
   - Compression strategies
   - Optimal file sizes

3. **Network Usage**
   - Connection pooling
   - Request batching
   - Error retry strategies

### Benchmarking

Create performance benchmarks:

```go
func BenchmarkBlockProcessing(b *testing.B) {
    for i := 0; i < b.N; i++ {
        processBlock(testBlock)
    }
}
```

## Documentation Requirements

### README.md

Include:
- Overview and features
- Installation instructions
- Quick start guide
- Configuration examples
- Troubleshooting tips

### Setup Guide

Provide:
- Detailed installation steps
- Node configuration
- Firehose configuration
- Production deployment

### API Documentation

Document:
- Block structure
- Available fields
- gRPC endpoints
- Example queries

## Community Guidelines

### Code Quality

- Follow Go best practices
- Include comprehensive tests
- Document public APIs
- Use consistent naming

### Contribution Process

1. Fork the repository
2. Create feature branch
3. Implement changes
4. Add tests and documentation
5. Submit pull request
6. Address review feedback

### Support Channels

- **GitHub Issues**: Bug reports and feature requests
- **Discord**: Community discussion and support
- **Documentation**: Maintain up-to-date guides

## Next Steps

1. **Study existing implementations**: Review firehose-ethereum and firehose-solana
2. **Start with basics**: Implement minimal block reading functionality
3. **Iterate and improve**: Add features incrementally
4. **Engage community**: Share progress and get feedback
5. **Prepare for production**: Thorough testing and documentation

## Resources

- **[Firehose Core](https://github.com/streamingfast/firehose-core)**: Base framework
- **[Firehose Ethereum](https://github.com/streamingfast/firehose-ethereum)**: Reference implementation
- **[Firehose Acme](../firehose-starter.md)**: Starter template
- **[Design Principles](design-principles.md)**: Architecture guidelines
- **[StreamingFast Discord](https://discord.gg/jZwqxJAvRs)**: Community support

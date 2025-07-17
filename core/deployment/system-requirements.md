---
description: System requirements for running Firehose in production
---

# System Requirements

## Overview

This document outlines the hardware, software, and infrastructure requirements for running Firehose in production environments. Requirements vary significantly based on the blockchain network and expected usage patterns.

## Minimum Requirements

### Hardware
- **CPU**: 4 cores (2.5GHz+)
- **Memory**: 8GB RAM
- **Storage**: 500GB SSD
- **Network**: 100Mbps bandwidth

### Software
- **Operating System**: Linux (Ubuntu 20.04+ or CentOS 8+)
- **Go Runtime**: Go 1.19+ (for building from source)
- **Docker**: 20.10+ (for containerized deployments)

## Recommended Production Requirements

### High-Volume Chains (Ethereum, Solana)

#### Hardware
- **CPU**: 16+ cores (3.0GHz+)
- **Memory**: 64GB RAM
- **Storage**: 2TB+ NVMe SSD
- **Network**: 1Gbps+ bandwidth

#### Infrastructure
- **Load Balancer**: For gRPC endpoint distribution
- **Monitoring**: Prometheus + Grafana
- **Logging**: Centralized log aggregation
- **Backup**: Automated storage backup

### Medium-Volume Chains (NEAR, Cosmos)

#### Hardware
- **CPU**: 8 cores (2.8GHz+)
- **Memory**: 32GB RAM
- **Storage**: 1TB SSD
- **Network**: 500Mbps bandwidth

### Low-Volume Chains (Most Cosmos chains)

#### Hardware
- **CPU**: 4 cores (2.5GHz+)
- **Memory**: 16GB RAM
- **Storage**: 500GB SSD
- **Network**: 200Mbps bandwidth

## Storage Requirements by Component

### Reader Node
- **Purpose**: Temporary block processing
- **Size**: 10-50GB
- **Type**: Fast SSD required
- **Growth**: Minimal (circular buffer)

### One-Block Store
- **Purpose**: Individual block files
- **Size**: 1-10GB/day (varies by chain)
- **Type**: SSD recommended
- **Growth**: Linear with chain activity

### Merged-Block Store
- **Purpose**: Consolidated block files
- **Size**: 10-500GB/month (varies by chain)
- **Type**: Can use slower storage
- **Growth**: Primary storage requirement

### Index Store (if enabled)
- **Purpose**: Block indexes for fast lookup
- **Size**: 1-10% of merged blocks
- **Type**: SSD recommended
- **Growth**: Proportional to merged blocks

## Network Requirements

### Bandwidth
- **Inbound**: Blockchain node synchronization
- **Outbound**: gRPC client connections
- **Internal**: Component communication

### Latency
- **Storage**: <10ms for optimal performance
- **Network**: <100ms to blockchain network
- **Client**: <500ms for real-time streaming

### Ports
- **9102**: Prometheus metrics (configurable)
- **6060**: pprof debugging (configurable)
- **13042**: Firehose gRPC (configurable)
- **13010**: Reader node gRPC (configurable)
- **1065**: Log level switcher (configurable)

## Performance Scaling

### Vertical Scaling
- **CPU**: More cores improve parallel processing
- **Memory**: Reduces I/O wait times
- **Storage**: Faster storage improves throughput
- **Network**: Higher bandwidth supports more clients

### Horizontal Scaling
- **Multiple Readers**: Increase data ingestion capacity
- **Load Balancing**: Distribute client connections
- **Storage Sharding**: Distribute storage load
- **Geographic Distribution**: Reduce client latency

## Cloud Provider Recommendations

### AWS
- **Compute**: c5.4xlarge or larger
- **Storage**: EBS gp3 with provisioned IOPS
- **Network**: Enhanced networking enabled
- **Services**: ELB, CloudWatch, S3

### Google Cloud
- **Compute**: n2-standard-16 or larger
- **Storage**: SSD persistent disks
- **Network**: Premium tier networking
- **Services**: Load Balancer, Monitoring, Cloud Storage

### Azure
- **Compute**: Standard_D16s_v3 or larger
- **Storage**: Premium SSD managed disks
- **Network**: Accelerated networking
- **Services**: Load Balancer, Monitor, Blob Storage

## Monitoring Requirements

### System Metrics
- CPU utilization and load average
- Memory usage and swap activity
- Disk I/O and space utilization
- Network throughput and connections

### Application Metrics
- Block processing rate
- Component health status
- gRPC request latency
- Storage operation performance

### Alerting Thresholds
- **CPU**: >80% sustained usage
- **Memory**: >90% utilization
- **Disk**: >85% space used
- **Network**: >80% bandwidth used

## Security Requirements

### Network Security
- Firewall rules for required ports only
- VPN or private networks for internal communication
- TLS encryption for external connections
- DDoS protection for public endpoints

### Access Control
- Service accounts for cloud storage
- Role-based access for administrative functions
- API authentication for gRPC endpoints
- Audit logging for security events

### Data Protection
- Encryption at rest for sensitive data
- Secure key management
- Regular security updates
- Backup encryption

## Disaster Recovery

### Backup Strategy
- **Configuration**: Version controlled configs
- **Data**: Regular storage backups
- **Monitoring**: Backup verification
- **Testing**: Regular restore testing

### Recovery Procedures
- **Component Failure**: Automatic restart/failover
- **Data Corruption**: Restore from backup
- **Infrastructure Failure**: Multi-region deployment
- **Network Partition**: Graceful degradation

## Cost Optimization

### Storage Optimization
- Use appropriate storage tiers
- Implement data lifecycle policies
- Compress historical data
- Archive old blocks

### Compute Optimization
- Right-size instances for workload
- Use spot instances where appropriate
- Implement auto-scaling
- Monitor resource utilization

### Network Optimization
- Use CDN for static content
- Optimize data transfer patterns
- Implement connection pooling
- Monitor bandwidth usage

## Capacity Planning

### Growth Projections
- **Storage**: Plan for 12-24 months growth
- **Compute**: Monitor utilization trends
- **Network**: Account for client growth
- **Costs**: Budget for scaling needs

### Scaling Triggers
- **Storage**: 70% utilization
- **CPU**: 60% sustained usage
- **Memory**: 75% utilization
- **Network**: 50% bandwidth used

## Testing and Validation

### Performance Testing
- Load testing with realistic workloads
- Stress testing at capacity limits
- Endurance testing for stability
- Failover testing for reliability

### Monitoring Validation
- Verify all metrics are collected
- Test alerting thresholds
- Validate dashboard accuracy
- Confirm log aggregation

## Next Steps

1. **Assess current infrastructure** against these requirements
2. **Plan capacity** based on your blockchain and usage
3. **Implement monitoring** before going to production
4. **Test thoroughly** with realistic workloads
5. **Document procedures** for operations team

## Resources

- **[Infrastructure Setup](infrastructure.md)**: Detailed setup guides
- **[Production Deployment](production.md)**: Production best practices
- **[Monitoring & Observability](monitoring.md)**: Monitoring setup
- **[Troubleshooting](troubleshooting.md)**: Common issues and solutions

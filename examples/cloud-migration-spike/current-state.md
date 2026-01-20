# Current State Inventory

## Data Center Overview

**Location**: Equinix NY5, Secaucus NJ
**Lease Expiration**: June 30, 2025
**Cabinet Space**: 4 cabinets (42U each)
**Power**: 2x 30A circuits per cabinet
**Connectivity**: 10 Gbps primary, 2 Gbps backup

## Compute Infrastructure

### Application Servers (8 servers)

| Server | Specs | Function | Utilization |
|--------|-------|----------|-------------|
| app-01 | 32 CPU, 128GB RAM | API servers (3 instances) | 45% |
| app-02 | 32 CPU, 128GB RAM | API servers (3 instances) | 42% |
| app-03 | 32 CPU, 128GB RAM | Web frontend (2 instances) | 35% |
| app-04 | 32 CPU, 128GB RAM | Web frontend (2 instances) | 38% |
| app-05 | 16 CPU, 64GB RAM | Background workers | 60% |
| app-06 | 16 CPU, 64GB RAM | Background workers | 55% |
| app-07 | 8 CPU, 32GB RAM | Internal tools | 25% |
| app-08 | 8 CPU, 32GB RAM | Monitoring/logging | 40% |

**Total**: 168 CPU cores, 640 GB RAM

### Database Servers (3 servers)

| Server | Specs | Database | Size | Notes |
|--------|-------|----------|------|-------|
| db-01 | 64 CPU, 512GB RAM, 20TB SSD | PostgreSQL (primary) | 8 TB | Main transactional |
| db-02 | 64 CPU, 512GB RAM, 20TB SSD | PostgreSQL (replica) | 8 TB | Read replica |
| db-03 | 32 CPU, 256GB RAM, 10TB SSD | MongoDB | 4 TB | Document store |

### Cache/Queue Servers (1 server)

| Server | Specs | Services | Notes |
|--------|-------|----------|-------|
| cache-01 | 16 CPU, 128GB RAM | Redis cluster, RabbitMQ | Memory-intensive |

## Storage Infrastructure

### Primary Storage (NetApp FAS8200)

| Volume | Size | Type | Usage |
|--------|------|------|-------|
| prod-data | 50 TB | SSD | Active application data |
| prod-media | 250 TB | HDD | User uploads, media |
| backups | 100 TB | HDD | Daily backups (30 days) |

### Archive Storage (Dell EMC Isilon)

| Cluster | Size | Type | Usage |
|---------|------|------|-------|
| archive-01 | 1.8 PB | HDD | Cold storage, compliance |

**Total Storage**: 2.2 PB (300 TB hot, 1.9 PB cold)

## Network Infrastructure

### Internet Connectivity

| Provider | Bandwidth | Purpose |
|----------|-----------|---------|
| Cogent | 10 Gbps | Primary |
| Zayo | 2 Gbps | Backup/burst |

### Internal Network

- Core switches: Cisco Nexus 9000 (2x, HA pair)
- ToR switches: Cisco Catalyst 9300 (8x)
- Firewall: Palo Alto PA-5220 (2x, HA pair)
- Load balancer: F5 BIG-IP i5800 (2x, HA pair)

### Network Topology

```
Internet
    │
    ▼
┌─────────┐
│  BGP    │
│ Router  │
└────┬────┘
     │
┌────┴────┐
│Firewall │
│  (HA)   │
└────┬────┘
     │
┌────┴────┐      ┌─────────┐
│  Core   │──────│   F5    │
│ Switch  │      │   LB    │
└────┬────┘      └────┬────┘
     │                │
┌────┴────────────────┴────┐
│       ToR Switches       │
│   (app, db, storage)     │
└──────────────────────────┘
```

## Software Inventory

### Operating Systems

| OS | Count | Version |
|----|-------|---------|
| Ubuntu | 10 | 20.04 LTS |
| CentOS | 2 | 7.9 |

### Application Stack

| Component | Version | Notes |
|-----------|---------|-------|
| Python | 3.9 | Primary language |
| Django | 3.2 | Web framework |
| Celery | 5.2 | Task queue |
| Gunicorn | 20.1 | WSGI server |
| Nginx | 1.18 | Reverse proxy |

### Databases

| Database | Version | Size | Connections |
|----------|---------|------|-------------|
| PostgreSQL | 13.4 | 8 TB | 500 max |
| MongoDB | 5.0 | 4 TB | 200 max |
| Redis | 6.2 | 50 GB | 1000 max |

### External Integrations

| Service | Protocol | Network |
|---------|----------|---------|
| Payment processor (legacy) | REST/VPN | Site-to-site VPN |
| Email (SendGrid) | HTTPS | Internet |
| SMS (Twilio) | HTTPS | Internet |
| Analytics (Segment) | HTTPS | Internet |
| CDN (Cloudflare) | HTTPS | Internet |

## Traffic Patterns

### Request Volume

| Metric | Value |
|--------|-------|
| Peak requests/sec | 15,000 |
| Average requests/sec | 5,000 |
| Daily requests | 400 million |
| Monthly data transfer | 50 TB |

### Traffic Distribution

| Time (EST) | % of Daily Traffic |
|------------|-------------------|
| 00:00-06:00 | 8% |
| 06:00-12:00 | 28% |
| 12:00-18:00 | 38% |
| 18:00-24:00 | 26% |

### Seasonality

- Peak: November-December (holiday, 2x normal)
- Low: January-February (0.7x normal)

## Compliance Requirements

| Requirement | Scope | Notes |
|-------------|-------|-------|
| HIPAA | User health data | BAA required |
| SOC 2 Type II | All systems | Annual audit |
| PCI DSS | Payment flow | Level 2 merchant |
| GDPR | EU user data | Data residency options |

## Current Pain Points

1. **Capacity ceiling**: Can't easily add servers
2. **Long provisioning**: 6-8 weeks for new hardware
3. **Single region**: No geographic redundancy
4. **Manual scaling**: No elasticity for traffic spikes
5. **Aging hardware**: 3 servers past warranty
6. **Skills gap**: Team stretched thin on hardware ops

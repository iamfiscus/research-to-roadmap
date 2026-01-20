# Proposed Cache Architecture

## Overview

```
                        ┌─────────────────────────────────────┐
                        │           Application               │
                        └─────────────┬───────────────────────┘
                                      │
                    ┌─────────────────┴─────────────────┐
                    │                                   │
                    ▼                                   ▼
         ┌─────────────────┐                 ┌─────────────────┐
         │  Redis Cluster  │                 │Memcached Cluster│
         │   (Sessions)    │                 │  (API Cache)    │
         └────────┬────────┘                 └────────┬────────┘
                  │                                   │
    ┌─────────────┼─────────────┐       ┌────────────┼────────────┐
    │             │             │       │            │            │
    ▼             ▼             ▼       ▼            ▼            ▼
┌───────┐   ┌───────┐   ┌───────┐   ┌───────┐  ┌───────┐  ┌───────┐
│Primary│   │Replica│   │Replica│   │Node 1 │  │Node 2 │  │Node 3 │
│ AZ-a  │   │ AZ-b  │   │ AZ-c  │   │ AZ-a  │  │ AZ-b  │  │ AZ-c  │
└───────┘   └───────┘   └───────┘   └───────┘  └───────┘  └───────┘
```

## Redis Cluster (Sessions)

### Configuration

| Setting | Value | Rationale |
|---------|-------|-----------|
| Node type | r6g.large | 13GB RAM, sufficient for 5M sessions |
| Nodes | 1 primary + 2 replicas | HA across 3 AZs |
| Persistence | AOF everysec | Acceptable 1s data loss |
| Eviction | noeviction | Sessions should not be evicted |
| Max memory | 10GB | Leave headroom for fragmentation |

### Data Model

```
Session key: session:{session_id}
Session TTL: 7 days
Session size: ~2KB

Example:
KEY: session:abc123def456
VALUE: {
  "user_id": "user-789",
  "created_at": "2024-01-15T10:30:00Z",
  "last_activity": "2024-01-15T14:45:00Z",
  "ip": "192.168.1.100",
  "user_agent": "Mozilla/5.0...",
  "permissions": ["read", "write"],
  "metadata": {...}
}
TTL: 604800 (7 days)
```

### Capacity Planning

| Metric | Current | Year 1 | Year 2 |
|--------|---------|--------|--------|
| Active sessions | 500K | 1.5M | 3M |
| Memory needed | 1GB | 3GB | 6GB |
| Ops/sec | 5K | 15K | 30K |

**Verdict**: r6g.large (13GB) sufficient for 2+ years

### Failover Strategy

1. ElastiCache automatic failover enabled
2. Replica promoted in 15-30 seconds
3. Application uses cluster endpoint (auto-updates)
4. Brief connection errors during failover (retry logic required)

## Memcached Cluster (API Cache)

### Configuration

| Setting | Value | Rationale |
|---------|-------|-----------|
| Node type | r6g.large | 13GB RAM per node |
| Nodes | 3 | Distributed across AZs |
| Max memory | 12GB per node | 36GB total |
| Eviction | LRU | Automatically evict stale data |

### Data Model

```
Cache key pattern: api:{service}:{endpoint}:{hash(params)}
Cache TTL: Varies by endpoint (60s - 3600s)

Examples:
KEY: api:products:list:a1b2c3d4
VALUE: {"products": [...], "total": 150}
TTL: 300 (5 minutes)

KEY: api:users:profile:user-789
VALUE: {"id": "user-789", "name": "John", ...}
TTL: 60 (1 minute)
```

### Cache Invalidation Strategy

**Option A: TTL-based (Recommended for v1)**
- Set appropriate TTL per endpoint
- Accept staleness within TTL window
- Simple, no coordination needed

**Option B: Event-based (Future)**
- Publish invalidation events to Redis pub/sub
- Subscribers delete relevant Memcached keys
- More complex but fresher data

### Capacity Planning

| Metric | Current | Year 1 | Year 2 |
|--------|---------|--------|--------|
| Cached objects | 2M | 6M | 12M |
| Memory needed | 10GB | 30GB | 60GB |
| Ops/sec | 20K | 60K | 120K |

**Verdict**: Start with 3x r6g.large (36GB), scale to r6g.xlarge if needed

## Client Configuration

### Python (redis-py + pymemcache)

```python
# Redis (sessions)
from redis.cluster import RedisCluster

redis = RedisCluster(
    host="redis-cluster.abc123.use1.cache.amazonaws.com",
    port=6379,
    decode_responses=True,
    socket_timeout=0.5,
    socket_connect_timeout=0.5,
    retry_on_timeout=True
)

# Memcached (API cache)
from pymemcache.client.hash import HashClient

memcached = HashClient(
    [
        ("mc-node1.abc123.use1.cache.amazonaws.com", 11211),
        ("mc-node2.abc123.use1.cache.amazonaws.com", 11211),
        ("mc-node3.abc123.use1.cache.amazonaws.com", 11211),
    ],
    connect_timeout=0.5,
    timeout=0.5,
    use_pooling=True,
    max_pool_size=10
)
```

### Connection Pooling

| Service | Pool Size | Rationale |
|---------|-----------|-----------|
| Redis | 10 per pod | ~50 pods = 500 connections |
| Memcached | 10 per pod | Same |

ElastiCache supports 65,000 connections, sufficient headroom.

## Monitoring

### Key Metrics

| Metric | Warning | Critical |
|--------|---------|----------|
| CPU utilization | >60% | >80% |
| Memory utilization | >70% | >85% |
| Cache hit rate | <80% | <60% |
| Evictions/min | >100 | >1000 |
| Connection count | >50K | >60K |
| Replication lag (Redis) | >1s | >5s |

### CloudWatch Alarms

```yaml
Alarms:
  - Name: redis-cpu-high
    Metric: CPUUtilization
    Threshold: 80%
    Period: 5 minutes
    Action: SNS → PagerDuty

  - Name: memcached-evictions
    Metric: Evictions
    Threshold: 1000/min
    Period: 5 minutes
    Action: SNS → Slack

  - Name: redis-memory-high
    Metric: DatabaseMemoryUsagePercentage
    Threshold: 85%
    Period: 5 minutes
    Action: SNS → PagerDuty
```

## Security

### Network

- Both clusters in private subnets
- Security group allows only application pods
- No public IP or internet access
- VPC endpoints for AWS API calls

### Encryption

| Type | Redis | Memcached |
|------|-------|-----------|
| In-transit | TLS 1.2 | TLS 1.2 |
| At-rest | AES-256 | AES-256 |

### Authentication

- Redis: AUTH token (stored in Secrets Manager)
- Memcached: No native auth (network isolation only)

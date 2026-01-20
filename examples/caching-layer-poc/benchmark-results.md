# Benchmark Results

## Test Configuration

**Hardware**:
- Client: c5.xlarge (4 vCPU, 8GB RAM)
- Redis: r6g.large cluster (3 nodes, 13GB each)
- Memcached: r6g.large cluster (3 nodes, 13GB each)

**Network**: Same VPC, same AZ (<1ms network latency)

**Tools**:
- redis-benchmark (Redis native)
- memtier_benchmark (both)
- Custom Python scripts (realistic workloads)

## Synthetic Benchmarks

### Single-Key Operations

| Operation | Redis (ms) | Memcached (ms) | Winner |
|-----------|------------|----------------|--------|
| GET (100 bytes) | 0.08 | 0.06 | Memcached |
| GET (1 KB) | 0.12 | 0.08 | Memcached |
| GET (10 KB) | 0.45 | 0.32 | Memcached |
| GET (100 KB) | 3.2 | 2.8 | Memcached |
| SET (1 KB) | 0.15 | 0.10 | Memcached |
| SET (10 KB) | 0.52 | 0.38 | Memcached |
| DELETE | 0.09 | 0.07 | Memcached |

### Multi-Key Operations

| Operation | Redis (ms) | Memcached (ms) | Winner |
|-----------|------------|----------------|--------|
| MGET (10 keys, 1KB each) | 0.35 | 0.28 | Memcached |
| MGET (100 keys, 1KB each) | 2.1 | 1.4 | Memcached |
| MSET (10 keys) | 0.42 | 0.32 | Memcached |

### Throughput (requests/second)

| Threads | Redis | Memcached |
|---------|-------|-----------|
| 1 | 45,000 | 52,000 |
| 4 | 165,000 | 195,000 |
| 8 | 285,000 | 340,000 |
| 16 | 380,000 | 450,000 |

### Latency Distribution (GET 1KB, 8 threads)

| Percentile | Redis | Memcached |
|------------|-------|-----------|
| p50 | 0.11ms | 0.08ms |
| p90 | 0.18ms | 0.14ms |
| p99 | 0.35ms | 0.28ms |
| p99.9 | 1.2ms | 0.9ms |

## Realistic Workload Benchmarks

### Session Store Simulation

Workload: 80% reads, 20% writes, 2KB session objects
Concurrent users: 10,000

| Metric | Redis | Memcached |
|--------|-------|-----------|
| Avg latency | 0.18ms | 0.14ms |
| p99 latency | 0.52ms | 0.41ms |
| Throughput | 125K ops/sec | 148K ops/sec |
| Memory efficiency | 2.1 KB/session | 2.0 KB/session |

### API Cache Simulation

Workload: 95% reads, 5% writes, mixed sizes (100B - 50KB)
Cache hit rate: 85%

| Metric | Redis | Memcached |
|--------|-------|-----------|
| Avg latency | 0.25ms | 0.19ms |
| p99 latency | 0.85ms | 0.65ms |
| Throughput | 95K ops/sec | 112K ops/sec |

## Redis-Specific Features

### Persistence Impact

| Mode | Write Latency | Data Safety |
|------|--------------|-------------|
| No persistence | 0.15ms | None |
| RDB (every 60s) | 0.16ms | Up to 60s loss |
| AOF (everysec) | 0.22ms | Up to 1s loss |
| AOF (always) | 0.85ms | No loss |

**Recommendation**: AOF everysec for sessions (acceptable 1s loss window)

### Pub/Sub Performance

| Subscribers | Message Latency | Throughput |
|-------------|-----------------|------------|
| 10 | 0.3ms | 85K msg/sec |
| 100 | 0.8ms | 42K msg/sec |
| 1,000 | 3.2ms | 12K msg/sec |

Sufficient for cache invalidation use case.

### Sorted Set Operations (Leaderboards)

| Operation | Latency |
|-----------|---------|
| ZADD (add score) | 0.12ms |
| ZRANK (get rank) | 0.08ms |
| ZRANGE (top 100) | 0.35ms |

## Memory Analysis

### Memory Overhead

| Data Type | Redis Overhead | Memcached Overhead |
|-----------|----------------|-------------------|
| String (1KB) | ~70 bytes | ~50 bytes |
| String (10KB) | ~70 bytes | ~50 bytes |
| Hash (10 fields) | ~200 bytes | N/A |
| Set (100 members) | ~400 bytes | N/A |

### Memory Fragmentation

After 24 hours of continuous load:

| Metric | Redis | Memcached |
|--------|-------|-----------|
| Memory used | 8.2 GB | 7.8 GB |
| Fragmentation ratio | 1.08 | 1.02 |
| Evictions | 0 | 0 |

## Failure Scenarios

### Node Failure Recovery

| Scenario | Redis | Memcached |
|----------|-------|-----------|
| Primary failure | 15-30s (failover) | Immediate (re-hash) |
| Data loss | None (replica) | Lost keys on failed node |
| Client impact | Brief errors | Transparent |

### Network Partition

| Scenario | Redis | Memcached |
|----------|-------|-----------|
| Split brain | Prevented (quorum) | Not applicable |
| Reads during partition | May fail | Continue (partial) |

## Conclusions

1. **Memcached is faster** for simple key-value operations (~30%)
2. **Redis has better features** (persistence, pub/sub, data structures)
3. **Both handle our load** with significant headroom
4. **Redis failover is cleaner** for session data (no data loss)
5. **Memcached failure is transparent** but loses data

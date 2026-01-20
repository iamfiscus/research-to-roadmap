# Caching Layer POC

**Duration**: 2 weeks (Dec 4-15, 2023)
**Team**: David Kim (Lead), Rachel Torres
**Status**: Complete

## Objective

Evaluate Redis vs Memcached for two use cases:
1. **Session storage** - User authentication sessions
2. **API response caching** - Frequently accessed data

## Background

Current state:
- Sessions stored in PostgreSQL (causing 200ms+ login latency)
- No API caching (database hit on every request)
- Avg API response time: 450ms
- Database CPU at 78% during peak

Target state:
- Session lookup <10ms
- Cached API responses <50ms
- Database CPU <50% during peak

## Scope

### Evaluated

| Capability | Redis | Memcached |
|------------|-------|-----------|
| Session storage | ✅ | ✅ |
| API response cache | ✅ | ✅ |
| Pub/sub for invalidation | ✅ | ❌ |
| Data structures (sorted sets, etc.) | ✅ | ❌ |
| Persistence | ✅ | ❌ |
| Clustering | ✅ | ✅ |

### Not Evaluated
- Third-party managed services (ElastiCache comparison deferred)
- Application-level caching (in-memory)
- CDN caching (separate initiative)

## Key Findings

### Performance Winner: Memcached (for simple key-value)

| Operation | Redis | Memcached |
|-----------|-------|-----------|
| GET (1KB) | 0.12ms | 0.08ms |
| SET (1KB) | 0.15ms | 0.10ms |
| GET (10KB) | 0.45ms | 0.32ms |
| MGET (100 keys) | 2.1ms | 1.4ms |

Memcached is **~30% faster** for simple operations.

### Feature Winner: Redis

Redis provides:
- Persistence (survives restarts)
- Pub/sub (real-time cache invalidation)
- Rich data types (sorted sets for leaderboards, etc.)
- Lua scripting (atomic operations)
- Built-in replication

### Cost Comparison (3-node cluster, AWS)

| Configuration | Redis | Memcached |
|---------------|-------|-----------|
| r6g.large (3 nodes) | $450/month | $390/month |
| r6g.xlarge (3 nodes) | $900/month | $780/month |

Redis is ~15% more expensive for equivalent specs.

## Recommendation

**Use both:**
- **Redis** for session storage (needs persistence, pub/sub for invalidation)
- **Memcached** for API response caching (pure speed, no persistence needed)

See `recommendation.md` for detailed rationale.

## Test Environment

- AWS EC2 c5.xlarge instances (client)
- ElastiCache for Redis 7.0 (r6g.large, 3 nodes)
- ElastiCache for Memcached 1.6 (r6g.large, 3 nodes)
- Same VPC, same AZ for testing
- redis-benchmark and custom Python scripts

## Files

- `benchmark-results.md` - Detailed performance data
- `architecture.md` - Proposed production topology
- `cost-analysis.md` - TCO comparison
- `recommendation.md` - Final recommendation with rationale

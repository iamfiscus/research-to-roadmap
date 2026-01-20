# Load Testing Experiment: Checkout Flow

**Duration**: 1 week (Jan 22-26, 2024)
**Team**: Omar Hassan (Lead), Nina Patel
**Status**: Complete - Action Required

## Hypothesis

> The checkout flow can handle 10,000 concurrent users with p99 latency under 2 seconds and zero errors.

## Result: PARTIALLY VALIDATED

The system **passed** at 7,500 concurrent users but **failed** at 10,000:
- At 7,500: p99 = 1.8s, error rate = 0.02% ✅
- At 10,000: p99 = 4.2s, error rate = 2.3% ❌

**Bottleneck identified**: Database connection pool exhaustion

## Background

Black Friday 2023 saw 6,200 concurrent users at peak, with degraded performance (p99 = 3.5s) and 0.8% error rate. Business projects 8,000-10,000 concurrent users for Black Friday 2024.

## Methodology

### Test Environment

| Component | Production | Test Environment |
|-----------|------------|------------------|
| App servers | 8x c5.2xlarge | 8x c5.2xlarge (identical) |
| Database | db.r5.4xlarge | db.r5.4xlarge (restored backup) |
| Load balancer | ALB | ALB |
| Region | us-east-1 | us-east-1 |

**Note**: Test environment mirrors production exactly. Tests ran on isolated infrastructure to avoid production impact.

### Load Generation

- **Tool**: k6 (Grafana)
- **Load generators**: 10x c5.xlarge EC2 instances
- **Protocol**: HTTPS
- **Test data**: 100,000 synthetic users, 50,000 products

### Test Scenarios

| Scenario | Description | User Flow |
|----------|-------------|-----------|
| Browse | User browses products | Home → Category → Product |
| Add to Cart | User adds items | Product → Add to Cart |
| Checkout | User completes purchase | Cart → Checkout → Payment → Confirmation |
| Mixed | Realistic mix | 60% Browse, 25% Cart, 15% Checkout |

### Ramp-Up Profile

```
Users
10000 |                    ████████████
 7500 |               ████
 5000 |          ████
 2500 |     ████
    0 |████
      |-----|-----|-----|-----|-----|-----|
      0     5    10    15    20    25    30 (minutes)
        Ramp   Hold at each level (5 min)  Ramp down
```

## Results

### Summary by Concurrency Level

| Concurrent Users | Requests/sec | p50 | p95 | p99 | Error Rate | Status |
|------------------|--------------|-----|-----|-----|------------|--------|
| 2,500 | 1,250 | 180ms | 450ms | 650ms | 0.00% | ✅ Pass |
| 5,000 | 2,480 | 220ms | 580ms | 890ms | 0.01% | ✅ Pass |
| 7,500 | 3,650 | 320ms | 980ms | 1,800ms | 0.02% | ✅ Pass |
| 10,000 | 4,100 | 850ms | 2,400ms | 4,200ms | 2.30% | ❌ Fail |

### Detailed Metrics at 10,000 Users

| Metric | Value | Threshold | Status |
|--------|-------|-----------|--------|
| Requests/sec | 4,100 | - | Below expected |
| p50 latency | 850ms | <500ms | ❌ Fail |
| p95 latency | 2,400ms | <1,500ms | ❌ Fail |
| p99 latency | 4,200ms | <2,000ms | ❌ Fail |
| Error rate | 2.30% | <0.1% | ❌ Fail |
| CPU (app) | 78% | <80% | ✅ Pass |
| CPU (db) | 92% | <80% | ❌ Fail |
| Memory (app) | 65% | <80% | ✅ Pass |
| DB connections | 500/500 | <450 | ❌ Exhausted |

### Error Analysis

| Error Type | Count | Percentage |
|------------|-------|------------|
| Connection timeout | 847 | 68% |
| 503 Service Unavailable | 312 | 25% |
| Payment timeout | 89 | 7% |

Root cause: All errors trace back to database connection exhaustion.

## Bottleneck Analysis

### Primary Bottleneck: Database Connection Pool

```
Connection Pool Behavior:

Connections
500 |████████████████████████████████████  ← Pool exhausted
400 |
300 |                  ████
200 |             ████
100 |        ████
  0 |████
    |-----|-----|-----|-----|-----|
    0    2500   5000   7500  10000  (concurrent users)
```

**Finding**: Connection pool (500) exhausts at ~8,500 concurrent users.

**Why**: Each checkout request holds a connection for ~200ms average. At 10K users with 15% checkout rate:
- 1,500 checkout requests active
- 200ms hold time
- ~300 connections needed just for checkout
- Browse/cart consume remaining ~200 connections
- No headroom for spikes

### Secondary Bottleneck: Database CPU

Database CPU reached 92% at 10K users, indicating queries are becoming slow under load:
- Index scans degrading to seq scans
- Lock contention on inventory table
- Connection overhead

## Recommendations

### Immediate (Before Black Friday)

| Action | Impact | Effort | Priority |
|--------|--------|--------|----------|
| Increase connection pool to 750 | +25% capacity | Low | P0 |
| Add read replica for browse queries | +40% read capacity | Medium | P0 |
| Implement connection pooling (PgBouncer) | +50% efficiency | Medium | P1 |
| Optimize inventory lock query | -30% hold time | Low | P1 |

### Post-Black Friday

| Action | Impact | Effort |
|--------|--------|--------|
| Implement async checkout | Decouple from DB | High |
| Add caching layer | Reduce DB load 50% | Medium |
| Horizontal DB sharding | 10x capacity | High |

## Appendix

See additional files:
- `detailed-metrics.md` - Full metrics for all test runs
- `error-logs.md` - Sample error traces
- `grafana-dashboard.json` - Dashboard export
- `k6-scripts/` - Load test scripts

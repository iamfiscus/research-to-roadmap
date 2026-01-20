# Detailed Metrics

## Test Run Summary

| Run | Date | Duration | Max Users | Result |
|-----|------|----------|-----------|--------|
| 1 | Jan 22 | 30 min | 5,000 | Pass |
| 2 | Jan 23 | 30 min | 7,500 | Pass |
| 3 | Jan 24 | 30 min | 10,000 | Fail |
| 4 | Jan 25 | 30 min | 10,000 | Fail (repeat) |
| 5 | Jan 26 | 30 min | 8,500 | Pass (threshold) |

## Run 1: 5,000 Concurrent Users

**Date**: January 22, 2024, 2:00 AM EST
**Duration**: 30 minutes
**Result**: PASS

### Latency Distribution

| Percentile | Browse | Add to Cart | Checkout |
|------------|--------|-------------|----------|
| p50 | 120ms | 180ms | 350ms |
| p75 | 180ms | 280ms | 520ms |
| p90 | 280ms | 420ms | 720ms |
| p95 | 380ms | 550ms | 890ms |
| p99 | 580ms | 780ms | 1,200ms |

### Throughput

| Endpoint | Requests/sec | Success Rate |
|----------|--------------|--------------|
| GET /products | 1,450 | 100.00% |
| GET /product/:id | 620 | 100.00% |
| POST /cart | 310 | 99.99% |
| POST /checkout | 95 | 99.98% |
| **Total** | **2,475** | **99.99%** |

### Resource Utilization

| Resource | Average | Peak |
|----------|---------|------|
| App CPU | 42% | 58% |
| App Memory | 48% | 55% |
| DB CPU | 55% | 68% |
| DB Connections | 280 | 320 |
| DB IOPS | 4,500 | 6,200 |

---

## Run 2: 7,500 Concurrent Users

**Date**: January 23, 2024, 2:00 AM EST
**Duration**: 30 minutes
**Result**: PASS

### Latency Distribution

| Percentile | Browse | Add to Cart | Checkout |
|------------|--------|-------------|----------|
| p50 | 180ms | 280ms | 520ms |
| p75 | 280ms | 450ms | 780ms |
| p90 | 450ms | 680ms | 1,100ms |
| p95 | 620ms | 890ms | 1,450ms |
| p99 | 950ms | 1,350ms | 1,800ms |

### Throughput

| Endpoint | Requests/sec | Success Rate |
|----------|--------------|--------------|
| GET /products | 2,100 | 100.00% |
| GET /product/:id | 920 | 99.99% |
| POST /cart | 480 | 99.98% |
| POST /checkout | 150 | 99.95% |
| **Total** | **3,650** | **99.98%** |

### Resource Utilization

| Resource | Average | Peak |
|----------|---------|------|
| App CPU | 58% | 72% |
| App Memory | 58% | 68% |
| DB CPU | 72% | 85% |
| DB Connections | 380 | 450 |
| DB IOPS | 6,800 | 9,200 |

---

## Run 3: 10,000 Concurrent Users

**Date**: January 24, 2024, 2:00 AM EST
**Duration**: 30 minutes (terminated early at 22 min)
**Result**: FAIL

### Latency Distribution

| Percentile | Browse | Add to Cart | Checkout |
|------------|--------|-------------|----------|
| p50 | 450ms | 680ms | 1,200ms |
| p75 | 850ms | 1,200ms | 2,100ms |
| p90 | 1,400ms | 2,100ms | 3,200ms |
| p95 | 2,100ms | 2,800ms | 3,800ms |
| p99 | 3,200ms | 3,800ms | 4,200ms |

### Throughput

| Endpoint | Requests/sec | Success Rate |
|----------|--------------|--------------|
| GET /products | 2,400 | 98.50% |
| GET /product/:id | 1,050 | 97.80% |
| POST /cart | 520 | 96.50% |
| POST /checkout | 130 | 94.20% |
| **Total** | **4,100** | **97.70%** |

### Error Breakdown

| Error | Count | Rate | First Occurrence |
|-------|-------|------|------------------|
| Connection timeout | 847 | 1.56% | 8 min |
| 503 Service Unavailable | 312 | 0.57% | 10 min |
| Payment gateway timeout | 89 | 0.16% | 12 min |

### Resource Utilization

| Resource | Average | Peak | Alert |
|----------|---------|------|-------|
| App CPU | 68% | 78% | - |
| App Memory | 62% | 72% | - |
| DB CPU | 82% | 92% | ⚠️ |
| DB Connections | 485 | 500 | 🔴 Exhausted |
| DB IOPS | 9,500 | 12,000 | - |

### Timeline of Degradation

```
Time    Event
0:00    Test started, ramp begins
5:00    2,500 users, all metrics green
10:00   5,000 users, all metrics green
15:00   7,500 users, DB connections at 450
18:00   9,000 users, first connection timeouts
20:00   10,000 users, error rate exceeds 1%
22:00   Test terminated, error rate at 2.3%
```

---

## Run 5: 8,500 Concurrent Users (Threshold Test)

**Date**: January 26, 2024, 2:00 AM EST
**Duration**: 30 minutes
**Result**: PASS (threshold identified)

### Latency Distribution

| Percentile | Browse | Add to Cart | Checkout |
|------------|--------|-------------|----------|
| p50 | 250ms | 380ms | 680ms |
| p75 | 380ms | 580ms | 980ms |
| p90 | 580ms | 850ms | 1,350ms |
| p95 | 780ms | 1,100ms | 1,650ms |
| p99 | 1,150ms | 1,550ms | 1,950ms |

### Throughput

| Endpoint | Requests/sec | Success Rate |
|----------|--------------|--------------|
| GET /products | 2,350 | 99.98% |
| GET /product/:id | 1,000 | 99.97% |
| POST /cart | 510 | 99.95% |
| POST /checkout | 160 | 99.90% |
| **Total** | **4,020** | **99.96%** |

### Resource Utilization

| Resource | Average | Peak | Status |
|----------|---------|------|--------|
| App CPU | 65% | 75% | ✅ |
| App Memory | 60% | 70% | ✅ |
| DB CPU | 78% | 88% | ⚠️ |
| DB Connections | 445 | 485 | ⚠️ |
| DB IOPS | 8,500 | 11,000 | ✅ |

### Conclusion

**Maximum safe capacity**: 8,500 concurrent users

At this level:
- All SLAs met (p99 < 2s, error rate < 0.1%)
- DB connections at 97% (no headroom)
- DB CPU at 88% peak (limited headroom)

**To reach 10,000 users**: Must address connection pool and DB CPU bottlenecks.

---

## Database-Specific Metrics

### Query Performance at 10K Users

| Query | Avg Time | Count | % of Total |
|-------|----------|-------|------------|
| SELECT inventory | 45ms | 125K | 28% |
| UPDATE inventory (lock) | 120ms | 18K | 15% |
| INSERT order | 85ms | 15K | 12% |
| SELECT product | 12ms | 280K | 8% |
| SELECT user_cart | 28ms | 95K | 7% |

### Lock Contention

```
Lock wait events at 10K users:

Time (seconds)
50 |                              ████████
40 |                         ████
30 |                    ████
20 |               ████
10 |          ████
 0 |████████
   |-----|-----|-----|-----|-----|-----|
   5000  6000  7000  8000  9000  10000 (users)
```

**Finding**: Inventory table lock contention increases exponentially above 8,000 users.

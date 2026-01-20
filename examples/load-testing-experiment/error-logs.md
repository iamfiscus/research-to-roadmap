# Error Log Analysis

## Error Categories

| Category | Count | Percentage | Root Cause |
|----------|-------|------------|------------|
| Connection Timeout | 847 | 68% | DB pool exhaustion |
| 503 Service Unavailable | 312 | 25% | App server overwhelmed |
| Payment Timeout | 89 | 7% | Downstream cascade |

## Sample Error Traces

### Connection Timeout (Most Common)

**Request ID**: req-2024012410-847291
**Timestamp**: 2024-01-24T02:18:42.391Z
**Endpoint**: POST /api/checkout
**User**: test-user-47291

```
Error: Connection acquisition timeout after 30000ms
    at Pool.acquire (/app/node_modules/pg-pool/index.js:102:17)
    at Client.connect (/app/node_modules/pg/lib/client.js:73:19)
    at CheckoutService.createOrder (/app/services/checkout.js:45:12)
    at CheckoutController.processCheckout (/app/controllers/checkout.js:28:8)

Context:
  pool_size: 500
  active_connections: 500
  waiting_requests: 127
  wait_time: 30.2s
```

**Analysis**: Pool exhausted at 500 connections. Request waited 30s then timed out.

---

### 503 Service Unavailable

**Request ID**: req-2024012410-892156
**Timestamp**: 2024-01-24T02:19:15.892Z
**Endpoint**: GET /api/products
**User**: test-user-52891

```
HTTP 503 Service Unavailable

Response:
{
  "error": "Service temporarily unavailable",
  "retry_after": 5,
  "request_id": "req-2024012410-892156"
}

ALB Health Check Status:
  Target: app-server-3
  Status: unhealthy
  Reason: Request timeout (health check)
  Last healthy: 2024-01-24T02:18:30Z
```

**Analysis**: App server marked unhealthy due to slow health check responses (caused by thread starvation from DB waits).

---

### Payment Gateway Timeout

**Request ID**: req-2024012410-945782
**Timestamp**: 2024-01-24T02:20:33.156Z
**Endpoint**: POST /api/checkout
**User**: test-user-67823

```
Error: Payment processing timeout
    at PaymentService.charge (/app/services/payment.js:67:10)
    at CheckoutService.processPayment (/app/services/checkout.js:78:14)

Context:
  payment_provider: stripe
  timeout: 10000ms
  actual_time: 10042ms
  stripe_request_id: req_Kj9xYz2M4n5O

Stripe Dashboard:
  Request received: 2024-01-24T02:20:23.114Z
  Response sent: 2024-01-24T02:20:24.892Z (1.8s - within SLA)

Internal Timeline:
  Checkout request received: 02:20:22.891
  Inventory check complete: 02:20:30.456 (+7.5s, waiting for DB)
  Payment initiated: 02:20:30.458
  Payment timeout: 02:20:33.156 (+2.7s)
```

**Analysis**: By the time we called Stripe, only 2.7s remained of 10s timeout. Stripe responded in 1.8s but we'd already given up. Root cause is same DB bottleneck.

---

## Error Timeline

```
Time (min)  Errors/min  Event
0           0           Test started
5           0           2,500 users
10          0           5,000 users
15          2           7,500 users (first warnings)
18          28          9,000 users
19          95          DB connections at 500
20          187         Error rate >1%
21          245         App servers unhealthy
22          312         Test terminated
```

## Error Correlation

### Errors vs DB Connections

```
Errors/min
300 |                              ████
250 |                         ████
200 |                    ████
150 |               ████
100 |          ████
 50 |     ████
  0 |████                              Connections
    |-----|-----|-----|-----|-----|
    300   350   400   450   500   (pool utilization)
```

**Correlation**: Errors spike dramatically when connections exceed 480 (96% utilization).

### Error Rate vs Latency

```
When p99 latency exceeds:
  1s: Error rate = 0.1%
  2s: Error rate = 0.5%
  3s: Error rate = 1.5%
  4s: Error rate = 2.5%
```

## Recommendations Based on Errors

1. **Connection timeout errors** → Increase pool size, add PgBouncer
2. **503 errors** → Increase health check timeout during load
3. **Payment timeouts** → Increase timeout or make async

## Error Handling Improvements

Current:
```javascript
try {
  await pool.query(sql);
} catch (e) {
  return res.status(500).json({ error: 'Internal error' });
}
```

Recommended:
```javascript
try {
  await pool.query(sql);
} catch (e) {
  if (e.code === 'POOL_EXHAUSTED') {
    // Return 503 with retry-after header
    res.set('Retry-After', '5');
    return res.status(503).json({
      error: 'Service temporarily unavailable',
      retry_after: 5
    });
  }
  // Log and return generic error
  logger.error({ err: e, request_id: req.id }, 'Database error');
  return res.status(500).json({ error: 'Internal error' });
}
```

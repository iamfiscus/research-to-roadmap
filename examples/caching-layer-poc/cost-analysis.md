# Cost Analysis

## Current State Costs

### Database Load (Preventable)

| Item | Monthly Cost |
|------|--------------|
| RDS instance (db.r5.2xlarge) | $1,200 |
| Read replicas (2x) | $2,400 |
| **Portion attributable to cacheable queries** | **~$1,500** |

Estimated 40% of database load is cacheable. With caching, could downsize RDS.

### Performance Impact (Hidden Costs)

| Issue | Business Impact |
|-------|-----------------|
| 450ms avg API latency | User frustration, lower conversion |
| 78% database CPU | Limited growth capacity |
| Session lookup 200ms | Poor login experience |

## Proposed State Costs

### Option A: Redis Only

| Item | Monthly Cost |
|------|--------------|
| Redis (r6g.large, 3 nodes) | $450 |
| Data transfer | $20 |
| **Total** | **$470/month** |

### Option B: Memcached Only

| Item | Monthly Cost |
|------|--------------|
| Memcached (r6g.large, 3 nodes) | $390 |
| Data transfer | $20 |
| **Total** | **$410/month** |

### Option C: Hybrid (Recommended)

| Item | Monthly Cost |
|------|--------------|
| Redis (r6g.large, 3 nodes) - sessions | $450 |
| Memcached (r6g.large, 3 nodes) - API cache | $390 |
| Data transfer | $40 |
| **Total** | **$880/month** |

## Total Cost of Ownership (3 Years)

| Scenario | Year 1 | Year 2 | Year 3 | Total |
|----------|--------|--------|--------|-------|
| No caching | $43,200 | $64,800* | $97,200* | $205,200 |
| Redis only | $5,640 | $8,460** | $12,690** | $26,790 |
| Hybrid | $10,560 | $15,840** | $23,760** | $50,160 |

*Assumes 50% annual growth requiring larger RDS
**Assumes cache cluster scaling with growth

### ROI Calculation (Hybrid)

| Item | Value |
|------|-------|
| Cache infrastructure | $50,160 (3yr) |
| RDS savings (downsize) | -$36,000 (3yr) |
| **Net infrastructure cost** | **$14,160** |

Additional benefits not quantified:
- Improved latency → higher conversion
- Reduced database load → developer productivity
- Better user experience → lower churn

## Scaling Costs

### When to Scale

| Trigger | Action | Cost Impact |
|---------|--------|-------------|
| Memory >70% | Add node or upgrade | +$130-260/month |
| CPU >70% | Upgrade instance | +$150-300/month |
| Connections >50K | Add node | +$130/month |

### Projected Scaling Timeline

| Period | Configuration | Monthly Cost |
|--------|---------------|--------------|
| Year 1 | r6g.large (3+3) | $880 |
| Year 2 | r6g.xlarge (3+3) | $1,680 |
| Year 3 | r6g.xlarge (4+4) | $2,240 |

## Cost Optimization Opportunities

### Reserved Instances

| Term | Discount | Effective Monthly (Hybrid) |
|------|----------|---------------------------|
| On-demand | 0% | $880 |
| 1-year reserved | 31% | $607 |
| 3-year reserved | 52% | $422 |

**Recommendation**: 1-year reserved after 3 months of stable usage

### Right-Sizing

Monitor actual memory usage. If consistently <50%, can downgrade:
- r6g.large (13GB) → r6g.medium (6.5GB)
- Savings: ~$200/month

### Auto Scaling (Future)

Memcached supports auto discovery. Can add/remove nodes based on load.
Not available for Redis cluster mode.

## Comparison with Managed Alternatives

| Provider | Equivalent Config | Monthly Cost |
|----------|-------------------|--------------|
| AWS ElastiCache (proposed) | r6g.large x6 | $880 |
| Redis Enterprise Cloud | 12GB HA | $1,100 |
| Upstash (serverless Redis) | Pay-per-request | ~$600* |
| Self-managed on EC2 | r6g.large x6 | $650** |

*Highly variable based on usage
**Does not include operational overhead

**Verdict**: ElastiCache is best value for our scale and operational maturity.

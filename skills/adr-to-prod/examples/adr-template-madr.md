# ADR Template: MADR Format

Markdown Any Decision Record format - lightweight and practical.

---

# ADR-NNN: [Title]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Context

[What is the issue that we're seeing that is motivating this decision or change?]

## Decision

[What is the change that we're proposing and/or doing?]

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Drawback 1]
- [Drawback 2]

### Neutral
- [Side effect 1]

---

# Example: ADR-012 Database Migration Strategy

## Status

Accepted

## Context

Our monolithic PostgreSQL database is reaching capacity limits (80% storage, query times degrading). We need to decide how to scale the database layer to support 10x growth over the next 2 years.

Options considered:
1. Vertical scaling (bigger instance)
2. Read replicas
3. Horizontal sharding
4. Move to managed service (Aurora)

## Decision

We will implement **read replicas first**, then evaluate Aurora migration.

**Rationale**:
- Vertical scaling is a temporary fix (6 months max)
- Sharding requires significant application changes
- Read replicas solve 70% of our load (read-heavy workload)
- Aurora migration can happen later with minimal code changes

**Implementation**:
1. Deploy 2 read replicas in different AZs
2. Update application to route reads to replicas
3. Monitor for 3 months
4. Re-evaluate Aurora if replicas insufficient

## Consequences

### Positive
- Immediate relief for read load
- No application architecture changes
- Maintains operational simplicity
- Keeps Aurora option open

### Negative
- Replication lag for reads (acceptable: <100ms)
- Additional infrastructure cost (~$500/month)
- Need to handle replica failover
- Doesn't solve write scaling (future problem)

### Neutral
- Team needs training on replica routing
- Monitoring needs update for replica metrics

---

## Production Breakdown

When implementing this ADR, decompose into:

### Phase 1: Infrastructure (Week 1-2)
- [ ] Provision read replicas via Terraform
- [ ] Configure replication
- [ ] Set up monitoring for replication lag
- [ ] Test failover procedure

### Phase 2: Application Changes (Week 3-4)
- [ ] Add connection pool for replicas
- [ ] Implement read/write routing logic
- [ ] Add feature flag for gradual rollout
- [ ] Update integration tests

### Phase 3: Rollout (Week 5-6)
- [ ] Enable for 10% of read traffic
- [ ] Monitor latency and errors
- [ ] Increase to 50%, then 100%
- [ ] Document runbooks

### Phase 4: Validation (Week 7-8)
- [ ] Verify load reduction on primary
- [ ] Confirm replication lag acceptable
- [ ] Test disaster recovery
- [ ] Update ADR with learnings

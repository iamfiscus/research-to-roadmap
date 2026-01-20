# Cloud Migration Spike

**Duration**: 1 week (Nov 13-17, 2023)
**Team**: Jennifer Park (Architect), Carlos Mendez (Platform), Lisa Wang (Security)
**Status**: Complete - Requires detailed planning phase

## Objective

Assess feasibility, complexity, and rough timeline for migrating from on-premises data center to AWS cloud infrastructure.

## Background

Current infrastructure is hosted in a co-located data center with a 3-year lease expiring June 2025. Leadership wants to understand:
1. Is cloud migration technically feasible?
2. What is the rough timeline and cost?
3. What are the major risks?

This spike is a **preliminary assessment** to inform a go/no-go decision on detailed planning.

## Current State Summary

| Category | Details |
|----------|---------|
| Compute | 12 bare-metal servers (mix of app, DB, cache) |
| Storage | 2.1 PB (1.8 PB archive, 300 TB active) |
| Databases | PostgreSQL (2), MongoDB (1), Redis cluster |
| Network | 10 Gbps uplink, 2 Gbps burst |
| Traffic | 15K requests/sec peak, 5K avg |
| Team | 3 infrastructure engineers |

See `current-state.md` for detailed inventory.

## Key Findings

### Feasibility: YES (with caveats)

Migration is technically feasible. No fundamental blockers identified.

**Caveats**:
- Legacy payment processor requires VPN to on-prem (temporary)
- Data residency requirements limit to us-east-1 (acceptable)
- 2 PB storage migration will take 6-8 weeks via Snowball

### Complexity: HIGH

| Factor | Complexity | Notes |
|--------|------------|-------|
| Application modernization | Medium | Most apps containerizable |
| Database migration | High | 2 PB, zero-downtime requirement |
| Network configuration | Medium | Standard VPC design |
| Security/compliance | High | HIPAA, SOC 2 recertification |
| Team skills | Medium | AWS experience limited |

### Timeline Estimate: 18-24 months

| Phase | Duration | Key Activities |
|-------|----------|----------------|
| Detailed planning | 3 months | Architecture, vendor selection |
| Foundation | 3 months | Network, IAM, security baseline |
| Non-critical migration | 6 months | Dev/staging, internal tools |
| Database migration | 3 months | Replication setup, cutover |
| Production migration | 3 months | App servers, final cutover |
| Optimization | 3 months | Cost tuning, decommission |

### Cost Comparison

| Item | On-Prem (Annual) | AWS (Annual) |
|------|------------------|--------------|
| Compute | $180,000 | $240,000* |
| Storage | $120,000 | $85,000 |
| Network | $48,000 | $36,000 |
| Staff (3 FTE) | $450,000 | $300,000** |
| Facilities/power | $60,000 | $0 |
| **Total** | **$858,000** | **$661,000** |

*Before reserved instances, **Assumes 1 FTE reduction post-migration

See `cost-comparison.md` for detailed breakdown.

## Recommendation

**Proceed to detailed planning phase.**

The business case is positive ($197K annual savings) and the technical complexity, while high, is manageable with proper planning and external expertise.

### Immediate Next Steps

1. Engage AWS solution architect for Well-Architected review
2. Begin detailed application inventory and dependency mapping
3. Select migration partner (recommend evaluating 2-3 vendors)
4. Start HIPAA compliance gap analysis for AWS

### Critical Success Factors

1. Executive sponsorship and dedicated budget
2. Experienced migration partner
3. Realistic timeline (resist pressure to compress)
4. Parallel operations during transition (budget for both)

## Files

- `current-state.md` - Detailed on-prem inventory
- `target-architecture.md` - Proposed AWS design
- `migration-strategy.md` - Approach and phases
- `risk-assessment.md` - Identified risks and mitigations
- `cost-comparison.md` - TCO analysis
- `timeline-estimate.md` - Phased timeline

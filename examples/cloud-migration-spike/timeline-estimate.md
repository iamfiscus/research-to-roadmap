# Timeline Estimate

## Overview

**Total Duration**: 18-24 months
**Start Date**: TBD (pending approval)
**Target Completion**: Before lease expiration (June 2025)

```
2024                                          2025
Q1        Q2        Q3        Q4        Q1        Q2
|---------|---------|---------|---------|---------|---------|
[===Phase 0===]
          [=======Phase 1=========]
                    [===Phase 2===]
                    [=========Phase 4 (Storage)==========]
                              [=========Phase 3=========]
                                                  [==P5==]
                                                      ↑
                                                 Lease Expires
```

## Detailed Timeline

### Phase 0: Foundation (Months 1-3)

**Duration**: 12 weeks
**Team**: 2 engineers + AWS ProServe

| Week | Milestone | Deliverables |
|------|-----------|--------------|
| 1-2 | Account setup | AWS Organization, accounts, IAM |
| 3-4 | Network foundation | VPC, subnets, routing tables |
| 5-6 | Hybrid connectivity | VPN tunnel, DNS configuration |
| 7-8 | Security baseline | GuardDuty, Config, CloudTrail |
| 9-10 | CI/CD pipeline | CodePipeline, IaC templates |
| 11-12 | Validation | Security review, penetration test |

**Key Dates**:
- Week 4: VPN connectivity validated
- Week 8: Security baseline complete
- Week 12: Phase 0 sign-off

### Phase 1: Non-Critical Workloads (Months 4-9)

**Duration**: 24 weeks
**Team**: 3 engineers

| Week | Milestone | Deliverables |
|------|-----------|--------------|
| 1-4 | Dev environment | All dev systems in AWS |
| 5-8 | Staging environment | Staging mirrors production |
| 9-12 | Internal tools | Wiki, PM tools migrated |
| 13-16 | Batch jobs | ETL, reporting in AWS |
| 17-20 | Analytics | Data warehouse migration |
| 21-24 | Stabilization | Runbooks, monitoring, training |

**Key Dates**:
- Week 8: Staging environment operational
- Week 16: All batch jobs migrated
- Week 24: Phase 1 sign-off

### Phase 2: Database Migration (Months 10-12)

**Duration**: 12 weeks
**Team**: 2 engineers + DBA

| Week | Milestone | Deliverables |
|------|-----------|--------------|
| 1-2 | Preparation | RDS/DocumentDB provisioned, DMS setup |
| 3-4 | Initial load | Full data copy to AWS |
| 5-8 | Replication | Continuous replication running |
| 9-10 | Testing | Read queries against AWS replicas |
| 11 | Cutover | Production database cutover |
| 12 | Validation | Data integrity, performance verification |

**Key Dates**:
- Week 4: Initial data load complete
- Week 10: Cutover rehearsal
- Week 11: Production cutover (Saturday 2 AM)
- Week 12: Phase 2 sign-off

**Cutover Window Details**:
```
Saturday 2:00 AM - Begin maintenance window
         2:05 AM - Stop application writes
         2:10 AM - Wait for replication sync
         2:20 AM - Validate data integrity
         2:30 AM - Update connection strings
         2:35 AM - Start applications
         2:45 AM - Smoke tests
         3:00 AM - End maintenance window (or rollback)
```

### Phase 3: Application Migration (Months 13-18)

**Duration**: 24 weeks
**Team**: 4 engineers

| Week | Milestone | Deliverables |
|------|-----------|--------------|
| 1-4 | Background workers | Workers on ECS with SQS |
| 5-8 | Internal API | Internal services migrated |
| 9-12 | Public API | API servers on ECS |
| 13-16 | Web frontend | Frontend on ECS + CloudFront |
| 17-20 | Payment connector | Legacy integration resolved |
| 21-24 | Stabilization | All applications validated |

**Key Dates**:
- Week 4: First production workload in AWS
- Week 12: Public API migrated
- Week 16: Customer-facing complete
- Week 24: Phase 3 sign-off

### Phase 4: Storage Migration (Months 10-15, parallel)

**Duration**: 24 weeks (overlaps with Phase 2-3)
**Team**: 1 engineer + storage vendor

| Week | Milestone | Deliverables |
|------|-----------|--------------|
| 1-2 | Snowball order | 5x Snowball Edge devices ordered |
| 3-4 | Active data | 50 TB active data via DataSync |
| 5-8 | Media data | 250 TB media via DataSync |
| 9-12 | Archive load | Load 1.8 PB to Snowball devices |
| 13-14 | Snowball ship | Devices shipped to AWS |
| 15-16 | Import | Data imported to S3 Glacier |
| 17-20 | Validation | Checksums verified |
| 21-24 | Cleanup | On-prem storage decommissioned |

**Key Dates**:
- Week 4: Active data in S3
- Week 14: Snowball devices shipped
- Week 20: All data validated in AWS
- Week 24: Phase 4 sign-off

### Phase 5: Optimization (Months 19-21)

**Duration**: 12 weeks
**Team**: 2 engineers

| Week | Milestone | Deliverables |
|------|-----------|--------------|
| 1-4 | Right-sizing | Instances optimized based on metrics |
| 5-6 | Reserved instances | 1-year reservations purchased |
| 7-8 | Automation | Runbooks automated |
| 9-10 | Cost optimization | Unused resources cleaned up |
| 11-12 | Decommission | On-prem hardware returned/sold |

**Key Dates**:
- Week 6: Reserved instances active
- Week 12: Phase 5 sign-off, project complete

## Critical Path

```
VPN Setup → Database Replication → Database Cutover → Application Migration
   (W4)           (W16)                (W28)              (W36-48)
```

Any delay on critical path items extends total timeline.

## Resource Loading

| Month | Engineers | Notes |
|-------|-----------|-------|
| 1-3 | 2 + ProServe | Foundation |
| 4-6 | 3 | Non-critical migration |
| 7-9 | 3 | Non-critical + DB prep |
| 10-12 | 4 | Database + storage |
| 13-15 | 5 | Applications (peak) |
| 16-18 | 4 | Applications |
| 19-21 | 2 | Optimization |

**Peak Staffing**: Month 13-15 (5 engineers)

## Dependencies

| Dependency | Required By | Status |
|------------|-------------|--------|
| Budget approval | Month 1 | Pending |
| AWS agreement signed | Month 1 | In progress |
| Migration partner selected | Month 2 | Not started |
| Training complete | Month 3 | Not started |
| Compliance assessment | Month 6 | Not started |
| Snowball devices available | Month 10 | Check lead time |

## Risks to Timeline

| Risk | Impact | Mitigation |
|------|--------|------------|
| Budget approval delayed | 1-2 months | Escalate to CFO |
| Database migration issues | 1-3 months | Extra testing, rehearsals |
| Staff turnover | 2-4 months | Knowledge documentation |
| Compliance gaps found | 1-3 months | Early assessment |
| Snowball delays | 1-2 months | Order early |

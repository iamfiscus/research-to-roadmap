# Risk Assessment

## Risk Matrix

| Risk | Probability | Impact | Score | Mitigation |
|------|-------------|--------|-------|------------|
| Data loss during migration | Low | Critical | High | DMS validation, checksums, parallel run |
| Extended downtime | Medium | High | High | Phased migration, rollback plans |
| Cost overrun | Medium | Medium | Medium | Reserved instances, cost monitoring |
| Skills gap | High | Medium | High | Training, partner engagement |
| Compliance gaps | Medium | High | High | Early audit engagement, controls mapping |
| Vendor lock-in | Medium | Low | Low | Portable technologies where practical |
| Performance degradation | Low | High | Medium | Load testing, gradual rollout |
| Security incident | Low | Critical | High | Security review, penetration testing |
| Timeline slip | High | Medium | High | Buffer time, scope management |
| Legacy integration failure | Medium | High | High | Hybrid period, VPN backup |

## Detailed Risk Analysis

### R1: Data Loss During Migration

**Description**: Data corrupted or lost during transfer from on-prem to AWS

**Probability**: Low (5-10%)
**Impact**: Critical (regulatory violations, customer trust)

**Contributing Factors**:
- 2+ PB of data to move
- Multiple data formats and systems
- Network interruptions during transfer

**Mitigations**:
1. Use AWS DMS with validation for databases
2. Implement checksum verification for all file transfers
3. Run parallel systems until validation complete
4. Maintain on-prem backups for 90 days post-migration
5. Test restore procedures before decommissioning

**Contingency**: Restore from on-prem backup, delay decommission

---

### R2: Extended Downtime

**Description**: Production outage lasting >4 hours during migration

**Probability**: Medium (20-30%)
**Impact**: High (revenue loss, customer impact)

**Contributing Factors**:
- Database cutover complexity
- DNS propagation delays
- Unexpected application issues

**Mitigations**:
1. Phased migration (not big bang)
2. Tested rollback procedures for each phase
3. Blue-green deployment for applications
4. Database replication before cutover
5. Low-traffic window for critical cutovers

**Contingency**: Immediate rollback to on-prem, incident response

---

### R3: Cost Overrun

**Description**: AWS costs exceed budget by >20%

**Probability**: Medium (30-40%)
**Impact**: Medium (budget reallocation required)

**Contributing Factors**:
- Underestimated data transfer costs
- Over-provisioned instances
- Unexpected egress charges
- Parallel operations longer than planned

**Mitigations**:
1. Detailed cost modeling before each phase
2. AWS Budgets with alerts at 80%
3. Weekly cost reviews
4. Reserved instance purchase plan
5. Right-sizing after 30 days of metrics

**Contingency**: Accelerate optimization, reduce scope

---

### R4: Skills Gap

**Description**: Team lacks AWS expertise, causing delays and errors

**Probability**: High (60-70%)
**Impact**: Medium (slower progress, increased risk)

**Contributing Factors**:
- Team experienced with on-prem only
- AWS ecosystem is vast
- Limited time for training

**Mitigations**:
1. Engage AWS Professional Services for foundation
2. Partner with experienced migration firm
3. AWS training program (Solutions Architect, DevOps)
4. Knowledge transfer requirements in contracts
5. Hire 1-2 AWS-experienced engineers

**Contingency**: Extend timeline, increase partner scope

---

### R5: Compliance Gaps

**Description**: AWS environment fails compliance audit (HIPAA, SOC 2, PCI)

**Probability**: Medium (25-35%)
**Impact**: High (cannot operate, legal exposure)

**Contributing Factors**:
- Different security model (shared responsibility)
- New services to assess
- Control mapping complexity

**Mitigations**:
1. Engage compliance consultant early (Phase 0)
2. Use AWS Artifact for compliance documentation
3. Map existing controls to AWS services
4. Pre-audit assessment before Phase 3
5. Use AWS Config rules for continuous compliance

**Contingency**: Pause migration until gaps addressed

---

### R6: Legacy Integration Failure

**Description**: Payment processor or other legacy system integration fails

**Probability**: Medium (30-40%)
**Impact**: High (payment processing disrupted)

**Contributing Factors**:
- VPN complexity
- Legacy system dependencies
- IP address changes

**Mitigations**:
1. Maintain VPN to on-prem throughout migration
2. Static IP allocation in AWS for legacy systems
3. Test integration extensively in staging
4. Modernize payment integration (Phase 3)
5. Direct peering if VPN insufficient

**Contingency**: Route payment traffic through on-prem VPN hub

## Risk-Adjusted Timeline

| Phase | Base Duration | Risk Buffer | Total |
|-------|---------------|-------------|-------|
| Foundation | 3 months | +0.5 months | 3.5 months |
| Non-critical | 6 months | +1 month | 7 months |
| Database | 3 months | +1 month | 4 months |
| Application | 6 months | +1.5 months | 7.5 months |
| Optimization | 3 months | +0.5 months | 3.5 months |

**Risk-adjusted total**: 22-26 months (vs 18 months baseline)

## Assumptions Requiring Validation

| Assumption | Current Confidence | Validation Method |
|------------|-------------------|-------------------|
| AWS supports all compliance requirements | Medium | Compliance assessment (Phase 0) |
| Team can learn AWS in reasonable time | Medium | Training + pilot projects |
| Legacy systems work over VPN | High | PoC connection test |
| Database replication achieves <1s lag | Medium | DMS testing |
| 2 PB can transfer in 8 weeks | Medium | Snowball order and test |
| Cost estimates are accurate | Low | Detailed modeling needed |

## Go/No-Go Criteria

**Proceed if**:
- Compliance gap assessment shows no blockers
- VPN connectivity test successful
- Executive budget approval received
- Migration partner selected
- Team training plan approved

**Do not proceed if**:
- Compliance requirements cannot be met
- Legacy integration fundamentally incompatible
- Budget not approved
- Key staff departures

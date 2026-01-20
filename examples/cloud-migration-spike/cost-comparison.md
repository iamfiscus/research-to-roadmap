# Cost Comparison: On-Prem vs AWS

## Executive Summary

| Metric | On-Prem | AWS | Difference |
|--------|---------|-----|------------|
| Annual run rate | $858,000 | $661,000 | -$197,000 (-23%) |
| 5-year TCO | $4,290,000 | $3,305,000 | -$985,000 (-23%) |
| Migration cost | $0 | $450,000 | One-time |
| Payback period | N/A | 27 months | |

## Current On-Prem Costs (Annual)

### Infrastructure

| Category | Item | Annual Cost |
|----------|------|-------------|
| Compute | Server depreciation (12 servers) | $96,000 |
| Compute | Maintenance contracts | $36,000 |
| Compute | Refresh reserve (5-year cycle) | $48,000 |
| **Compute Subtotal** | | **$180,000** |
| Storage | NetApp (50 TB SSD + 350 TB HDD) | $72,000 |
| Storage | Dell EMC Isilon (1.8 PB) | $48,000 |
| **Storage Subtotal** | | **$120,000** |
| Network | 10 Gbps circuit | $36,000 |
| Network | 2 Gbps backup circuit | $12,000 |
| **Network Subtotal** | | **$48,000** |

### Facilities

| Item | Annual Cost |
|------|-------------|
| Colocation (4 cabinets) | $36,000 |
| Power (est. 40kW) | $24,000 |
| **Facilities Subtotal** | **$60,000** |

### Personnel

| Role | FTE | Annual Cost |
|------|-----|-------------|
| Infrastructure Engineer | 2.0 | $300,000 |
| Infrastructure Manager | 0.5 | $100,000 |
| On-call coverage | 0.5 | $50,000 |
| **Personnel Subtotal** | **3.0** | **$450,000** |

### Total On-Prem Annual Cost: $858,000

---

## Projected AWS Costs (Annual, Steady State)

### Compute (ECS Fargate)

| Service | Configuration | Monthly | Annual |
|---------|---------------|---------|--------|
| API | 10 tasks avg (2vCPU, 4GB) | $730 | $8,760 |
| Web | 6 tasks avg (1vCPU, 2GB) | $220 | $2,640 |
| Workers | 8 tasks avg (2vCPU, 4GB) | $585 | $7,020 |
| Internal | 2 tasks (0.5vCPU, 1GB) | $37 | $444 |
| **Compute Subtotal** | | | **$18,864** |

With Reserved: **$13,200** (30% discount)

### Database

| Service | Configuration | Monthly | Annual |
|---------|---------------|---------|--------|
| RDS PostgreSQL | db.r6g.4xlarge Multi-AZ | $2,800 | $33,600 |
| RDS Read Replicas | 2x db.r6g.2xlarge | $2,000 | $24,000 |
| DocumentDB | 3x db.r6g.2xlarge | $2,100 | $25,200 |
| ElastiCache | 3x r6g.xlarge | $780 | $9,360 |
| **Database Subtotal** | | | **$92,160** |

With Reserved: **$55,300** (40% discount)

### Storage

| Service | Configuration | Monthly | Annual |
|---------|---------------|---------|--------|
| S3 Standard | 300 TB | $6,900 | $82,800 |
| S3 Glacier Deep | 1.8 PB | $1,800 | $21,600 |
| EBS (RDS) | 15 TB gp3 | $1,200 | $14,400 |
| **Storage Subtotal** | | | **$118,800** |

### Network

| Service | Configuration | Monthly | Annual |
|---------|---------------|---------|--------|
| Data transfer out | 50 TB/month | $2,250 | $27,000 |
| NAT Gateway | 3x (processing) | $100 | $1,200 |
| VPN | Site-to-site | $36 | $432 |
| **Network Subtotal** | | | **$28,632** |

### Supporting Services

| Service | Monthly | Annual |
|---------|---------|--------|
| CloudWatch | $200 | $2,400 |
| CloudTrail | $50 | $600 |
| Secrets Manager | $30 | $360 |
| WAF | $100 | $1,200 |
| Route 53 | $50 | $600 |
| **Supporting Subtotal** | | **$5,160** |

### Personnel (Reduced)

| Role | FTE | Annual Cost |
|------|-----|-------------|
| Cloud Engineer | 1.5 | $225,000 |
| DevOps/SRE | 0.5 | $75,000 |
| **Personnel Subtotal** | **2.0** | **$300,000** |

### Total AWS Annual Cost: $661,000

(With reserved instances: ~$520,000)

---

## Migration Costs (One-Time)

| Category | Item | Cost |
|----------|------|------|
| Data Transfer | Snowball Edge (5 devices) | $15,000 |
| Data Transfer | DataSync (400 TB) | $4,000 |
| Professional Services | AWS ProServe (Foundation) | $50,000 |
| Professional Services | Migration partner | $200,000 |
| Training | AWS certifications (5 people) | $15,000 |
| Infrastructure | Parallel operations (6 months) | $150,000 |
| Testing | Security/compliance assessment | $20,000 |
| **Migration Total** | | **$454,000** |

---

## 5-Year TCO Comparison

### On-Prem TCO

| Year | Run Rate | Refresh Investment | Total |
|------|----------|-------------------|-------|
| 1 | $858,000 | $0 | $858,000 |
| 2 | $858,000 | $0 | $858,000 |
| 3 | $858,000 | $200,000* | $1,058,000 |
| 4 | $858,000 | $0 | $858,000 |
| 5 | $858,000 | $0 | $858,000 |
| **Total** | | | **$4,490,000** |

*Hardware refresh cycle

### AWS TCO

| Year | Run Rate | Migration | Total |
|------|----------|-----------|-------|
| 1 | $800,000* | $454,000 | $1,254,000 |
| 2 | $661,000 | $0 | $661,000 |
| 3 | $520,000** | $0 | $520,000 |
| 4 | $520,000 | $0 | $520,000 |
| 5 | $520,000 | $0 | $520,000 |
| **Total** | | | **$3,475,000** |

*Higher Y1 due to parallel operations
**Reserved instance pricing kicks in

### 5-Year Savings: $1,015,000 (23%)

---

## Sensitivity Analysis

### Optimistic Scenario

| Factor | Impact |
|--------|--------|
| Migrate 3 months faster | -$75,000 |
| 50% reserved instances | -$80,000/year |
| Reduce to 1.5 FTE | -$75,000/year |
| **Total additional savings** | **$530,000** |

### Pessimistic Scenario

| Factor | Impact |
|--------|--------|
| Migration takes 6 months longer | +$150,000 |
| 20% cost overrun | +$132,000/year |
| Need 2.5 FTE | +$75,000/year |
| **Total additional cost** | **$780,000** |

### Break-Even Analysis

Migration pays back in **27 months** under base case.

- Optimistic: 18 months
- Pessimistic: 42 months

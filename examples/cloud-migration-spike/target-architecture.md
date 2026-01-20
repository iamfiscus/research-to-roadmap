# Target AWS Architecture

## Overview

```
                                    ┌─────────────────────────────────────────────────────┐
                                    │                    AWS Cloud                         │
                                    │                                                      │
┌──────────┐    ┌──────────┐       │  ┌─────────────────────────────────────────────┐    │
│ Users    │───▶│CloudFront│───────┼─▶│              Application Load Balancer      │    │
└──────────┘    └──────────┘       │  └──────────────────────┬──────────────────────┘    │
                                   │                         │                            │
                                   │         ┌───────────────┼───────────────┐           │
                                   │         ▼               ▼               ▼           │
                                   │    ┌─────────┐    ┌─────────┐    ┌─────────┐       │
                                   │    │   ECS   │    │   ECS   │    │   ECS   │       │
                                   │    │  (API)  │    │  (Web)  │    │(Workers)│       │
                                   │    └────┬────┘    └────┬────┘    └────┬────┘       │
                                   │         │              │              │             │
                                   │         └──────────────┼──────────────┘             │
                                   │                        │                            │
                                   │    ┌───────────────────┼───────────────────┐       │
                                   │    ▼                   ▼                   ▼       │
                                   │ ┌──────┐          ┌─────────┐        ┌───────┐    │
                                   │ │ RDS  │          │ElastiCa.│        │  SQS  │    │
                                   │ │(PgSQL)│         │ (Redis) │        │       │    │
                                   │ └──────┘          └─────────┘        └───────┘    │
                                   │                                                    │
                                   │ ┌──────────────────────────────────────────────┐  │
                                   │ │                    S3                         │  │
                                   │ │   (Media, Backups, Archives)                  │  │
                                   │ └──────────────────────────────────────────────┘  │
                                   │                                                    │
                                   └────────────────────────────────────────────────────┘
```

## Compute Layer

### ECS Fargate Clusters

| Service | vCPU | Memory | Min/Max | Notes |
|---------|------|--------|---------|-------|
| API | 2 | 4 GB | 6/20 | Auto-scale on CPU |
| Web Frontend | 1 | 2 GB | 4/12 | Auto-scale on requests |
| Background Workers | 2 | 4 GB | 4/16 | Auto-scale on queue depth |
| Internal Tools | 0.5 | 1 GB | 2/4 | Fixed capacity |

**Why ECS Fargate vs EC2**:
- No server management
- Pay per task, not instance
- Simpler scaling
- Team unfamiliar with Kubernetes

### Container Strategy

```dockerfile
# Example: API service
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "app:app", "-w", "4", "-b", "0.0.0.0:8000"]
```

All applications containerized except:
- Legacy payment connector (EC2 initially, modernize in Phase 2)

## Database Layer

### Amazon RDS (PostgreSQL)

| Configuration | Value |
|---------------|-------|
| Instance | db.r6g.4xlarge (16 vCPU, 128 GB) |
| Storage | 10 TB gp3 (provisioned IOPS) |
| Multi-AZ | Yes |
| Read Replicas | 2 (us-east-1b, us-east-1c) |
| Backup | 30-day retention, cross-region |

### Amazon DocumentDB (MongoDB Compatible)

| Configuration | Value |
|---------------|-------|
| Instance | db.r6g.2xlarge (8 vCPU, 64 GB) |
| Storage | 5 TB |
| Replicas | 2 |

**Why DocumentDB vs MongoDB Atlas**:
- Tighter AWS integration
- Familiar MongoDB API
- Simplified operations

### Amazon ElastiCache (Redis)

| Configuration | Value |
|---------------|-------|
| Node Type | r6g.xlarge |
| Nodes | 3 (cluster mode) |
| Multi-AZ | Yes |

## Storage Layer

### S3 Buckets

| Bucket | Storage Class | Size | Use Case |
|--------|---------------|------|----------|
| prod-media | S3 Standard | 250 TB | User uploads |
| prod-assets | S3 Standard | 5 TB | Static assets |
| prod-backups | S3 Standard-IA | 100 TB | Database backups |
| archive | S3 Glacier Deep Archive | 1.8 PB | Compliance archive |

### Data Transfer Strategy

| Data Type | Method | Timeline |
|-----------|--------|----------|
| Active data (300 TB) | AWS DataSync | 4 weeks |
| Archive (1.8 PB) | AWS Snowball Edge | 6-8 weeks |

## Network Layer

### VPC Design

```
VPC: 10.0.0.0/16

├── Public Subnets (ALB, NAT Gateway)
│   ├── us-east-1a: 10.0.1.0/24
│   ├── us-east-1b: 10.0.2.0/24
│   └── us-east-1c: 10.0.3.0/24
│
├── Private Subnets (Application)
│   ├── us-east-1a: 10.0.10.0/24
│   ├── us-east-1b: 10.0.11.0/24
│   └── us-east-1c: 10.0.12.0/24
│
├── Private Subnets (Database)
│   ├── us-east-1a: 10.0.20.0/24
│   ├── us-east-1b: 10.0.21.0/24
│   └── us-east-1c: 10.0.22.0/24
│
└── VPN Subnet (Hybrid connectivity)
    └── us-east-1a: 10.0.100.0/24
```

### Connectivity

| Connection | Type | Purpose |
|------------|------|---------|
| Internet | NAT Gateway (3x) | Outbound from private |
| On-prem | Site-to-Site VPN | Hybrid during migration |
| Payment processor | Site-to-Site VPN | Legacy integration |

## Security Layer

### IAM Strategy

- Service accounts per ECS service
- Least privilege policies
- No long-lived credentials
- SSO via AWS IAM Identity Center

### Network Security

| Layer | Control |
|-------|---------|
| Edge | AWS WAF, Shield Standard |
| VPC | Security Groups, NACLs |
| Application | IAM roles, secrets in Secrets Manager |
| Data | Encryption at rest (KMS), in transit (TLS) |

### Compliance Controls

| Requirement | AWS Service |
|-------------|-------------|
| HIPAA | BAA signed, encryption, audit logging |
| SOC 2 | AWS Artifact, CloudTrail, Config |
| PCI DSS | Isolated payment VPC, logging |

## Observability

### Monitoring Stack

| Function | Service |
|----------|---------|
| Metrics | CloudWatch + Prometheus (ECS) |
| Logs | CloudWatch Logs + OpenSearch |
| Traces | X-Ray |
| Dashboards | CloudWatch + Grafana |
| Alerts | CloudWatch Alarms → SNS → PagerDuty |

## Disaster Recovery

| Component | RPO | RTO | Strategy |
|-----------|-----|-----|----------|
| Application | 0 | 5 min | Multi-AZ, auto-scaling |
| Database | 5 min | 30 min | Multi-AZ, automated failover |
| Storage | 24 hrs | 4 hrs | Cross-region replication |

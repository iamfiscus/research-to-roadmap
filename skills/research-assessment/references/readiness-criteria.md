# Production Readiness Criteria

Detailed scoring rubrics for each readiness criterion.

## Core Hypothesis Validated (Weight: 20%)

**What it measures**: Did the research prove what it set out to prove?

| Score | Description |
|-------|-------------|
| 10 | Hypothesis proven with statistical significance, multiple validation methods |
| 8-9 | Hypothesis proven with clear evidence, reproducible results |
| 6-7 | Hypothesis partially proven, some conditions not tested |
| 4-5 | Mixed results, hypothesis needs refinement |
| 2-3 | Hypothesis not clearly tested, anecdotal evidence only |
| 1 | No validation performed |

**Evidence to look for:**
- Experiment design documentation
- Test results with metrics
- Statistical analysis (if applicable)
- Reproducibility of results
- Edge cases covered

---

## Performance Benchmarks (Weight: 15%)

**What it measures**: Do we understand the performance characteristics?

| Score | Description |
|-------|-------------|
| 10 | Comprehensive benchmarks across all operations, percentiles documented |
| 8-9 | Key operations benchmarked, realistic conditions |
| 6-7 | Some benchmarks exist, but gaps in coverage |
| 4-5 | Limited benchmarks, synthetic conditions only |
| 2-3 | Ad-hoc timing measurements only |
| 1 | No performance data |

**Metrics to document:**
- Latency: p50, p95, p99
- Throughput: requests/second, items/second
- Resource usage: CPU, memory, disk, network
- Startup time
- Degradation under load

---

## Security Considerations (Weight: 15%)

**What it measures**: Have security risks been identified and addressed?

| Score | Description |
|-------|-------------|
| 10 | Security audit completed, all findings addressed |
| 8-9 | Threat model documented, major risks mitigated |
| 6-7 | Security considered, some gaps remain |
| 4-5 | Basic security (auth/authz) only |
| 2-3 | Security deferred, known risks unaddressed |
| 1 | No security consideration |

**Areas to assess:**
- Authentication mechanism
- Authorization/access control
- Data encryption (at rest, in transit)
- Input validation
- Dependency vulnerabilities
- Secret management
- Audit logging

---

## Scalability Tested (Weight: 10%)

**What it measures**: Will it work at production scale?

| Score | Description |
|-------|-------------|
| 10 | Load tested at 10x expected scale, scaling strategy validated |
| 8-9 | Load tested at expected scale, known limits documented |
| 6-7 | Some load testing, scaling approach designed |
| 4-5 | Theoretical scalability analysis only |
| 2-3 | Scalability assumed, no analysis |
| 1 | Single-user/single-instance only |

**Questions to answer:**
- What's the expected load?
- What's the breaking point?
- How do we scale horizontally?
- What are the bottlenecks?
- What's the cost at scale?

---

## Error Handling (Weight: 10%)

**What it measures**: What happens when things fail?

| Score | Description |
|-------|-------------|
| 10 | Comprehensive error handling, graceful degradation, recovery tested |
| 8-9 | Major failure modes handled, retry logic, circuit breakers |
| 6-7 | Error handling exists, some gaps |
| 4-5 | Basic try/catch, errors logged |
| 2-3 | Minimal error handling, fails silently |
| 1 | No error handling, crashes on failure |

**Failure modes to consider:**
- Network failures
- Database unavailable
- External service timeouts
- Invalid input
- Resource exhaustion
- Concurrent access issues

---

## Observability (Weight: 10%)

**What it measures**: Can we monitor and debug in production?

| Score | Description |
|-------|-------------|
| 10 | Full observability stack, dashboards, alerts, distributed tracing |
| 8-9 | Logging, metrics, and basic alerting |
| 6-7 | Structured logging, some metrics |
| 4-5 | Basic logging only |
| 2-3 | Console output only |
| 1 | No observability |

**Components:**
- Structured logging with correlation IDs
- Metrics (counters, gauges, histograms)
- Distributed tracing
- Health checks
- Alerting rules
- Dashboards

---

## Documentation (Weight: 10%)

**What it measures**: Can someone else understand and maintain this?

| Score | Description |
|-------|-------------|
| 10 | Comprehensive docs: architecture, API, runbooks, decision records |
| 8-9 | Good documentation of key areas |
| 6-7 | README and basic docs exist |
| 4-5 | Minimal docs, relies on code comments |
| 2-3 | Scattered notes only |
| 1 | No documentation |

**Documentation needed:**
- Architecture overview
- Setup/installation guide
- API documentation
- Configuration reference
- Runbooks for common operations
- ADRs for key decisions
- Troubleshooting guide

---

## Knowledge Transfer (Weight: 10%)

**What it measures**: Is knowledge spread across the team?

| Score | Description |
|-------|-------------|
| 10 | Multiple people can develop, deploy, and troubleshoot |
| 8-9 | Knowledge shared, backup person identified |
| 6-7 | Primary owner with some knowledge sharing |
| 4-5 | Single owner, documentation exists |
| 2-3 | Single owner, tribal knowledge |
| 1 | Single owner, no documentation |

**Bus factor assessment:**
- How many people can deploy?
- How many people can debug production issues?
- How many people understand the design decisions?
- What happens if the primary owner is unavailable?

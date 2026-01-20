---
name: research-assessment
description: >
  Use this skill when evaluating research projects, POCs, experiments, or prototypes
  for production readiness. Provides the "What Did We Prove?" framework, production
  readiness checklist, and gap analysis matrix for systematic research evaluation.
version: 0.1.0
---

# Research Assessment

Systematically evaluate research artifacts to determine production readiness.

## When to Use

- Evaluating a POC before committing to production build
- Assessing what an experiment actually proved vs assumed
- Identifying gaps between prototype and production requirements
- Creating readiness checklists for stakeholder review
- Analyzing ADRs for implementation implications

## Core Framework: "What Did We Prove?"

Before planning production work, separate fact from assumption:

### Validated (Evidence Exists)
Claims with concrete evidence:
- Test results that passed
- Benchmarks with data
- User feedback collected
- Integration confirmed working

### Assumed (No Direct Test)
Claims we believe but haven't verified:
- "It should scale" (but no load test)
- "Users will want this" (but no validation)
- "Security is fine" (but no audit)

### Unknown (Gap)
Things we don't know:
- Untested edge cases
- Unexplored failure modes
- Missing requirements

## Production Readiness Checklist

Score each criterion 1-10:

| Criterion | Weight | Questions to Ask |
|-----------|--------|------------------|
| Core hypothesis validated | 20% | Did the experiment prove what we set out to prove? |
| Performance benchmarks | 15% | Do we have latency, throughput, resource usage data? |
| Security considerations | 15% | Have we identified and addressed security risks? |
| Scalability tested | 10% | Will it work at 10x, 100x current scale? |
| Error handling | 10% | What happens when things fail? |
| Observability | 10% | Can we monitor and debug in production? |
| Documentation | 10% | Could someone else take this over? |
| Knowledge transfer | 10% | Is knowledge spread across the team? |

**Scoring Guide:**
- 8-10: Production-ready with minor polish
- 6-7: Needs targeted work in specific areas
- 4-5: Significant gaps requiring substantial effort
- 1-3: Research phase, not ready for production planning

## Gap Analysis Matrix

Use this template to map what's proven vs unknown:

| Domain | Proven | Assumed | Unknown |
|--------|--------|---------|---------|
| **Functionality** | Feature X works | Feature Y will work similarly | Edge case behavior |
| **Performance** | 100ms p50 latency | Will scale linearly | Performance under load |
| **Security** | Auth works | No vulnerabilities | Penetration test results |
| **Scalability** | Works for 100 users | Will work for 10K | Actual breaking point |
| **Operations** | Can deploy manually | Automation will work | Rollback procedure |
| **Integration** | API contract defined | Will integrate smoothly | Error handling at boundaries |

## Red Flags Checklist

Watch for these patterns that indicate low readiness:

- [ ] Happy path only - no error handling
- [ ] Hardcoded values that need configuration
- [ ] "TODO" comments for critical functionality
- [ ] No tests or only manual testing
- [ ] Single contributor (bus factor = 1)
- [ ] Missing logging/monitoring hooks
- [ ] No documentation of design decisions
- [ ] Untested third-party dependencies
- [ ] Security considerations deferred
- [ ] No rollback or recovery plan

## Output Template

```markdown
# Research Assessment: [Project Name]

## Executive Summary
[2-3 sentences: what this is, key finding, readiness score]

## What Did We Prove?

### Validated Hypotheses
- **[Hypothesis]**: [Evidence] (Confidence: High/Medium/Low)

### Key Findings
1. [Finding with evidence]

## Production Readiness: X/10

| Criterion | Score | Notes |
|-----------|-------|-------|
| Core hypothesis | X | |
| Performance | X | |
| Security | X | |
| Scalability | X | |
| Error handling | X | |
| Observability | X | |
| Documentation | X | |
| Knowledge transfer | X | |

## Gap Analysis

| Domain | Proven | Assumed | Unknown |
|--------|--------|---------|---------|
| ... | ... | ... | ... |

## Risks & Technical Debt
- [Item with severity]

## Recommended Next Steps
1. [Action]
```

## Progressive Validation Ramp

Before investing in production readiness, projects must pass increasingly rigorous gates.
Apply the **"80% of experiments should fail"** philosophy:

| Gate | Kill Rate | Key Question |
|------|-----------|--------------|
| Idea → Internal Build | ~40% | Is the problem real and worth solving? |
| Internal → Private Preview | ~30% | Have we built something worth testing externally? |
| Private → Public Preview | ~30% | Are external users getting value? |
| Public → GA | ~10% | Are we ready to bet the company reputation? |

See `references/graduation-criteria.md` for detailed gate requirements.

## References

See `references/` for:
- `readiness-criteria.md` - Detailed scoring rubrics
- `common-gaps.md` - Typical gaps by project type
- `graduation-criteria.md` - Gate criteria and kill decisions (GitHub Next patterns)
- `rfc-templates.md` - Google, Uber, Sourcegraph RFC formats

See `examples/` for:
- `poc-assessment-example.md` - Vector Search POC with full "What Did We Prove?" framework
- `gate-review-example.md` - Internal Build → Private Preview graduation checklist

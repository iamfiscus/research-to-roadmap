# RFC Templates

Request for Comments (RFC) templates used by tech companies for research-to-production transitions.

## When to Use RFCs

| Stage | Document Type |
|-------|---------------|
| Exploring options | Design Doc / RFC |
| Made a decision | ADR (Architecture Decision Record) |
| Planning implementation | Technical Spec |
| Explaining to users | Documentation |

**RFC is appropriate when:**
- Multiple valid approaches exist
- Decision affects multiple teams
- Trade-offs need documentation
- You want async feedback before committing

---

## Template 1: Google-Style Design Doc

Used at Google, inspired many other companies.

```markdown
# [Project Name] Design Document

**Author(s)**: [Names]
**Status**: Draft | Review | Approved | Implemented | Deprecated
**Created**: YYYY-MM-DD
**Last Updated**: YYYY-MM-DD
**Reviewers**: [Names]

## Objective

[1-2 sentences: What problem are we solving? Why now?]

## Background

[Context the reader needs to understand the proposal. Keep brief—link to
other docs for deep background.]

## Goals and Non-Goals

### Goals
- [Goal 1]
- [Goal 2]

### Non-Goals
- [Explicitly out of scope 1]
- [Explicitly out of scope 2]

## Proposed Solution

### Overview

[High-level description of the approach in 2-3 paragraphs]

### Detailed Design

[Technical details. Include:
- System components
- Data flow
- API contracts
- Database schema changes
- Key algorithms]

### Alternatives Considered

#### Alternative A: [Name]

**Description**: [What it is]
**Pros**: [Benefits]
**Cons**: [Drawbacks]
**Why not chosen**: [Reason]

#### Alternative B: [Name]

[Same structure]

## Cross-Cutting Concerns

### Security

[Security implications and mitigations]

### Privacy

[Privacy implications and handling]

### Observability

[Monitoring, logging, alerting approach]

### Rollout Plan

[How will this be deployed? Feature flags? Percentage rollout?]

### Rollback Plan

[How do we undo this if it goes wrong?]

## Timeline

| Milestone | Date | Description |
|-----------|------|-------------|
| Design approved | YYYY-MM-DD | RFC approved |
| Implementation complete | YYYY-MM-DD | Code merged |
| Rollout start | YYYY-MM-DD | Begin deployment |
| GA | YYYY-MM-DD | Available to all users |

## Open Questions

- [ ] [Question 1]
- [ ] [Question 2]

## References

- [Link to related docs]
- [Link to prior art]
```

---

## Template 2: Uber-Style RFC

Focused on async decision-making with clear ownership.

```markdown
# RFC: [Title]

| Field | Value |
|-------|-------|
| RFC Number | RFC-XXXX |
| Status | Draft / Under Review / Accepted / Rejected / Superseded |
| Author | [Name] |
| Shepherd | [Name - senior person guiding the RFC] |
| Created | YYYY-MM-DD |
| Decision Due | YYYY-MM-DD |

## TL;DR

[One paragraph summary that someone could share in Slack]

## Motivation

### Problem Statement

[What's broken or missing?]

### Current State

[How do we handle this today? What's painful?]

### Desired State

[What would good look like?]

## Proposal

### Summary

[2-3 paragraph overview]

### Details

[Technical specification. As detailed as needed for reviewers
to make an informed decision.]

### Migration Path

[How do we get from current state to proposed state?]

## Impact Analysis

### Teams Affected

| Team | Impact | Required Changes |
|------|--------|------------------|
| [Team A] | High | [Changes needed] |
| [Team B] | Low | [Minor adjustments] |

### Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk] | Med | High | [Plan] |

### Cost

- Engineering effort: [T-shirt size]
- Infrastructure cost: [$X/month estimated]
- Maintenance burden: [Low/Med/High]

## Alternatives

### Option A: [Name]
[Description, pros, cons]

### Option B: [Name]
[Description, pros, cons]

### Comparison Matrix

| Criterion | Proposal | Option A | Option B |
|-----------|----------|----------|----------|
| Engineering effort | M | L | XL |
| Risk | Low | Med | Low |
| Scalability | High | Med | High |
| **Recommendation** | ✅ | | |

## Decision

**Status**: [Pending / Accepted / Rejected]
**Decision Date**: YYYY-MM-DD
**Decision Maker(s)**: [Names]
**Rationale**: [Why this decision was made]

## Appendix

### FAQ

**Q: [Common question]**
A: [Answer]

### Glossary

| Term | Definition |
|------|------------|
| [Term] | [Definition] |
```

---

## Template 3: Sourcegraph-Style RFC (Lightweight)

Optimized for speed and iteration.

```markdown
# RFC [Number]: [Title]

**Status**: WIP | In Review | Approved | Done | Abandoned
**Author**: @[github-username]
**Created**: YYYY-MM-DD

## Problem

[2-3 sentences describing the problem]

## Solution

[2-3 sentences describing the proposed solution]

## Rationale

### Why this solution?

[Key reasons for this approach]

### Why not [alternative]?

[Brief explanation]

## Implementation

### Scope

- [In scope item]
- [In scope item]

### Out of Scope

- [Explicitly excluded]

### Tasks

- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

### Timeline

- Start: YYYY-MM-DD
- Target completion: YYYY-MM-DD

## Risks

- [Risk 1 and mitigation]
- [Risk 2 and mitigation]

## Success Metrics

- [How we know this worked]

---

## Discussion

[Reviewers add comments below]

### @[reviewer1] YYYY-MM-DD
[Comment]

### @[reviewer2] YYYY-MM-DD
[Comment]
```

---

## Template 4: Experiment Spec (Labs-Specific)

For hypothesis-driven research projects.

```markdown
# Experiment: [Name]

**Status**: Proposed | Running | Complete | Killed
**Owner**: [Name]
**Start Date**: YYYY-MM-DD
**End Date**: YYYY-MM-DD (or "Until killed")

## Hypothesis

We believe that [capability/feature]
will result in [outcome]
for [target users]
because [rationale].

We will know this is true when we see [measurable signal].

## Background

[Why are we testing this? What prompted the experiment?]

## Design

### What We're Building

[Description of the experiment implementation]

### Test Conditions

| Group | Treatment | Size |
|-------|-----------|------|
| Control | [Current state] | [%] |
| Test A | [Variation A] | [%] |
| Test B | [Variation B] | [%] |

### Success Metrics

| Metric | Baseline | Target | Minimum Detectable Effect |
|--------|----------|--------|---------------------------|
| [Primary metric] | [X] | [Y] | [Z%] |
| [Secondary metric] | [X] | [Y] | [Z%] |

### Guardrail Metrics

[Metrics that should NOT degrade]

| Metric | Threshold |
|--------|-----------|
| [Metric] | No more than [X%] decrease |

## Kill Criteria

Automatically kill the experiment if:
- [Condition 1]
- [Condition 2]

## Analysis Plan

[How will we analyze results? Statistical method?]

## Results

### Summary

[Filled in when experiment completes]

### Data

[Key data and charts]

### Learnings

[What did we learn?]

### Recommendation

[ ] Ship: Roll out to 100%
[ ] Iterate: Run another experiment with [changes]
[ ] Kill: Do not proceed because [reason]

## References

- [Prior experiments]
- [Related research]
```

---

## Template Selection Guide

| Scenario | Recommended Template |
|----------|----------------------|
| Major architectural decision | Google-style Design Doc |
| Cross-team coordination | Uber-style RFC |
| Quick feature proposal | Sourcegraph-style RFC |
| Labs/research project | Experiment Spec |
| Urgent decision needed | Sourcegraph-style RFC |
| Compliance/security implications | Google-style Design Doc |

## Best Practices

### Writing

1. **Lead with TL;DR** - Busy readers should get the point in 30 seconds
2. **Be explicit about scope** - What's NOT included is as important as what IS
3. **Show your work** - Document alternatives considered and why rejected
4. **Make it actionable** - Clear next steps and owners

### Review Process

1. **Set a deadline** - Open-ended reviews stall
2. **Identify decision makers** - Who has final say?
3. **Async first** - Written feedback before meetings
4. **Document decisions** - Update RFC with resolution

### Maintenance

1. **Update status** - Mark RFCs as implemented/deprecated
2. **Link forward** - Reference RFCs from code/docs
3. **Archive don't delete** - Historical context is valuable

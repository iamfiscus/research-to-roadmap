---
name: adr-to-prod
description: >
  Use this skill when transitioning Architecture Decision Records (ADRs) into
  production implementations. Provides ADR parsing patterns, task breakdown
  templates, and health check frameworks for ADR-to-production workflows.
version: 0.1.0
---

# ADR to Production

Workflows for implementing Architecture Decision Records in production.

## When to Use

- Planning implementation of an accepted ADR
- Breaking an ADR into implementation tasks
- Validating ADR assumptions during implementation
- Checking if an existing ADR is still valid
- Tracking ADR outcomes post-implementation

## ADR Structure Overview

Standard ADR sections and their implementation implications:

| Section | Purpose | Implementation Impact |
|---------|---------|----------------------|
| **Title** | Decision name | Feature/epic name |
| **Status** | Proposed/Accepted/Deprecated | Go/no-go for implementation |
| **Context** | Why this decision | Requirements and constraints |
| **Decision** | What we decided | Core implementation scope |
| **Consequences** | What follows | Tasks, risks, follow-up work |

## ADR Parsing Patterns

Extract actionable information from ADRs:

### Context Extraction

From the Context section, identify:
- **Constraints**: Hard limits that must be respected
- **Requirements**: Must-have functionality
- **Triggers**: What caused this decision
- **Stakeholders**: Who cares about this decision

```markdown
## Context Analysis

### Constraints Identified
- [Constraint 1]: [Impact on implementation]
- [Constraint 2]: [Impact on implementation]

### Requirements
- [Requirement 1]: [How to validate]
- [Requirement 2]: [How to validate]

### Stakeholders
- [Stakeholder 1]: [What they need]
```

### Decision Extraction

From the Decision section, identify:
- **Core deliverable**: What must be built
- **Approach**: How it will be built
- **Boundaries**: What's in scope vs out

```markdown
## Decision Analysis

### Core Deliverable
[What the ADR mandates we build]

### Approach
[Technical approach specified or implied]

### Scope Boundaries
- In scope: [Items]
- Out of scope: [Items]
- Ambiguous: [Items needing clarification]
```

### Consequences Extraction

From Consequences section, identify:
- **Positive outcomes**: Expected benefits
- **Negative outcomes**: Trade-offs accepted
- **Follow-up work**: Required future tasks

```markdown
## Consequences Analysis

### Benefits to Validate
- [Benefit 1]: [How we'll measure]

### Trade-offs to Monitor
- [Trade-off 1]: [Acceptable threshold]

### Follow-up Tasks
- [Task 1]: [When needed]
```

## ADR → Task Breakdown

Convert ADR into implementation tasks:

### Step 1: Identify Work Streams

From the ADR, identify parallel work streams:
- Core implementation
- Integration points
- Migration needs
- Documentation
- Testing strategy

### Step 2: Break Down Each Stream

For each work stream, create tasks:

```markdown
## Task Breakdown: [ADR Title]

### Stream 1: Core Implementation
| Task | Size | Dependencies | Success Criteria |
|------|------|--------------|------------------|
| [Task 1] | M | - | [Criterion] |
| [Task 2] | S | Task 1 | [Criterion] |

### Stream 2: Integration
| Task | Size | Dependencies | Success Criteria |
|------|------|--------------|------------------|
| [Task 1] | L | Core complete | [Criterion] |

### Stream 3: Migration
[If applicable...]

### Stream 4: Documentation
| Task | Size | Dependencies | Success Criteria |
|------|------|--------------|------------------|
| Update API docs | S | Core complete | Docs published |
| Write runbook | M | Integration complete | Runbook reviewed |

### Stream 5: Testing
| Task | Size | Dependencies | Success Criteria |
|------|------|--------------|------------------|
| Unit tests | M | Core implementation | Coverage >80% |
| Integration tests | M | Integration | All scenarios pass |
| Load testing | L | Full implementation | Meets SLOs |
```

### Step 3: Map to Milestones

Group tasks into milestones:

```markdown
## Milestone Mapping

### Milestone 1: Foundation (H1)
- [ ] Task from Stream 1
- [ ] Task from Stream 1
Success: [How we know M1 is done]

### Milestone 2: Integration (H1)
- [ ] Task from Stream 2
- [ ] Task from Stream 4
Success: [How we know M2 is done]

### Milestone 3: Production Ready (H2)
- [ ] Task from Stream 5
- [ ] Task from Stream 3
Success: [How we know M3 is done]
```

## ADR Health Check

Validate if an ADR is still valid:

### Health Check Questions

| Question | Status | Notes |
|----------|--------|-------|
| Is the context still accurate? | ✅/⚠️/❌ | |
| Is the decision still the right choice? | ✅/⚠️/❌ | |
| Have the predicted consequences occurred? | ✅/⚠️/❌ | |
| Are there new constraints not considered? | ✅/⚠️/❌ | |
| Has technology changed significantly? | ✅/⚠️/❌ | |
| Are stakeholder needs still the same? | ✅/⚠️/❌ | |

### Health Status

- **✅ Healthy**: ADR is valid, proceed with implementation
- **⚠️ Needs Review**: Some aspects changed, update ADR before proceeding
- **❌ Superseded**: ADR should be deprecated, new decision needed

### Health Check Template

```markdown
# ADR Health Check: [ADR Title]

**Check Date**: [Date]
**Original Decision Date**: [Date]
**Time Since Decision**: [Duration]

## Context Validation

**Original Context:**
[Summary of original context]

**Current Context:**
[What's changed]

**Status**: ✅/⚠️/❌

## Decision Validation

**Original Decision:**
[Summary of decision]

**Still Valid?**: Yes/No/Partially

**Alternatives Considered Since:**
[Any new options that emerged]

**Status**: ✅/⚠️/❌

## Consequences Validation

| Predicted Consequence | Occurred? | Notes |
|----------------------|-----------|-------|
| [Consequence 1] | Yes/No/Partial | |
| [Consequence 2] | Yes/No/Partial | |

**Unexpected Consequences:**
- [If any]

**Status**: ✅/⚠️/❌

## Overall Health: ✅/⚠️/❌

**Recommendation:**
- [ ] Proceed with implementation
- [ ] Update ADR before proceeding
- [ ] Deprecate and create new ADR
- [ ] Defer decision

**Notes:**
[Any additional context]
```

## Assumption Tracking

Track ADR assumptions through implementation:

```markdown
## Assumption Register: [ADR Title]

| ID | Assumption | Confidence | Validation Method | Status | Finding |
|----|------------|------------|-------------------|--------|---------|
| A1 | [Assumption] | High/Med/Low | [How to test] | Open/Validated/Invalid | |
| A2 | [Assumption] | High/Med/Low | [How to test] | Open/Validated/Invalid | |

### Validation Schedule

| Assumption | Validate By | Owner |
|------------|-------------|-------|
| A1 | [Date/Milestone] | [Name] |
| A2 | [Date/Milestone] | [Name] |

### Invalid Assumption Response

If an assumption is invalidated:
1. Document finding
2. Assess impact on ADR
3. Update ADR if needed
4. Adjust implementation plan
```

## ADR Outcome Documentation

After implementation, document results:

```markdown
# ADR Outcome: [ADR Title]

**Implementation Completed**: [Date]
**Decision Made**: [Original Date]
**Implementation Duration**: [Duration]

## Was the Decision Correct?

**Assessment**: Yes/Partially/No

**Evidence:**
- [Evidence supporting assessment]

## Predicted vs Actual Consequences

| Predicted | Actual | Match? |
|-----------|--------|--------|
| [Consequence 1] | [What happened] | ✅/⚠️/❌ |
| [Consequence 2] | [What happened] | ✅/⚠️/❌ |

## Lessons Learned

### What Worked
- [Lesson 1]

### What Didn't Work
- [Lesson 1]

### What We'd Do Differently
- [Suggestion 1]

## Follow-up ADRs Needed

- [ ] [ADR topic 1]: [Why needed]
- [ ] [ADR topic 2]: [Why needed]
```

## References

See `references/` for:
- `adr-templates.md` - Standard ADR templates
- `common-adr-patterns.md` - Patterns in ADR structure

See `examples/` for:
- `adr-breakdown-example.md` - JWT auth ADR broken into implementation tasks
- `adr-template-madr.md` - MADR format template with production breakdown

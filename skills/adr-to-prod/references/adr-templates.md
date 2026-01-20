# ADR Templates

Standard templates for Architecture Decision Records.

## Basic ADR Template

```markdown
# ADR-XXX: [Title]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-YYY]

## Context

[What is the issue that we're seeing that motivates this decision or change?]

## Decision

[What is the change that we're proposing and/or doing?]

## Consequences

[What becomes easier or more difficult to do because of this change?]
```

## Extended ADR Template

For complex decisions requiring more detail:

```markdown
# ADR-XXX: [Title]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-YYY]

**Date**: YYYY-MM-DD
**Deciders**: [List of people involved in decision]
**Technical Story**: [Ticket/Issue link]

## Context and Problem Statement

[Describe the context and problem statement, e.g., in free form using two to three sentences. You may want to articulate the problem in form of a question.]

## Decision Drivers

* [Driver 1, e.g., a force, facing concern, …]
* [Driver 2, e.g., a force, facing concern, …]
* …

## Considered Options

* [Option 1]
* [Option 2]
* [Option 3]
* …

## Decision Outcome

**Chosen option**: "[Option X]", because [justification. e.g., only option which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative Consequences

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options

### [Option 1]

[example | description | pointer to more information | …]

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* …

### [Option 2]

[example | description | pointer to more information | …]

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* …

## Links

* [Link type] [Link to ADR]
* …
```

## Research-to-Production ADR Template

Specialized for R&D decisions transitioning to production:

```markdown
# ADR-XXX: [Research Finding] → Production

## Status

[Proposed | Accepted | Deprecated | Superseded]

**Research Phase**: [POC | Experiment | Prototype | Spike]
**Research Dates**: [Start] to [End]
**Decision Date**: YYYY-MM-DD

## Research Context

### What We Explored
[Summary of research conducted]

### Key Findings
* [Finding 1 with evidence]
* [Finding 2 with evidence]
* …

### What We Proved
* [Validated hypothesis 1]
* [Validated hypothesis 2]

### What Remains Unproven
* [Assumption 1]
* [Assumption 2]

## Production Context

### Why Now
[Why are we moving to production now vs. more research?]

### Constraints
* [Constraint 1]
* [Constraint 2]

### Success Criteria
* [Measurable criterion 1]
* [Measurable criterion 2]

## Decision

[What approach are we taking for production?]

### Scope
**In Scope:**
* [Item 1]
* [Item 2]

**Out of Scope:**
* [Item 1]
* [Item 2]

**Deferred:**
* [Item 1] - [When to revisit]

## Implementation Path

### Phase 1: [Name]
* [Deliverable 1]
* [Deliverable 2]

### Phase 2: [Name]
* [Deliverable 1]
* [Deliverable 2]

## Consequences

### Benefits (Expected)
* [Benefit 1]
* [Benefit 2]

### Trade-offs (Accepted)
* [Trade-off 1]
* [Trade-off 2]

### Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [Risk 1] | Med | High | [Action] |

### Technical Debt Created
* [Debt item 1] - [When to address]

## Validation Plan

| Assumption | How to Validate | By When |
|------------|-----------------|---------|
| [Assumption 1] | [Method] | [Date] |

## Links

* Research: [Link to research artifacts]
* Implementation: [Link to implementation plan/tickets]
* Related ADRs: [Link to related decisions]
```

## ADR Update Template

For updating existing ADRs:

```markdown
# ADR-XXX Update: [Title]

## Original Decision

[Link to or summary of original ADR]

**Original Date**: YYYY-MM-DD
**Update Date**: YYYY-MM-DD

## What Changed

### Context Changes
* [Change 1]
* [Change 2]

### New Information
* [Information 1]
* [Information 2]

## Updated Decision

[What's changing in the decision?]

## Updated Consequences

### New Positive Consequences
* [Consequence 1]

### New Negative Consequences
* [Consequence 1]

### Consequences No Longer Relevant
* [Consequence 1] - [Why]

## Migration Path

[If the update affects existing implementation, how do we migrate?]

## Links

* Original ADR: [Link]
* Related tickets: [Links]
```

## ADR Deprecation Template

For marking ADRs as no longer valid:

```markdown
# ADR-XXX: [Title]

## Status

**DEPRECATED** - See ADR-YYY

**Original Date**: YYYY-MM-DD
**Deprecation Date**: YYYY-MM-DD

## Deprecation Reason

[Why is this ADR no longer valid?]

## Replacement

**Superseded by**: ADR-YYY

**Key Changes**:
* [Change 1]
* [Change 2]

## Migration Notes

[Any notes for migrating from old decision to new]

---

## Original Content (Archived)

[Original ADR content preserved below for reference]

...
```

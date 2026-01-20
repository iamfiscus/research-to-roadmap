# Common ADR Patterns

Patterns and anti-patterns in Architecture Decision Records.

## Good ADR Patterns

### 1. The "Why Not" Pattern

Best ADRs explain not just the decision, but why alternatives weren't chosen.

**Example:**
```markdown
## Considered Options

### Option 1: PostgreSQL
* Good: Mature, excellent query capabilities, team familiarity
* Bad: Operational overhead for our scale

### Option 2: DynamoDB (Chosen)
* Good: Managed service, scales automatically, fits our access patterns
* Bad: Limited query flexibility, vendor lock-in

### Option 3: MongoDB
* Good: Flexible schema, good for rapid iteration
* Bad: Less team familiarity, operational complexity

## Why DynamoDB

We chose DynamoDB because:
1. Our access patterns are key-value with known queries (fits DynamoDB well)
2. We prioritize operational simplicity over query flexibility
3. AWS is our primary platform (acceptable vendor alignment)

We didn't choose PostgreSQL because:
- We'd need to manage scaling ourselves
- Our queries are simple enough that PostgreSQL's power is overkill

We didn't choose MongoDB because:
- Team would need significant training
- No strong advantage over DynamoDB for our use case
```

### 2. The "Decision Drivers" Pattern

Explicitly list what factors drove the decision:

```markdown
## Decision Drivers

1. **Performance**: Must handle 10K req/sec
2. **Cost**: Must stay under $5K/month
3. **Team Skills**: Team knows Python and AWS
4. **Time**: Must ship in 6 weeks
5. **Maintainability**: Must be supportable by on-call engineer

## How Options Score

| Driver | Option A | Option B | Option C |
|--------|----------|----------|----------|
| Performance | ✅ | ✅ | ⚠️ |
| Cost | ⚠️ | ✅ | ✅ |
| Team Skills | ✅ | ❌ | ✅ |
| Time | ⚠️ | ❌ | ✅ |
| Maintainability | ✅ | ✅ | ⚠️ |

**Winner**: Option C - Best balance across all drivers
```

### 3. The "Reversibility" Pattern

Classify decisions by how hard they are to change:

```markdown
## Reversibility Assessment

**Type**: One-way door / Two-way door

### One-way door (Hard to reverse):
- Database schema decisions
- Public API contracts
- Data deletion policies

### Two-way door (Easy to reverse):
- Implementation details
- Internal service interfaces
- Configuration choices

This decision is a **[one-way/two-way] door** because [reason].

**If this is a one-way door:**
- We've done extra validation: [what]
- Fallback plan: [plan]
- Point of no return: [milestone]
```

### 4. The "Assumption Tracker" Pattern

Explicitly track assumptions:

```markdown
## Assumptions

| ID | Assumption | Confidence | Validate By | Impact if Wrong |
|----|------------|------------|-------------|-----------------|
| A1 | Traffic will stay under 10K/sec | High | Load test | Need to redesign |
| A2 | Team can learn Go in 2 weeks | Medium | Week 1 spike | Timeline slip |
| A3 | Vendor API is reliable | Low | Monitoring | Need fallback |

### High-Risk Assumptions (Confidence: Low/Medium)

**A2: Team can learn Go in 2 weeks**
- Validation: Dedicate week 1 to Go training spike
- If invalid: Switch to Python, accept performance trade-off
- Decision point: End of week 1

**A3: Vendor API is reliable**
- Validation: 2-week monitoring before going live
- If invalid: Implement circuit breaker and cache
- Decision point: Before production rollout
```

## ADR Anti-Patterns

### 1. The "TLDR" Anti-Pattern

**Problem:** ADR is too short, missing critical context.

```markdown
# Bad Example

## Context
We need a database.

## Decision
We'll use PostgreSQL.

## Consequences
Good database choice.
```

**Why it's bad:**
- No constraints mentioned
- No alternatives considered
- No success criteria
- Impossible to understand "why"

### 2. The "Novel" Anti-Pattern

**Problem:** ADR is so long no one reads it.

**Why it's bad:**
- Key points buried in text
- Hard to reference later
- Sign of unclear thinking

**Fix:** Use bullet points, tables, and clear structure.

### 3. The "Missing Alternatives" Anti-Pattern

**Problem:** Only one option presented.

```markdown
# Bad Example

## Considered Options
* PostgreSQL

## Decision
PostgreSQL
```

**Why it's bad:**
- No evidence of actual decision process
- Can't evaluate if decision was sound
- Looks like predetermined conclusion

### 4. The "No Consequences" Anti-Pattern

**Problem:** Only positive consequences listed.

```markdown
# Bad Example

## Consequences
* Fast database
* Easy to use
* Good choice
```

**Why it's bad:**
- Every decision has trade-offs
- Hiding downsides creates surprises
- Can't plan for mitigation

### 5. The "Stale Context" Anti-Pattern

**Problem:** ADR context no longer matches reality.

**Signs:**
- References deprecated technology
- Assumes team composition that changed
- Based on outdated constraints

**Fix:** Regular ADR health checks (quarterly)

### 6. The "Implementation Detail" Anti-Pattern

**Problem:** ADR records implementation, not architecture.

```markdown
# Bad Example
# ADR: Use forEach instead of for loop
```

**Why it's bad:**
- Too granular for ADR
- Clutters decision record
- Not an architectural decision

**Rule:** If it can change without affecting other components, it's probably not ADR-worthy.

## ADR Lifecycle Patterns

### New → Accepted → Implemented → Validated

```
┌──────────┐    ┌──────────┐    ┌─────────────┐    ┌───────────┐
│ Proposed │───▶│ Accepted │───▶│ Implemented │───▶│ Validated │
└──────────┘    └──────────┘    └─────────────┘    └───────────┘
                     │                                    │
                     ▼                                    ▼
               ┌──────────┐                        ┌───────────┐
               │ Rejected │                        │Superseded │
               └──────────┘                        └───────────┘
```

### Health Check Triggers

Run ADR health check when:
- 6 months since acceptance
- Major team change
- Technology landscape shift
- Significant new requirements
- Implementation difficulties suggest wrong decision
- Post-incident review identifies ADR issues

# Progressive Validation Ramp

A framework for validating research projects through increasingly rigorous gates, based on GitHub Next, Linear, and other successful labs programs.

## Core Philosophy

**"The goal is to learn, not to ship."**

Most research projects should fail. Progressive validation ensures:
1. Failures happen early (cheap)
2. Resources focus on validated bets
3. Learning is captured regardless of outcome

## The Validation Pyramid

```
                    ▲
                   /│\      GA
                  / │ \     5% make it here
                 /  │  \
                /   │   \   Public Preview
               /    │    \  15% make it here
              /     │     \
             /      │      \ Private Preview
            /       │       \ 30% make it here
           /        │        \
          /         │         \ Internal Build
         /          │          \ 60% make it here
        /           │           \
       ─────────────┴────────────
       All Ideas    │
       100%         │
```

## Validation Gates

### Gate 0: Idea → Internal Build

**Checkpoint**: Should we spend any time on this?

**Time investment**: 0 → 2-4 weeks
**Kill rate**: ~40% of ideas

#### Validation Questions
| Question | Good Signal | Bad Signal |
|----------|-------------|------------|
| Is the problem real? | Multiple users report it | Single anecdote |
| Is it worth solving? | High impact for target users | Nice-to-have |
| Can we do it? | Technical path exists | Requires breakthrough |
| Should we do it? | Aligns with strategy | Tangential to mission |

#### Minimum Validation
- [ ] Problem validated with 3+ users
- [ ] Solution hypothesized
- [ ] Rough complexity estimate (T-shirt)
- [ ] No obvious blockers identified

---

### Gate 1: Internal Build → Private Preview

**Checkpoint**: Have we built something worth testing externally?

**Time investment**: 2-4 weeks → 4-8 weeks
**Kill rate**: ~30% at this gate

#### Validation Questions
| Question | Good Signal | Bad Signal |
|----------|-------------|------------|
| Does it work? | Core flow completes | Frequent failures |
| Do internals use it? | 5+ weekly active | Team avoids it |
| Is feedback positive? | "When can I get more?" | "It's fine" |
| Can we support it? | Clear support path | Unknown operational burden |

#### Evidence Required
| Dimension | Minimum Evidence |
|-----------|------------------|
| Functionality | Core user flow works end-to-end |
| Quality | No critical bugs in happy path |
| Performance | Acceptable for small scale (<1s response) |
| Security | No obvious vulnerabilities |
| Usability | 3+ users complete task unassisted |

#### Metrics to Collect
- Daily/weekly active internal users
- Task completion rate
- Time to complete key action
- Bug count by severity
- Qualitative feedback themes

---

### Gate 2: Private Preview → Public Preview

**Checkpoint**: Are external users getting value?

**Time investment**: 4-8 weeks → 6-16 weeks
**Kill rate**: ~30% at this gate

#### Validation Questions
| Question | Good Signal | Bad Signal |
|----------|-------------|------------|
| Product-market fit? | Users return without prompting | High churn |
| Scalable? | Works for 100+ users | Breaks under load |
| Supportable? | <1 ticket per 10 users | Support overwhelmed |
| Differentiated? | Users prefer over alternatives | "Similar to X" |

#### Evidence Required
| Dimension | Minimum Evidence |
|-----------|------------------|
| Adoption | 50+ active users, growing week-over-week |
| Retention | >50% return within 7 days |
| Engagement | >30% complete key action |
| Satisfaction | NPS >30 or equivalent |
| Performance | Meets SLOs at current scale |
| Security | Passed security review |

#### Metrics to Track
- User acquisition and activation funnel
- Cohort retention (day 1, 7, 30)
- Feature usage breadth and depth
- Support ticket volume and themes
- Performance percentiles (p50, p95, p99)

---

### Gate 3: Public Preview → General Availability

**Checkpoint**: Are we ready to bet the company reputation?

**Time investment**: 6-16 weeks → ongoing
**Kill rate**: ~10% at this gate (but pivots common)

#### Validation Questions
| Question | Good Signal | Bad Signal |
|----------|-------------|------------|
| Proven at scale? | Works at 10x current load | Untested at scale |
| Commercially viable? | Unit economics work | Unsustainable costs |
| Competitively strong? | Clear differentiation | Commodity feature |
| Operationally ready? | Full support/ops coverage | Team bandwidth maxed |

#### Evidence Required
| Dimension | Minimum Evidence |
|-----------|------------------|
| Scale | Load tested at 10x current usage |
| Reliability | 99.9% uptime over 4+ weeks |
| Security | External audit passed |
| Documentation | Complete user and API docs |
| Support | Trained support team, runbooks complete |
| Business | Pricing validated, revenue model clear |

#### Metrics for GA
- Revenue or usage targets
- Customer satisfaction (CSAT, NPS)
- Support resolution time
- SLA compliance
- Churn rate

---

## Kill Decisions

### When to Kill

**Hard kills** (immediate stop):
- Critical security vulnerability with no fix path
- Legal/compliance blocker
- Executive deprioritization
- Core hypothesis disproven

**Soft kills** (wind down):
- Metrics consistently below targets
- Support burden unsustainable
- Better alternative discovered
- Team lacks enthusiasm

### How to Kill Well

1. **Document learnings** - What did we learn? What would we do differently?
2. **Communicate clearly** - Tell users, stakeholders, team
3. **Archive artifacts** - Keep code/docs accessible for future reference
4. **Celebrate the learning** - Killing is not failure; not learning is failure

### Kill Communication Template

```markdown
# Sunsetting [Feature]

We're discontinuing [Feature] effective [date].

## Why
[Honest explanation - poor adoption, better alternatives, strategic shift]

## What We Learned
- [Learning 1]
- [Learning 2]

## For Current Users
- [Migration path or alternatives]
- [Data export instructions]
- [Support during transition]

## Timeline
- [Date]: Announcement
- [Date]: New signups disabled
- [Date]: Feature removed

## Questions?
Contact [support/team]
```

---

## Validation Velocity

### Fast vs. Slow Validation

| Factor | Fast Validation | Slow Validation |
|--------|-----------------|-----------------|
| Blast radius | Low (isolated feature) | High (core functionality) |
| Reversibility | Easy to rollback | Hard to undo |
| User impact | Limited users affected | Many users affected |
| Complexity | Simple, contained | Complex, interdependent |

### Accelerating Validation

| Technique | When to Use |
|-----------|-------------|
| Wizard of Oz | Validate demand before building |
| Fake door test | Measure interest via CTA clicks |
| Concierge MVP | High-touch manual version first |
| A/B test | Incremental improvements to existing features |
| Design partner | Close collaboration with friendly customer |

---

## Metrics Framework

### Leading Indicators (Early Warning)

| Metric | What It Tells You | Action if Bad |
|--------|-------------------|---------------|
| Activation rate | Is onboarding working? | Improve first-time UX |
| Day 1 retention | Did users get value? | Improve time-to-value |
| Feature usage | Are users finding features? | Improve discovery |
| Error rate | Is it stable? | Fix quality issues |

### Lagging Indicators (Confirm/Deny)

| Metric | What It Tells You | Action if Bad |
|--------|-------------------|---------------|
| Day 30 retention | Sustained value? | Re-evaluate product-market fit |
| NPS | Would they recommend? | Investigate detractors |
| Support volume | Is it supportable? | Improve docs or UX |
| Revenue/usage | Commercial viability? | Adjust pricing or pivot |

### The Metrics Stack

```
                 BUSINESS METRICS
                 (Revenue, Growth)
                        ↑
                 PRODUCT METRICS
              (Retention, Engagement)
                        ↑
                FEATURE METRICS
              (Usage, Task Completion)
                        ↑
                QUALITY METRICS
              (Performance, Errors)
```

Track all levels. Business metrics lag; quality metrics lead.

---

## Decision Log Template

Track validation decisions for learning:

```markdown
# Validation Decision: [Project] - Gate [N]

**Date**: YYYY-MM-DD
**Decision**: GO / NO-GO / CONDITIONAL

## Summary
[1-2 sentences on decision and rationale]

## Evidence Reviewed

### Quantitative
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| [Metric] | [X] | [Y] | ✅/❌ |

### Qualitative
- [User feedback theme 1]
- [User feedback theme 2]

## Risks Accepted
- [Risk 1]: Mitigated by [action]
- [Risk 2]: Accepted because [rationale]

## Conditions (if conditional)
- [ ] [Condition that must be met]
- [ ] [Timeline for review]

## Next Review
- **Date**: YYYY-MM-DD
- **Criteria**: [What we'll evaluate]

## Decision Makers
- [Name]: [Vote/Input]
```

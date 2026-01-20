# Graduation Criteria Checklist

Based on patterns from GitHub Next, Linear, Vercel, Figma, and other tech companies' labs programs.

## Philosophy

**"80% of experiments should fail."** — GitHub Next

Research projects should fail fast. The goal isn't to ship everything—it's to learn quickly and only graduate projects with clear evidence of success.

## The Progressive Validation Ramp

Before investing in production readiness, projects must pass increasingly rigorous gates:

```
     ┌─────────────────────────────────────────────────────────────┐
     │                    KILL PERCENTAGE                          │
     │                                                             │
100% ─┼─ █████████████████████████████████████████████████████     │
     │    ~40% killed here                                        │
     │                    █████████████████████████████            │
 50% ─┼─                    ~30% killed here                       │
     │                                      ████████████           │
     │                                        ~10% killed          │
 20% ─┼─                                               █████       │
     │                                                  Final      │
     └─────────────────────────────────────────────────────────────┘
        Internal     Limited      Public        General
         Build      Preview      Preview      Availability
```

**Key principle**: Kill projects early and often. Cheaper to fail at Internal Build than after Public Preview.

---

## Gate 1: Internal Build → Limited Preview

**Timeline**: After 2-4 weeks of internal development

### Technical Criteria
- [ ] Core hypothesis validated with evidence
- [ ] Basic functionality works for happy path
- [ ] No obvious security vulnerabilities
- [ ] Can deploy to internal environment
- [ ] Basic monitoring/logging in place

### Product Criteria
- [ ] Clear problem statement documented
- [ ] Target users identified
- [ ] Success metrics defined
- [ ] Initial feedback from 3+ internal users
- [ ] Comparison to alternatives documented

### Go/No-Go Decision
| Signal | Go | No-Go |
|--------|-------|--------|
| Internal usage | 5+ daily active internal users | <5 or declining |
| NPS/feedback | Positive sentiment | "Nice to have" or negative |
| Technical feasibility | Path to production clear | Major unknowns remain |
| Strategic fit | Aligns with company direction | Tangential to strategy |

---

## Gate 2: Limited Preview → Public Preview

**Timeline**: After 4-8 weeks of limited preview

### Technical Criteria
- [ ] All critical bugs fixed
- [ ] Performance at target (see benchmarks)
- [ ] Security review completed (or scheduled)
- [ ] Error handling for all major failure modes
- [ ] Observability stack complete (logs, metrics, traces)
- [ ] Documentation for users complete
- [ ] Rollback procedure tested

### Product Criteria
- [ ] 10+ external users actively using
- [ ] User engagement metrics meeting targets
- [ ] Support volume manageable (<1 ticket per 10 users/week)
- [ ] Feature requests gathered and prioritized
- [ ] Competitive positioning validated

### Data Criteria
- [ ] Retention: >50% weekly return rate
- [ ] Activation: >30% complete key action
- [ ] Usage: >3 sessions per user per week (avg)
- [ ] Satisfaction: NPS >30 or equivalent

### Go/No-Go Decision
| Signal | Go | No-Go |
|--------|-------|--------|
| User retention | >50% week-over-week | <50% or declining |
| Feature usage | >70% use core feature | <70% engagement |
| Support burden | <1 ticket per 10 users | >1 ticket per 10 users |
| Technical debt | Manageable, planned | Accumulating, blocking |

---

## Gate 3: Public Preview → General Availability

**Timeline**: After 8-12 weeks of public preview

### Technical Criteria
- [ ] Load tested at 10x current usage
- [ ] All P0/P1 bugs fixed
- [ ] Security audit passed (external or internal)
- [ ] Compliance requirements met (SOC2, GDPR, etc.)
- [ ] SLA commitments defined and achievable
- [ ] On-call rotation established
- [ ] Runbooks for all common scenarios
- [ ] Feature flags removable (no longer needed)

### Product Criteria
- [ ] 100+ active users in public preview
- [ ] User testimonials/case studies gathered
- [ ] Pricing model validated (if applicable)
- [ ] Documentation complete (getting started, API, troubleshooting)
- [ ] Marketing materials ready

### Business Criteria
- [ ] Revenue/cost model sustainable
- [ ] Resource plan for post-launch support
- [ ] Competitive differentiation clear
- [ ] Sales/support training complete
- [ ] Integration with existing products (if applicable)

### Data Criteria
- [ ] Retention: >60% week-over-week
- [ ] Activation: >40% complete key action
- [ ] Expansion: >20% increase usage over time
- [ ] NPS: >40 or equivalent

---

## Kill Criteria

**Automatic kill triggers** (any one is sufficient to stop):

| Category | Kill Signal |
|----------|-------------|
| Usage | <5 weekly active users after 4 weeks |
| Engagement | <10% return rate week-over-week |
| Sentiment | NPS <0 after 4+ weeks |
| Technical | Critical security flaw with no fix path |
| Strategic | Executive deprioritization |
| Resource | Team unable to support alongside other work |

**Soft kill signals** (require discussion):

- Usage plateaus well below target
- Support burden exceeds capacity
- Technical debt accumulating faster than repaid
- Team enthusiasm declining
- Better alternative discovered

---

## Decision Framework

### The Pre-Mortem

Before each gate review, answer: **"The project failed because..."**

| If the answer is... | Then... |
|---------------------|---------|
| "We couldn't find product-market fit" | Need more user validation before proceeding |
| "Technical complexity was too high" | Need to simplify scope or add resources |
| "We ran out of time/resources" | Need to cut scope or extend timeline |
| "Leadership deprioritized it" | Need to confirm strategic alignment now |
| "Users found better alternatives" | Need competitive analysis |
| "Security/compliance issues blocked us" | Need security review before proceeding |

### Commitment Levels

| Level | Meaning | Resource Commitment |
|-------|---------|---------------------|
| **Exploration** | Learning, not committed | 1 person, time-boxed |
| **Validation** | Testing hypothesis | 1-2 people, milestones |
| **Investment** | Building for production | Full team, roadmap |
| **Scale** | Expanding proven solution | Growth resources |

**Important**: Projects should explicitly move between levels. No "permanent exploration."

---

## Company Pattern Examples

### GitHub Next Pattern
- Kill experiments at 2 weeks if no internal traction
- Publish learnings publicly regardless of outcome
- Separate lab identity from main product

### Linear Pattern
- Tight feedback loops (release weekly)
- Public roadmap creates accountability
- Founder-led quality bar

### Vercel Pattern
- Framework-first approach (validate in open source)
- Preview deployments validate with real users
- Edge function labs test infrastructure

### Figma Pattern
- Plugin ecosystem validates feature demand
- FigJam as separate product validates adjacencies
- Community-driven prioritization

---

## Checklist Template

Use this template for gate reviews:

```markdown
# Gate Review: [Project Name]

**Current Stage**: Internal Build / Limited Preview / Public Preview
**Target Stage**: Limited Preview / Public Preview / GA
**Review Date**: YYYY-MM-DD

## Summary
[2-3 sentences: current state, key metrics, recommendation]

## Criteria Assessment

### Technical
- [ ] Criterion 1: [Status] [Evidence]
- [ ] Criterion 2: [Status] [Evidence]

### Product
- [ ] Criterion 1: [Status] [Evidence]

### Data
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Retention | >50% | X% | ✅/❌ |
| Activation | >30% | X% | ✅/❌ |

## Pre-Mortem
"This project failed because..."
- [Risk 1]
- [Risk 2]

## Recommendation
[ ] GO - Proceed to [next stage]
[ ] CONDITIONAL - Proceed if [conditions met]
[ ] NO-GO - [Kill / Extend current stage / Pivot]

## Action Items
1. [Action]
2. [Action]
```

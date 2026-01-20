# Timeline Estimation

How to estimate milestone duration for research-to-production roadmaps.

## T-Shirt Sizing Baseline

Start with standard sizes, adjust for context:

| Size | Duration | Typical Scope |
|------|----------|---------------|
| **S** | 1-2 weeks | Single feature, well-understood, one person |
| **M** | 2-4 weeks | Feature set, some unknowns, 1-2 people |
| **L** | 4-8 weeks | Complex feature, coordination needed, 2-4 people |
| **XL** | 8-12 weeks | Major deliverable, multiple teams, significant risk |
| **XXL** | 12+ weeks | Consider breaking down |

## Buffer Factors

**By horizon certainty:**
- H1 (high certainty): +20% buffer
- H2 (medium certainty): +30% buffer
- H3 (low certainty): +50% buffer

**By project phase:**
- Greenfield: +30% (unknowns)
- Migration: +40% (hidden complexity)
- Integration: +25% (coordination overhead)
- Optimization: +20% (measurable scope)

## Estimation Techniques

### Three-Point Estimation

For each milestone, estimate:
- **Optimistic (O):** Everything goes right
- **Most Likely (M):** Typical scenario
- **Pessimistic (P):** Things go wrong

**Expected = (O + 4M + P) / 6**

Example:
- Optimistic: 2 weeks
- Most Likely: 3 weeks
- Pessimistic: 6 weeks
- Expected: (2 + 12 + 6) / 6 = 3.3 weeks

### Reference Class Forecasting

Compare to similar past projects:

1. Find 3-5 similar projects
2. Note their actual duration
3. Average and adjust for differences

| Similar Project | Estimated | Actual | Ratio |
|-----------------|-----------|--------|-------|
| Project A | 4 weeks | 6 weeks | 1.5x |
| Project B | 3 weeks | 4 weeks | 1.3x |
| Project C | 5 weeks | 7 weeks | 1.4x |
| **Average ratio** | | | **1.4x** |

Apply ratio to current estimate.

## Complexity Multipliers

Adjust baseline for complexity factors:

| Factor | Multiplier | When to Apply |
|--------|------------|---------------|
| New technology | 1.3x | Learning curve |
| External dependency | 1.2x | Coordination overhead |
| Security requirements | 1.2x | Reviews, audits |
| Compliance needs | 1.3x | Process overhead |
| Multiple stakeholders | 1.2x | Alignment time |
| Team distributed | 1.1x | Communication overhead |
| Legacy integration | 1.4x | Hidden complexity |

**Example:**
- Base estimate: 3 weeks
- New technology: 3 × 1.3 = 3.9 weeks
- External dependency: 3.9 × 1.2 = 4.7 weeks
- Final: ~5 weeks

## Calendar vs. Effort

Distinguish between:
- **Effort:** Person-days of work
- **Calendar:** Wall-clock time

**Factors affecting calendar time:**
- Team availability (holidays, PTO)
- Part-time allocation
- Review/approval cycles
- External dependencies
- Context switching

**Rule of thumb:** Calendar = Effort × 1.5 for full-time, × 2-3 for part-time

## Common Estimation Traps

### Planning Fallacy
**Problem:** Underestimate based on best case
**Solution:** Use reference class forecasting, add buffer

### Scope Creep Blindness
**Problem:** Assume scope won't change
**Solution:** Build in flex points, define scope boundaries

### Coordination Undercount
**Problem:** Forget time for meetings, reviews, handoffs
**Solution:** Add 20% for coordination overhead

### Testing Afterthought
**Problem:** Estimate coding only
**Solution:** Include testing in every estimate (often 30-50% of coding)

### Integration Optimism
**Problem:** Assume integration will "just work"
**Solution:** Dedicated integration milestone with buffer

## Estimation Checklist

Before finalizing a milestone estimate:

- [ ] Base estimate uses T-shirt size or similar past work
- [ ] Buffer added for horizon certainty level
- [ ] Complexity multipliers applied
- [ ] Calendar time accounts for team availability
- [ ] Testing time included
- [ ] Review/approval cycles accounted for
- [ ] Integration time considered
- [ ] External dependencies have contingency time

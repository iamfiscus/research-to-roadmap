# Gate Review Example: Internal Build → Private Preview

Demonstrates the graduation criteria checklist for phase transition.

---

# Gate Review: AI Code Review Feature

**Current Stage**: Internal Build
**Target Stage**: Private Preview
**Review Date**: 2024-02-15

## Summary

AI code review feature has been used internally for 4 weeks with positive feedback. 12 team members using daily. Ready to invite external design partners with conditions.

## Criteria Assessment

### Technical
- [x] Core hypothesis validated with evidence: 73% of AI suggestions accepted by reviewers
- [x] Basic functionality works for happy path: PR review flow complete
- [x] No obvious security vulnerabilities: No code execution, read-only access
- [x] Can deploy to internal environment: Running on staging
- [x] Basic monitoring/logging in place: CloudWatch logs, basic dashboard

### Product
- [x] Clear problem statement documented: "Reduce time to first review by 50%"
- [x] Target users identified: Teams with >5 PRs/day
- [x] Success metrics defined: Time-to-review, acceptance rate, user satisfaction
- [x] Initial feedback from 3+ internal users: 12 active users, NPS 45
- [ ] Comparison to alternatives documented: **MISSING - need competitive analysis**

### Data

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Daily active internal users | 5+ | 12 | ✅ |
| Task completion rate | >80% | 91% | ✅ |
| NPS | >30 | 45 | ✅ |
| P0 bugs | 0 | 0 | ✅ |

## Pre-Mortem

"This project failed because..."

1. **External users found suggestions unhelpful for their codebase**
   - Mitigation: Start with design partners using similar tech stack

2. **Rate limits hit during high-traffic periods**
   - Mitigation: Implement queuing before private preview

3. **Security concerns blocked enterprise adoption**
   - Mitigation: Schedule security review before expanding beyond design partners

## Kill Criteria Check

| Trigger | Status |
|---------|--------|
| <5 weekly active users after 4 weeks | ✅ Pass (12 WAU) |
| <10% return rate week-over-week | ✅ Pass (85% retention) |
| NPS <0 after 4+ weeks | ✅ Pass (NPS 45) |
| Critical security flaw | ✅ Pass (none found) |

## Recommendation

[x] **CONDITIONAL GO** - Proceed to Private Preview if:
- [ ] Competitive analysis document completed (by 2024-02-22)
- [ ] Rate limiting implemented (by 2024-02-25)
- [ ] Design partner agreements signed (3 minimum)

[ ] NO-GO

## Action Items

1. @sarah: Complete competitive analysis by Feb 22
2. @mike: Implement rate limiting with Redis by Feb 25
3. @pm: Reach out to 5 potential design partners, close 3
4. @security: Schedule security review for March

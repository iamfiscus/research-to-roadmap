# Release Phases

Patterns for progressive release from research to general availability, based on GitHub, Google, and enterprise software practices.

## The Four-Phase Model

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Internal   │ -> │   Private    │ -> │   Public     │ -> │   General    │
│    Build     │    │   Preview    │    │   Preview    │    │ Availability │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
     Alpha              Beta             Early Access            GA
    Dogfood            Limited           Open Beta            Launch
```

### Phase Characteristics

| Phase | Audience | Support | SLA | Breaking Changes |
|-------|----------|---------|-----|------------------|
| Internal Build | Team only | None | None | Frequent |
| Private Preview | Invited users | Best effort | None | Expected |
| Public Preview | Self-service | Standard | Limited | Possible with notice |
| GA | Everyone | Full | Yes | Rarely, with migration path |

---

## Phase 1: Internal Build (Alpha/Dogfood)

**Duration**: 2-6 weeks

### Who
- Development team
- Internal stakeholders
- Friendly colleagues

### Purpose
- Validate core hypothesis
- Find obvious bugs
- Test basic workflows
- Build initial documentation

### Entry Criteria
- [ ] Core feature works end-to-end
- [ ] Can deploy to internal environment
- [ ] Basic monitoring in place
- [ ] Team can demo to stakeholders

### Exit Criteria
- [ ] 5+ internal users using weekly
- [ ] No critical bugs in core workflow
- [ ] Performance acceptable for limited use
- [ ] Documentation draft exists

### Artifacts
- Internal deployment
- Basic README
- Bug list/backlog
- Initial metrics baseline

---

## Phase 2: Private Preview (Beta/Limited)

**Duration**: 4-12 weeks

### Who
- Waitlist users (50-500)
- Design partners
- Strategic customers
- Early adopters

### Purpose
- Validate product-market fit
- Gather structured feedback
- Test at small scale
- Identify gaps before public launch

### Entry Criteria
- [ ] Internal build stable
- [ ] All P0 bugs fixed
- [ ] Security review scheduled
- [ ] Support process defined
- [ ] Feedback mechanism in place

### Exit Criteria
- [ ] 100+ weekly active users
- [ ] NPS > 30 (or equivalent)
- [ ] Support volume manageable
- [ ] Key metrics meeting targets
- [ ] Security review passed

### Artifacts
- Private preview environment
- User documentation
- Feedback survey
- Usage analytics dashboard
- Support runbook

### Communication Template

```markdown
# [Feature] Private Preview

We're excited to invite you to the private preview of [Feature].

## What's Available
- [Capability 1]
- [Capability 2]

## What to Expect
- Features may change based on feedback
- Occasional downtime for updates
- No SLA during preview period

## How to Give Feedback
- In-app feedback button
- Email: [team@company.com]
- Slack: #[channel]

## Known Limitations
- [Limitation 1]
- [Limitation 2]
```

---

## Phase 3: Public Preview (Early Access/Open Beta)

**Duration**: 6-16 weeks

### Who
- Anyone who signs up
- Self-service access
- Public documentation

### Purpose
- Validate at scale
- Stress test infrastructure
- Finalize pricing (if applicable)
- Build social proof

### Entry Criteria
- [ ] Private preview successful
- [ ] Documentation complete
- [ ] Security audit passed
- [ ] Load tested at 10x current scale
- [ ] Pricing validated (if applicable)
- [ ] Support team trained

### Exit Criteria
- [ ] 1,000+ weekly active users (or target)
- [ ] NPS > 40 (or equivalent)
- [ ] SLA targets achievable
- [ ] No critical issues for 2+ weeks
- [ ] Feature flag dependencies identified

### Artifacts
- Public documentation
- API reference
- Getting started guide
- Case studies / testimonials
- Pricing page (if applicable)
- Support knowledge base

### Communication Template

```markdown
# [Feature] Public Preview

[Feature] is now available in public preview. Try it today!

## Getting Started
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Pricing
[Free during preview / Preview pricing / etc.]

## Support
- Documentation: [link]
- Community forum: [link]
- Support tickets: [link]

## Feedback
We're still iterating! Share feedback: [mechanism]

## Preview Terms
- Features may change before GA
- Limited SLA (see [link])
- Data migration support when GA launches
```

---

## Phase 4: General Availability (GA/Launch)

**Duration**: Ongoing

### Who
- Everyone
- Full marketing
- Sales enablement

### Purpose
- Stable, supported product
- Revenue (if applicable)
- Customer success

### Entry Criteria
- [ ] Public preview successful
- [ ] All launch blockers resolved
- [ ] SLA commitments defined
- [ ] Support fully staffed
- [ ] Marketing materials ready
- [ ] Sales training complete
- [ ] On-call rotation established

### What Changes at GA
| Aspect | Preview | GA |
|--------|---------|-----|
| SLA | Best effort | Committed uptime |
| Support | Community/limited | Full support channels |
| Breaking changes | With notice | Major version only |
| Pricing | Preview/free | Full pricing |
| Documentation | Good | Comprehensive |

### Communication Template

```markdown
# Announcing [Feature] General Availability

After X months in preview, [Feature] is now generally available.

## What's New Since Preview
- [Improvement 1]
- [Improvement 2]
- [Feedback-driven change]

## Key Features
- [Feature 1]: [Benefit]
- [Feature 2]: [Benefit]

## Migration for Preview Users
[Any changes preview users need to make]

## Pricing
[Full pricing details]

## Get Started
[CTA]
```

---

## Feature Flag Lifecycle

Feature flags enable progressive release. Follow this lifecycle:

### Flag Stages

```
Create -> Develop -> Test -> Rollout -> Cleanup
   │         │        │        │          │
   v         v        v        v          v
 Flag     Enable    Enable   Increase   Remove
created   in dev    in test   % users    flag
```

### Rollout Percentages

| Stage | Percentage | Duration | Purpose |
|-------|------------|----------|---------|
| Initial | 0% | Development | Build feature |
| Internal | 100% internal | 1-2 weeks | Dogfood |
| Canary | 1% | 1-3 days | Catch critical issues |
| Beta | 5-10% | 1-2 weeks | Validate at scale |
| Rollout | 25% -> 50% -> 100% | 1-2 weeks each | Progressive release |
| Cleanup | Remove flag | After 2-4 weeks at 100% | Code hygiene |

### Flag Naming Convention

```
[project]_[feature]_[version]
Examples:
- search_ai_suggestions_v2
- checkout_one_click_v1
- admin_bulk_actions_beta
```

### Flag Cleanup Checklist

After GA, flags become technical debt. Schedule cleanup:

- [ ] Feature at 100% for 2+ weeks
- [ ] No rollback needed
- [ ] Remove flag checks from code
- [ ] Delete flag from management system
- [ ] Update documentation (remove "beta" labels)

---

## Phase Timing Guidelines

### Minimum Durations

| Project Size | Internal | Private | Public | Total |
|--------------|----------|---------|--------|-------|
| Small (1 eng) | 2 weeks | 4 weeks | 4 weeks | 10 weeks |
| Medium (2-3 eng) | 4 weeks | 6 weeks | 8 weeks | 18 weeks |
| Large (team) | 6 weeks | 12 weeks | 12 weeks | 30 weeks |

### When to Compress

- Urgent business need (but document risks)
- Simple feature with low blast radius
- Strong signals from limited preview

### When to Extend

- Negative feedback signals
- Technical issues discovered
- Insufficient user adoption
- Security concerns

---

## Release Communication Matrix

| Audience | Internal | Private | Public | GA |
|----------|----------|---------|--------|-----|
| Engineering | Slack + demo | Slack + doc | Email + doc | All-hands |
| Company | None | Exec update | Internal blog | All-hands + blog |
| Customers | None | Direct invite | Blog + email | Launch campaign |
| Public | None | None | Blog (optional) | Full launch |

---

## Rollback Procedures

Each phase needs a rollback plan:

### Internal Build
- Revert deployment
- No external communication needed

### Private Preview
- Feature flag to 0%
- Email affected users
- Post incident report internally

### Public Preview
- Feature flag to 0%
- Status page update
- Blog post if significant
- Email to active users

### GA
- Feature flag to previous stable %
- Status page update
- Incident communication
- Customer success outreach
- Post-mortem and RCA

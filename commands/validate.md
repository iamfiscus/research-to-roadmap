---
name: validate
description: Stress-test the roadmap with pre-mortem analysis to catch blind spots, unrealistic assumptions, and risks
argument-hint: "[roadmap-path] (default: .r2r/04-roadmap.md)"
allowed-tools:
  - Read
  - Write
  - Task
---

# Roadmap Validation (Pre-Mortem)

Stress-test the roadmap to identify blind spots and risks before committing.

## Workflow

1. **Read roadmap**: Load `.r2r/04-roadmap.md`
2. **Run pre-mortem**: Imagine the project failed - why?
3. **Challenge assumptions**: List all assumptions and test validity
4. **Check dependencies**: Verify dependency chain is realistic
5. **Assess resources**: Validate resource availability
6. **Generate warnings**: Categorize issues by severity
7. **Write output**: Save to `.r2r/05-validation.md`

## Pre-Mortem Framework

**Premise**: "It's 6 months from now. The project failed. What went wrong?"

Categories of failure:
1. **Technical**: Underestimated complexity, wrong architecture, scaling issues
2. **Resource**: Not enough people, wrong skills, competing priorities
3. **Timeline**: Unrealistic dates, dependency delays, scope creep
4. **External**: Market changes, dependency on external parties, regulatory
5. **Organizational**: Stakeholder misalignment, priority shifts, team changes

## Output Format

Write to `.r2r/05-validation.md`:

```markdown
---
phase: validation
created: [ISO timestamp]
source: .r2r/04-roadmap.md
critical_issues: [count]
warnings: [count]
validation_status: pass | caution | fail
status: complete
---

# Roadmap Validation: [Project Name]

## Validation Summary

**Status**: ✅ PASS | ⚠️ CAUTION | ❌ FAIL

**Critical Issues**: [X]
**Warnings**: [X]
**Notes**: [X]

### Quick Assessment

| Category | Status | Notes |
|----------|--------|-------|
| Technical Feasibility | ✅/⚠️/❌ | |
| Resource Availability | ✅/⚠️/❌ | |
| Timeline Realism | ✅/⚠️/❌ | |
| Dependency Chain | ✅/⚠️/❌ | |
| Stakeholder Alignment | ✅/⚠️/❌ | |

## Pre-Mortem Analysis

### "The project failed because..."

#### Technical Failures
1. **[Failure mode]**: [Why this could happen]
   - Probability: High/Medium/Low
   - Mitigation: [What to do about it]

2. **[Failure mode]**: [Why this could happen]
   - Probability: High/Medium/Low
   - Mitigation: [What to do about it]

#### Resource Failures
1. **[Failure mode]**: [Why this could happen]
   - Probability: High/Medium/Low
   - Mitigation: [What to do about it]

#### Timeline Failures
1. **[Failure mode]**: [Why this could happen]
   - Probability: High/Medium/Low
   - Mitigation: [What to do about it]

#### External Failures
1. **[Failure mode]**: [Why this could happen]
   - Probability: High/Medium/Low
   - Mitigation: [What to do about it]

#### Organizational Failures
1. **[Failure mode]**: [Why this could happen]
   - Probability: High/Medium/Low
   - Mitigation: [What to do about it]

## Assumption Audit

| Assumption | Confidence | Evidence | Risk if Wrong |
|------------|------------|----------|---------------|
| [Assumption 1] | High/Med/Low | [What supports this] | [Impact] |
| [Assumption 2] | High/Med/Low | [What supports this] | [Impact] |

### High-Risk Assumptions (Require Validation)

1. **[Assumption]**
   - Why risky: [explanation]
   - How to validate: [action]
   - Deadline to validate: [date]

## Dependency Validation

### Internal Dependencies
| Dependency | Status | Risk | Contingency |
|------------|--------|------|-------------|
| [Dep 1] | ✅ Confirmed / ⚠️ Uncertain / ❌ Blocked | |

### External Dependencies
| Dependency | Owner | Status | Risk |
|------------|-------|--------|------|
| [Dep 1] | [Team/Vendor] | [status] | |

## Resource Reality Check

### Required vs. Available

| Resource | Required | Available | Gap |
|----------|----------|-----------|-----|
| Engineers | X | Y | Z |
| Time | X weeks | Y weeks | Z weeks |
| Budget | $X | $Y | $Z |

### Competing Priorities

- [Other project 1]: [Impact on this roadmap]
- [Other project 2]: [Impact on this roadmap]

## Critical Issues (Must Address)

### Issue 1: [Title]
- **Severity**: Critical
- **Description**: [What's wrong]
- **Impact**: [What happens if ignored]
- **Recommendation**: [What to do]

### Issue 2: [Title]
[...]

## Warnings (Should Address)

### Warning 1: [Title]
- **Severity**: Warning
- **Description**: [What's concerning]
- **Recommendation**: [Suggested action]

## Validation Checklist

- [ ] All critical issues have mitigation plans
- [ ] High-risk assumptions have validation paths
- [ ] External dependencies have contingencies
- [ ] Resource gaps are acknowledged
- [ ] Stakeholders aligned on risks

## Recommendations

### Proceed If:
- [Condition 1]
- [Condition 2]

### Do Not Proceed Until:
- [Blocker 1 resolved]
- [Blocker 2 resolved]

### Suggested Roadmap Adjustments
1. [Adjustment 1]
2. [Adjustment 2]
```

## State Update

Update `.r2r/state.json`:

```json
{
  "current_phase": "validation",
  "completed_phases": ["assessment", "decomposition", "prioritization", "roadmap", "validation"],
  "last_updated": "[ISO timestamp]",
  "validation_status": "pass|caution|fail",
  "critical_issues": [count],
  "warnings": [count]
}
```

## Validation Status Criteria

- **PASS**: 0 critical issues, ≤3 warnings, all high-risk assumptions have validation plans
- **CAUTION**: 1-2 critical issues with mitigations, or >3 warnings
- **FAIL**: >2 critical issues, or any critical issue without mitigation

## Graduation Gate Check

Include graduation criteria validation per phase:

### Phase Gate Assessment

```markdown
## Phase Gate: [Current Phase] → [Next Phase]

### Graduation Criteria
| Criterion | Target | Actual | Status |
|-----------|--------|--------|--------|
| Active users | 50+ | [X] | ✅/❌ |
| Retention | >50% | [X]% | ✅/❌ |
| Support volume | <1/10 users | [X] | ✅/❌ |
| NPS | >30 | [X] | ✅/❌ |
| P0 bugs | 0 | [X] | ✅/❌ |

### Pre-Mortem: "The project failed because..."
- [Risk 1]
- [Risk 2]

### Recommendation
[ ] GO - Proceed to [next phase]
[ ] CONDITIONAL - Proceed if [conditions]
[ ] NO-GO - [Kill / Extend / Pivot]
```

### Kill Criteria Check

**Automatic kill triggers** (flag if any apply):
- [ ] <5 weekly active users after 4 weeks
- [ ] <10% return rate week-over-week
- [ ] NPS <0 after 4+ weeks
- [ ] Critical security flaw with no fix path
- [ ] Executive deprioritization

## Tips

- Be pessimistic in pre-mortem - that's the point
- Every critical issue needs a concrete mitigation, not "we'll figure it out"
- If validation status is FAIL, do not proceed to export without addressing issues
- Include the pre-mortem findings in stakeholder communications
- Reference `graduation-criteria.md` for detailed phase gate criteria
- **"80% of experiments should fail"** - killing is not failure, not learning is failure

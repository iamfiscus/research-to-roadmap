# Feature Flag Lifecycle Example

Demonstrates the complete lifecycle of a feature flag from creation to cleanup.

---

## Feature: AI-Powered Search Suggestions

### Flag Definition

```yaml
name: search_ai_suggestions_v2
description: Show AI-generated search suggestions as user types
owner: search-team
created: 2024-01-15
target_cleanup: 2024-04-15
```

### Stage 1: Development (Week 1-2)

**Flag State**: OFF everywhere

```javascript
// Feature flag check in code
if (featureFlags.isEnabled('search_ai_suggestions_v2', { userId })) {
  return getAISuggestions(query);
} else {
  return getKeywordSuggestions(query);
}
```

**Rollout**: 0%
**Monitoring**: Development metrics only

---

### Stage 2: Internal Testing (Week 3-4)

**Flag State**: ON for internal users only

```yaml
rules:
  - if: user.email ends_with "@company.com"
    then: enabled
  - else: disabled
```

**Rollout**: 100% internal, 0% external
**Monitoring**:
- Error rate
- Latency p50/p95/p99
- Suggestion acceptance rate

**Exit Criteria**:
- [ ] No P0 bugs
- [ ] Latency <100ms p95
- [ ] 5+ internal users tested

---

### Stage 3: Canary (Week 5)

**Flag State**: 1% of external users

```yaml
rules:
  - if: user.email ends_with "@company.com"
    then: enabled
  - if: percentage(1)
    then: enabled
  - else: disabled
```

**Rollout**: 1%
**Duration**: 3-5 days
**Monitoring**:
- Compare error rates: canary vs control
- Compare latency: canary vs control
- Watch for anomalies

**Exit Criteria**:
- [ ] No increase in error rate
- [ ] Latency within 10% of control
- [ ] No critical alerts

**Rollback Trigger**: Error rate >1% or latency >2x baseline

---

### Stage 4: Beta (Week 6-7)

**Flag State**: 10% of external users

```yaml
rules:
  - if: user.email ends_with "@company.com"
    then: enabled
  - if: percentage(10)
    then: enabled
  - else: disabled
```

**Rollout**: 10%
**Duration**: 1-2 weeks
**Monitoring**:
- User engagement metrics
- Support ticket volume
- A/B test results

**Exit Criteria**:
- [ ] Statistically significant improvement in engagement
- [ ] Support volume <1 ticket per 100 users
- [ ] No degradation in core metrics

---

### Stage 5: Progressive Rollout (Week 8-10)

**Rollout Schedule**:

| Day | Percentage | Hold Duration | Decision Point |
|-----|------------|---------------|----------------|
| 1 | 25% | 3 days | Check metrics, proceed or hold |
| 4 | 50% | 3 days | Check metrics, proceed or hold |
| 7 | 75% | 3 days | Check metrics, proceed or hold |
| 10 | 100% | - | Monitor for 2 weeks |

**Monitoring**: Full production metrics
**Rollback**: Instant via flag disable

---

### Stage 6: Stable (Week 11-14)

**Flag State**: 100% for 2+ weeks

**Verification**:
- [ ] Feature stable at 100% for 14 days
- [ ] No rollbacks needed
- [ ] Metrics meeting targets
- [ ] No planned changes to feature

**Decision**: Ready for cleanup ✅

---

### Stage 7: Cleanup (Week 15-16)

**Tasks**:

1. **Remove flag checks from code**
```javascript
// Before (remove this)
if (featureFlags.isEnabled('search_ai_suggestions_v2', { userId })) {
  return getAISuggestions(query);
} else {
  return getKeywordSuggestions(query);
}

// After (keep this)
return getAISuggestions(query);
```

2. **Delete old code path**
- Remove `getKeywordSuggestions()` function
- Remove related tests for old path

3. **Delete flag from system**
```bash
feature-flags delete search_ai_suggestions_v2
```

4. **Update documentation**
- Remove "beta" labels
- Update API docs
- Update changelog

5. **PR and deploy**
- Single PR with all cleanup
- Deploy during low-traffic window
- Monitor for 24 hours

**Cleanup Checklist**:
- [ ] All flag checks removed from code
- [ ] Old code path deleted
- [ ] Tests updated
- [ ] Flag deleted from management system
- [ ] Documentation updated
- [ ] Deployed and verified

---

## Flag Naming Convention

```
[domain]_[feature]_[version]

Examples:
- search_ai_suggestions_v2
- checkout_one_click_v1
- admin_bulk_actions_beta
- api_rate_limit_v3
```

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Permanent flags | Tech debt accumulates | Set cleanup date at creation |
| Nested flags | Complex logic, hard to reason | One flag per feature |
| Flag in flag | Impossible to test all combos | Flatten to single flag |
| No owner | Orphaned flags | Require owner at creation |
| No metrics | Can't make decisions | Define metrics upfront |

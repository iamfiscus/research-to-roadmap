# POC Findings

## Model Comparison

### Detection Accuracy by Category

| Category | GPT-4 | GPT-3.5 | Claude 2 |
|----------|-------|---------|----------|
| SQL Injection | 92% | 67% | 89% |
| XSS Vulnerabilities | 85% | 58% | 82% |
| Auth Bypass | 78% | 41% | 75% |
| Hardcoded Secrets | 95% | 88% | 94% |
| N+1 Queries | 71% | 34% | 68% |
| Memory Leaks | 63% | 29% | 61% |
| **Overall Security** | **73%** | **45%** | **70%** |

### False Positive Rates

| Model | False Positives | Notes |
|-------|-----------------|-------|
| GPT-4 | 18% | Most FPs on complex async patterns |
| GPT-3.5 | 34% | High FP rate makes it impractical |
| Claude 2 | 21% | Similar to GPT-4, slightly more verbose |

### Cost Analysis (per 100 PRs)

| Model | Input Tokens | Output Tokens | Cost |
|-------|--------------|---------------|------|
| GPT-4 | 450K | 85K | $15.20 |
| GPT-3.5 | 450K | 92K | $0.95 |
| Claude 2 | 450K | 78K | $12.40 |

**Recommendation**: GPT-4 for production. Cost difference vs Claude 2 is marginal, but GPT-4 has better API reliability and faster response times.

## What Worked Well

### 1. Specialized Prompts
Breaking reviews into focused categories (security, performance, style) dramatically improved accuracy vs. single "review everything" prompt.

```
Security prompt accuracy: 73%
Monolithic prompt accuracy: 48%
```

### 2. Context Window Usage
Including 3-5 related files (imports, called functions) improved detection of cross-file vulnerabilities by 40%.

### 3. Structured Output
Requesting JSON-formatted responses reduced parsing errors from 12% to 0.3%.

### 4. Confidence Scoring
Having the model rate its confidence (1-10) allowed filtering low-confidence findings, reducing noise significantly.

## What Didn't Work

### 1. Business Logic Review
The model cannot understand business rules without extensive documentation. 0% accuracy on "this calculation is wrong for our domain" type issues.

### 2. Test Quality Assessment
Model frequently praised tests that had no assertions or tested implementation details.

### 3. Complex Async Patterns
Highest false positive rate in concurrent code. Model often flagged correct mutex usage as potential deadlock.

### 4. Rate Limiting
GitHub webhook bursts caused API throttling. Need queue-based architecture for production.

## Developer Feedback

Survey of 12 developers who used POC for 2 weeks:

| Question | Score (1-5) |
|----------|-------------|
| "Reviews were helpful" | 3.8 |
| "Saved me time" | 4.1 |
| "Would recommend to team" | 3.9 |
| "Trust the security findings" | 3.4 |
| "Comments were actionable" | 3.7 |

### Qualitative Feedback

**Positive:**
- "Caught a SQL injection I missed"
- "Liked getting instant feedback before human review"
- "Style suggestions were actually useful, not just formatting"

**Negative:**
- "Sometimes comments were too verbose"
- "Flagged my error handling as 'potential issue' when it was intentional"
- "Wished it could auto-fix simple issues"

## Technical Debt Created

1. **Hardcoded prompts** - Prompts are in code, should be configurable
2. **No retry logic** - API failures cause silent drops
3. **Synchronous processing** - Won't scale beyond 50 PRs/hour
4. **No metrics/observability** - Had to manually check logs
5. **Single tenant** - GitHub app only supports one org

## Unvalidated Assumptions

| Assumption | Status | Risk if Wrong |
|------------|--------|---------------|
| GPT-4 API will remain available | Unvalidated | High - core dependency |
| Token costs won't increase significantly | Unvalidated | Medium - budget impact |
| Detection rates stable across codebases | Unvalidated | Medium - tested on 1 repo |
| Developers won't ignore AI comments | Unvalidated | High - defeats purpose |

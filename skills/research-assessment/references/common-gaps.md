# Common Gaps by Research Type

Typical gaps found when assessing different types of research projects.

## Proof of Concept (POC)

**Typical gaps:**

| Gap | Why it happens | Impact |
|-----|----------------|--------|
| Happy path only | POC focused on proving it works | Production needs failure handling |
| Hardcoded config | Quick iteration | Production needs configurability |
| No auth/security | Not the focus of POC | Security vulnerability |
| Single environment | Developed locally | Deployment complexity unknown |
| No tests | Manual testing only | Regression risk |
| No monitoring | Not needed for demo | Blind in production |

**Key questions:**
- What happens when the external service is down?
- What happens with invalid input?
- What happens at 10x the demo load?
- How long does the current approach take to deploy?

---

## Experiment / A/B Test

**Typical gaps:**

| Gap | Why it happens | Impact |
|-----|----------------|--------|
| Small sample size | Limited test population | Results may not generalize |
| Selection bias | Non-random assignment | Conclusions invalid |
| Short duration | Time pressure | Missed long-term effects |
| Single metric focus | Hypothesis-driven | Missing side effects |
| No statistical analysis | "Looks good" conclusion | False confidence |

**Key questions:**
- What was the sample size and statistical power?
- How were participants selected?
- What metrics besides the primary hypothesis were tracked?
- How long did the experiment run?
- Were there confounding variables?

---

## Prototype

**Typical gaps:**

| Gap | Why it happens | Impact |
|-----|----------------|--------|
| Technical debt | Speed over quality | Rework needed |
| Missing features | Scope limited | Incomplete product |
| Poor UX | Function over form | User adoption issues |
| No accessibility | Not prioritized | Compliance/usability issues |
| Brittle integrations | Mocked dependencies | Integration risk |

**Key questions:**
- What shortcuts were taken that need fixing?
- What features were descoped?
- How much of the UI is placeholder?
- Which integrations are real vs mocked?

---

## Architecture Decision Record (ADR)

**Typical gaps:**

| Gap | Why it happens | Impact |
|-----|----------------|--------|
| Stale context | Situation changed | Decision may be invalid |
| Alternatives not explored | Time pressure | Suboptimal choice |
| Consequences not realized | Hard to predict | Unexpected issues |
| Implementation details missing | Abstract decision | Unclear how to build |
| No success criteria | Outcome not defined | Can't validate decision |

**Key questions:**
- Is the context that drove this decision still valid?
- Were alternatives properly evaluated?
- Have the predicted consequences materialized?
- Is there enough detail to implement?
- How will we know if this was the right decision?

---

## Research Spike

**Typical gaps:**

| Gap | Why it happens | Impact |
|-----|----------------|--------|
| Incomplete exploration | Timeboxed | Knowledge gaps |
| No recommendation | Analysis paralysis | No clear next step |
| Undocumented learnings | In researcher's head | Knowledge lost |
| Scope creep | Interesting tangents | Core question unanswered |
| No reproducibility | One-time exploration | Can't validate findings |

**Key questions:**
- What was the original question and was it answered?
- What did we learn that wasn't expected?
- What areas weren't explored?
- Can someone else reproduce the findings?
- What's the recommendation?

---

## Migration / Refactor Study

**Typical gaps:**

| Gap | Why it happens | Impact |
|-----|----------------|--------|
| Underestimated scope | Iceberg effect | Timeline blown |
| Missing edge cases | Not visible in study | Production bugs |
| Rollback plan absent | Focus on forward path | Stuck if it fails |
| Data migration overlooked | Schema focus | Data loss risk |
| Feature parity gaps | Assumed equivalence | User complaints |

**Key questions:**
- What percentage of the codebase was actually analyzed?
- What's the rollback plan if migration fails?
- How will data be migrated?
- What features exist in old system that must be preserved?
- What's the testing strategy?

---

## Benchmarking Study

**Typical gaps:**

| Gap | Why it happens | Impact |
|-----|----------------|--------|
| Unrealistic conditions | Lab vs production | Numbers don't hold |
| Missing percentiles | Average only reported | P99 surprises |
| No baseline comparison | New thing only | Improvement unclear |
| Hardware differences | Dev vs prod | Results don't transfer |
| Cold vs warm start | Not distinguished | Startup time hidden |

**Key questions:**
- How close were benchmark conditions to production?
- What percentiles were measured (not just average)?
- What's the comparison baseline?
- What hardware was used?
- Were cold start and warm start both measured?

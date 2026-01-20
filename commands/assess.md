---
name: assess
description: Analyze research artifacts (POCs, ADRs, experiments) to evaluate production readiness and extract key findings
argument-hint: "[path-to-research-artifacts]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Task
---

# Research Assessment

Analyze research artifacts to evaluate production readiness and extract validated learnings.

## Workflow

1. **Locate artifacts**: If path provided, scan for research files. If not, prompt user.
2. **Analyze content**: Use research-analyzer agent for deep analysis
3. **Extract findings**: Apply "What did we prove?" framework
4. **Score readiness**: Run production readiness checklist
5. **Identify gaps**: Create gap analysis matrix
6. **Write output**: Save to `.r2r/01-assessment.md`

## Input Detection

Look for these artifact types:
- `*.md` files containing "ADR", "RFC", "Proposal", "Experiment"
- `README.md` in research/poc/prototype directories
- Jupyter notebooks (`*.ipynb`)
- Test results, benchmark files
- Architecture diagrams, design docs

## Output Format

Write to `.r2r/01-assessment.md`:

```markdown
---
phase: assessment
created: [ISO timestamp]
source_path: [input path]
artifacts_analyzed: [count]
readiness_score: [1-10]
status: complete
---

# Research Assessment: [Project Name]

## Executive Summary
[2-3 sentence overview of findings]

## What Did We Prove?

### Validated Hypotheses
- [ ] [Hypothesis 1]: [Evidence]
- [ ] [Hypothesis 2]: [Evidence]

### Key Findings
1. [Finding with supporting evidence]
2. [Finding with supporting evidence]

## Production Readiness Score: X/10

| Criterion | Score | Notes |
|-----------|-------|-------|
| Core hypothesis validated | X/10 | |
| Performance benchmarks | X/10 | |
| Security considerations | X/10 | |
| Scalability tested | X/10 | |
| Error handling defined | X/10 | |
| Documentation exists | X/10 | |

## Gap Analysis

| Category | Proven | Assumed | Unknown |
|----------|--------|---------|---------|
| Functionality | | | |
| Performance | | | |
| Security | | | |
| Scalability | | | |
| Operations | | | |

## Technical Debt Identified
- [Debt item 1]
- [Debt item 2]

## Risks & Concerns
- [Risk 1]
- [Risk 2]

## Recommended Next Steps
1. [Action item]
2. [Action item]
```

## State Update

After writing assessment, update `.r2r/state.json`:

```json
{
  "current_phase": "assessment",
  "completed_phases": ["assessment"],
  "last_updated": "[ISO timestamp]",
  "project_name": "[extracted name]",
  "readiness_score": [score]
}
```

## Tips

- If no path provided, search current directory for common research patterns
- Use the research-analyzer agent for complex artifact analysis
- Be conservative with readiness scores - underestimate rather than overestimate
- Flag any security concerns prominently

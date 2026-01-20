---
name: full
description: Run the complete research-to-roadmap pipeline (assess → decompose → prioritize → roadmap → validate)
argument-hint: "[path-to-research-artifacts]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Task
---

# Full Pipeline

Run the complete research-to-roadmap workflow in sequence.

## Workflow

Execute all phases in order:

1. **Assess** → `.r2r/01-assessment.md`
2. **Decompose** → `.r2r/02-components.md`
3. **Prioritize** → `.r2r/03-priorities.md`
4. **Roadmap** → `.r2r/04-roadmap.md`
5. **Validate** → `.r2r/05-validation.md`

## Usage

```
/r2r:full ./path/to/research
```

Or without path (will search current directory):

```
/r2r:full
```

## Execution

1. Create `.r2r/` directory if it doesn't exist
2. Initialize `state.json`:
   ```json
   {
     "current_phase": "started",
     "completed_phases": [],
     "started_at": "[ISO timestamp]",
     "source_path": "[path]"
   }
   ```
3. Execute each phase in sequence
4. After each phase, check for critical issues
5. If validation fails, stop and report

## Progress Reporting

After each phase, report:
- Phase completed
- Key findings
- Time taken
- Next phase starting

## Output

On completion, provide summary:

```markdown
## Research-to-Roadmap Complete

**Source**: [path]
**Duration**: [time]

### Results

| Phase | Status | Key Output |
|-------|--------|------------|
| Assessment | ✅ | Readiness: X/10 |
| Decomposition | ✅ | X components identified |
| Prioritization | ✅ | H1: X, H2: Y, H3: Z |
| Roadmap | ✅ | X milestones, target: [date] |
| Validation | ✅/⚠️ | [status] |

### Files Created

- `.r2r/01-assessment.md`
- `.r2r/02-components.md`
- `.r2r/03-priorities.md`
- `.r2r/04-roadmap.md`
- `.r2r/05-validation.md`
- `.r2r/state.json`

### Next Steps

1. Review roadmap: `.r2r/04-roadmap.md`
2. Address validation issues: `.r2r/05-validation.md`
3. Export when ready: `/r2r:export --github`
```

## Error Handling

If a phase fails:
1. Save progress to `state.json`
2. Report which phase failed and why
3. Suggest using individual command to retry

## Tips

- Full pipeline is best for initial assessment
- Use individual commands for iteration
- Review outputs between phases for important decisions
- Validation issues don't stop pipeline, but are flagged

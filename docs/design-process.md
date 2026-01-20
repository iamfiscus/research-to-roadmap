# Brainstorm: Research-to-Roadmap Plugin Design

**Date:** 2026-01-19
**Problem:** Design output formats, workflow, and skill content for research-to-roadmap plugin
**Method:** Diverge-Converge brainstorming (65 ideas → 18 clusters → selections)

---

## Problem Statement

Design a Claude Code plugin that transforms Software R&D projects (POCs, prototypes, ADRs, lab experiments) into production-ready roadmaps. Need to determine:

1. Output formats for roadmap documents
2. Command workflow and data flow
3. Deep content for skills (research-assessment, roadmap-patterns, adr-to-prod)

## Evaluation Criteria

| Criterion | Weight | Description |
|-----------|--------|-------------|
| Actionability | 25% | Can users immediately act on output? |
| Clarity | 20% | Is output easy to understand? |
| Flexibility | 20% | Works across different project types? |
| Integration | 15% | Plays well with existing tools? |
| Maintainability | 10% | Can output be updated over time? |
| Simplicity | 10% | Not over-engineered? |

---

## Diverge Phase (65 Ideas)

### Output Format Ideas (20)
1. Single markdown file with all sections
2. Multi-file structure (01-assessment.md, etc.)
3. YAML frontmatter + markdown body
4. JSON schema + markdown
5. Mermaid diagrams for timelines
6. Task lists for tracking
7. Obsidian-compatible wikilinks
8. HTML with collapsible sections
9. PRD-style template
10. ADR-style extended format
11. Notion-style toggle blocks
12. Table-heavy scannable format
13. Narrative storytelling format
14. Kanban-style columns
15. RFC-style numbered sections
16. Changelog-style updates
17. One-pager + appendices
18. Slide-deck ready (Marp/Slidev)
19. Issue template format (GitHub/Linear)
20. Hierarchical OKR outline

### Workflow Ideas (15)
21. Linear pipeline (default)
22. State file (.r2r/state.json)
23. Output to .r2r/ with timestamps
24. Convention over configuration
25. Interactive prompts
26. Batch mode (/r2r:full)
27. Checkpoint save/restore
28. Diff-aware delta detection
29. Watch mode auto-update
30. Branch support for scenarios
31. Rollback capability
32. Dry-run preview
33. Resume after interruption
34. Parallel execution paths
35. Custom template injection

### Skill Content Ideas (30)

**research-assessment:**
36. TRL framework for software
37. Production readiness checklist
38. "What did we prove?" template
39. Gap analysis matrix
40. Experiment quality rubric
41. Technical debt inventory
42. Knowledge transfer assessment
43. Performance baseline template
44. Security posture checklist
45. Scalability assessment

**roadmap-patterns:**
46. H1/H2/H3 horizon planning
47. Backcast planning template
48. Milestone SMART criteria
49. Dependency mapping (DAG)
50. Risk-adjusted timelines
51. Stakeholder view templates
52. Rolling wave planning
53. Success criteria templates
54. Resource allocation patterns
55. Contingency planning

**adr-to-prod:**
56. ADR parsing patterns
57. ADR → task breakdown
58. Decision validation checkpoints
59. Assumption tracking
60. ADR outcome documentation
61. ADR supersession workflow
62. Integration point identification
63. ADR-to-milestone mapping
64. Cross-ADR dependency detection
65. ADR health check

---

## Cluster Phase (18 Clusters)

### Output Clusters
- **A: Document Structure** (1, 2, 15, 17)
- **B: Machine-Readable Hybrid** (3, 4, 19)
- **C: Visual/Interactive** (5, 8, 14, 18)
- **D: Progressive Disclosure** (6, 11, 12, 20)
- **E: Narrative/Storytelling** (9, 10, 13)
- **F: Tool Integration** (7, 16, 19)

### Workflow Clusters
- **G: State Management** (22, 23, 27, 33)
- **H: Execution Modes** (21, 26, 32, 34)
- **I: Flexibility/Adaptation** (24, 25, 28, 35)
- **J: Version Control** (29, 30, 31)

### Skill Clusters
- **K: Assessment Frameworks** (36, 37, 39, 40)
- **L: Risk & Debt** (41, 44, 45, 43)
- **M: Knowledge & Handoff** (38, 42, 60)
- **N: Planning Patterns** (46, 47, 52, 55)
- **O: Milestone Design** (48, 49, 50, 53)
- **P: Stakeholder Communication** (51, 54)
- **Q: ADR Lifecycle** (56, 61, 65)
- **R: ADR Implementation** (57, 58, 59, 62, 63, 64)

---

## Converge Phase (Final Selections)

### Selected Output Format

**Multi-file structure in `.r2r/` directory:**

```
.r2r/
├── 01-assessment.md      # YAML frontmatter + research findings
├── 02-components.md      # Decomposed shippable pieces
├── 03-priorities.md      # Effort/impact scoring, horizons
├── 04-roadmap.md         # Main roadmap with Mermaid timeline
├── 05-validation.md      # Pre-mortem analysis results
├── state.json            # Workflow state tracking
└── exports/
    └── github-issues.md  # Optional GitHub export format
```

**Format features:**
- YAML frontmatter for machine-readable metadata
- Markdown body with task lists (`- [ ]`)
- Mermaid diagrams for visual timelines
- GitHub-flavored markdown for compatibility

### Selected Workflow

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐
│   assess    │───▶│  decompose   │───▶│  prioritize  │
│ (01-*.md)   │    │  (02-*.md)   │    │  (03-*.md)   │
└─────────────┘    └──────────────┘    └──────────────┘
                                              │
                                              ▼
┌─────────────┐    ┌──────────────┐    ┌──────────────┐
│   export    │◀───│   validate   │◀───│   roadmap    │
│ (exports/)  │    │  (05-*.md)   │    │  (04-*.md)   │
└─────────────┘    └──────────────┘    └──────────────┘
```

**Workflow features:**
- Linear pipeline (default)
- State file for persistence
- Convention over configuration (commands auto-detect previous outputs)
- Batch mode: `/r2r:full [path]` runs entire pipeline

### Selected Skill Content

**research-assessment skill:**
| Framework | Purpose | Score |
|-----------|---------|-------|
| "What did we prove?" template | Extract validated learnings | 8.55 |
| Production readiness checklist | Scored assessment | 8.35 |
| Gap analysis matrix | Proven/assumed/unknown | 8.05 |

**roadmap-patterns skill:**
| Pattern | Purpose | Score |
|---------|---------|-------|
| H1/H2/H3 horizon planning | Time-based prioritization | 8.50 |
| Backcast template | Work backward from deadline | 8.15 |
| Stakeholder views | Exec/eng/PM perspectives | 8.05 |

**adr-to-prod skill:**
| Pattern | Purpose | Score |
|---------|---------|-------|
| ADR → task breakdown | Convert decisions to work | 8.50 |
| ADR parsing patterns | Extract structure | 8.30 |
| ADR health check | Validate decision validity | 8.10 |

---

## Next Steps

1. Update plugin scaffolding with `.r2r/` output structure
2. Implement state.json schema
3. Flesh out skill content with selected frameworks
4. Create command implementations following workflow
5. Add Mermaid diagram generation to roadmap command
6. Build GitHub export functionality

---

## Runner-Up Ideas (For Future Consideration)

- (30) Branch support for scenario planning
- (35) Custom template injection
- (29) Watch mode for auto-updates
- (49) Dependency DAG visualization
- (52) Rolling wave planning for uncertainty

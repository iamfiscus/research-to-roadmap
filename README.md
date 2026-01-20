# Research to Roadmap

Transform Software R&D projects, POCs, ADRs, and lab experiments into production-ready roadmaps.

## Overview

This plugin provides a structured workflow for transitioning research projects into production:

```
assess → decompose → prioritize → roadmap → validate → export
```

Each phase builds on the previous, creating a complete `.r2r/` directory with all artifacts.

## Installation

```bash
# Test locally
claude --plugin-dir ./claude-plugin

# Or add to your project
cp -r claude-plugin/.claude-plugin ./.claude-plugin
```

## Quick Start

```bash
# Run full pipeline
/r2r:full ./path/to/research

# Or run step by step
/r2r:assess ./research/my-poc
/r2r:decompose
/r2r:prioritize
/r2r:roadmap
/r2r:validate
/r2r:export --github
```

## Commands

| Command | Description |
|---------|-------------|
| `/r2r:assess` | Analyze research artifacts for production readiness |
| `/r2r:decompose` | Break research into shippable components |
| `/r2r:prioritize` | Effort/impact analysis with H1/H2/H3 horizon planning |
| `/r2r:roadmap` | Generate complete roadmap with milestones |
| `/r2r:validate` | Pre-mortem analysis to catch blind spots |
| `/r2r:export` | Export to GitHub Issues, Linear, or markdown |
| `/r2r:full` | Run complete pipeline in sequence |

## Output Structure

```
.r2r/
├── 01-assessment.md      # Research findings, readiness score
├── 02-components.md      # Decomposed shippable pieces
├── 03-priorities.md      # Effort/impact scoring, horizons
├── 04-roadmap.md         # Main roadmap with Mermaid timeline
├── 05-validation.md      # Pre-mortem analysis results
├── state.json            # Workflow state tracking
└── exports/              # Export outputs
    ├── github/           # GitHub Issues format
    ├── linear/           # Linear format
    └── roadmap-summary.md
```

## Agents

| Agent | Purpose |
|-------|---------|
| `research-analyzer` | Deep analysis of research artifacts |
| `risk-assessor` | Identify blockers, dependencies, risks |
| `roadmap-generator` | Create structured milestone-based roadmaps |

## Skills

| Skill | Purpose |
|-------|---------|
| `research-assessment` | "What did we prove?" framework, readiness checklist, graduation criteria |
| `roadmap-patterns` | H1/H2/H3 horizons, release phases, feature flag lifecycle |
| `adr-to-prod` | ADR parsing, task breakdown, health checks |

### New in v0.2.0: Labs Patterns

Based on research of GitHub Next, Linear, Vercel, Figma, and other tech company labs:

**Graduation Criteria** (`research-assessment/references/graduation-criteria.md`)
- Progressive validation ramp (Internal → Private → Public → GA)
- "80% of experiments should fail" philosophy
- Gate criteria and kill decisions
- Pre-mortem templates for gate reviews

**RFC Templates** (`research-assessment/references/rfc-templates.md`)
- Google-style Design Doc format
- Uber-style RFC with shepherding
- Sourcegraph lightweight RFC
- Experiment Spec for hypothesis-driven research

**Release Phases** (`roadmap-patterns/references/release-phases.md`)
- Four-phase release model (Internal Build → Private Preview → Public Preview → GA)
- Phase characteristics and exit criteria
- Feature flag lifecycle and cleanup checklist
- Rollback procedures per phase

**Validation Ramp** (`roadmap-patterns/references/validation-ramp.md`)
- Kill criteria (hard and soft triggers)
- Metrics framework (leading vs lagging indicators)
- Decision log templates
- Commitment levels (Exploration → Validation → Investment → Scale)

## Workflow Details

### 1. Assess

Analyzes research artifacts to determine:
- What was actually proven (vs assumed)
- Production readiness score (1-10)
- Gap analysis (proven/assumed/unknown)
- Technical debt and risks

### 2. Decompose

Breaks research into discrete components:
- Single-responsibility units
- T-shirt sized (S/M/L/XL)
- Dependency mapping
- Success criteria per component

### 3. Prioritize

Scores and assigns to horizons:
- Impact vs. effort scoring
- H1 (0-3mo), H2 (3-6mo), H3 (6-12mo)
- Quick wins identified
- Critical path analysis

### 4. Roadmap

Generates structured roadmap:
- SMART milestones
- Mermaid Gantt timeline
- Dependency graph
- Stakeholder views (exec/eng/PM)
- **NEW**: Release phase mapping (Internal → Private → Public → GA)
- **NEW**: Graduation criteria per phase

### 5. Validate

Pre-mortem analysis:
- "The project failed because..."
- Assumption audit
- Dependency validation
- Resource reality check
- Pass/Caution/Fail status
- **NEW**: Graduation gate assessment
- **NEW**: Kill criteria check

### 6. Export

Output to external systems:
- `--github`: GitHub Issues + Milestones
- `--linear`: Linear issues
- `--markdown`: Single shareable doc
- `--json`: Machine-readable format
- **NEW**: Release phase labels for GitHub Issues
- **NEW**: Feature flag lifecycle tracking
- **NEW**: Rollout percentage milestones

## Integration with Thinking Frameworks

This plugin integrates with thinking-frameworks for deeper analysis:

| Plugin Skill | Usage |
|--------------|-------|
| `brainstorm-diverge-converge` | Ideation during planning |
| `prioritization-effort-impact` | Advanced prioritization |
| `forecast-premortem` | Deep pre-mortem analysis |
| `portfolio-roadmapping-bets` | H1/H2/H3 horizon planning |

## Examples

### Assess a POC

```bash
/r2r:assess ./experiments/caching-layer-poc

# Output: .r2r/01-assessment.md with:
# - Production readiness: 6/10
# - Validated: Core caching logic works
# - Gaps: No load testing, missing error handling
```

### Full Pipeline

```bash
/r2r:full ./research/auth-redesign

# Creates complete roadmap in .r2r/
# Shows summary with all phases
```

### Export to GitHub

```bash
/r2r:export --github

# Creates:
# - .r2r/exports/github/milestones.json
# - .r2r/exports/github/issues/*.md
# - .r2r/exports/github/import.sh
```

## Configuration

No configuration required. The plugin uses convention over configuration:

- Outputs to `.r2r/` in current directory
- Reads previous phase outputs automatically
- State tracked in `state.json`

## Utility Scripts

| Script | Purpose |
|--------|---------|
| `scripts/init-r2r.sh` | Initialize empty .r2r/ directory with state.json |
| `scripts/validate-r2r.sh` | Validate .r2r/ structure and state consistency |
| `scripts/github-import.sh` | Import exported roadmap to GitHub Issues (requires `gh` CLI) |

```bash
# Initialize new project
./scripts/init-r2r.sh my-project

# Validate after running pipeline
./scripts/validate-r2r.sh

# Import to GitHub after export
./scripts/github-import.sh myorg/myrepo
```

## Contributing

This plugin was created using the brainstorm-diverge-converge methodology. See `docs/design-process.md` for the design process.

## License

MIT

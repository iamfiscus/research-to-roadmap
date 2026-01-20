#!/bin/bash
# Validate .r2r/ directory structure and state consistency
# Usage: ./validate-r2r.sh [path-to-r2r-dir]

set -e

R2R_DIR="${1:-.r2r}"

echo "Validating $R2R_DIR..."

# Check directory exists
if [ ! -d "$R2R_DIR" ]; then
    echo "ERROR: $R2R_DIR directory not found"
    exit 1
fi

# Check state.json exists
if [ ! -f "$R2R_DIR/state.json" ]; then
    echo "ERROR: state.json not found"
    exit 1
fi

# Validate state.json is valid JSON
if ! jq empty "$R2R_DIR/state.json" 2>/dev/null; then
    echo "ERROR: state.json is not valid JSON"
    exit 1
fi

# Get current phase from state
CURRENT_PHASE=$(jq -r '.current_phase // "none"' "$R2R_DIR/state.json")
echo "Current phase: $CURRENT_PHASE"

# Check expected files exist based on completed phases
COMPLETED=$(jq -r '.completed_phases // [] | .[]' "$R2R_DIR/state.json")

WARNINGS=0
ERRORS=0

check_file() {
    local file="$1"
    local phase="$2"
    if [ ! -f "$R2R_DIR/$file" ]; then
        echo "ERROR: $file missing (required for $phase phase)"
        ((ERRORS++))
    else
        echo "  ✓ $file"
    fi
}

echo ""
echo "Checking phase artifacts..."

for phase in $COMPLETED; do
    case $phase in
        assessment)
            check_file "01-assessment.md" "assessment"
            ;;
        decomposition)
            check_file "02-components.md" "decomposition"
            ;;
        prioritization)
            check_file "03-priorities.md" "prioritization"
            ;;
        roadmap)
            check_file "04-roadmap.md" "roadmap"
            ;;
        validation)
            check_file "05-validation.md" "validation"
            ;;
        export)
            if [ ! -d "$R2R_DIR/exports" ]; then
                echo "WARNING: exports/ directory missing for export phase"
                ((WARNINGS++))
            else
                echo "  ✓ exports/"
            fi
            ;;
    esac
done

echo ""
echo "Validation complete:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"

if [ $ERRORS -gt 0 ]; then
    exit 1
fi

exit 0

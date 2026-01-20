#!/bin/bash
# Initialize empty .r2r/ directory with state.json
# Usage: ./init-r2r.sh [project-name]

set -e

PROJECT_NAME="${1:-unnamed-project}"
R2R_DIR=".r2r"

if [ -d "$R2R_DIR" ]; then
    echo "ERROR: $R2R_DIR already exists"
    echo "Use --force to overwrite"
    if [ "$2" != "--force" ]; then
        exit 1
    fi
    echo "Forcing overwrite..."
    rm -rf "$R2R_DIR"
fi

echo "Initializing $R2R_DIR for project: $PROJECT_NAME"

# Create directory structure
mkdir -p "$R2R_DIR"
mkdir -p "$R2R_DIR/exports"

# Create initial state.json
cat > "$R2R_DIR/state.json" << EOF
{
  "project_name": "$PROJECT_NAME",
  "current_phase": "initialized",
  "completed_phases": [],
  "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "last_updated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

echo "Created:"
echo "  $R2R_DIR/"
echo "  $R2R_DIR/state.json"
echo "  $R2R_DIR/exports/"
echo ""
echo "Next step: Run /r2r:assess <path-to-research>"

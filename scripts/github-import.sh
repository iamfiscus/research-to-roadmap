#!/bin/bash
# Import roadmap to GitHub Issues and Milestones
# Usage: ./github-import.sh [owner/repo] [exports-path]
#
# Requires: gh CLI installed and authenticated

set -e

REPO="${1:-}"
EXPORTS_PATH="${2:-.r2r/exports/github}"

if [ -z "$REPO" ]; then
    echo "Usage: ./github-import.sh owner/repo [exports-path]"
    echo ""
    echo "Example: ./github-import.sh myorg/myrepo .r2r/exports/github"
    exit 1
fi

# Check gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "ERROR: gh CLI not found"
    echo "Install: https://cli.github.com/"
    exit 1
fi

# Check gh is authenticated
if ! gh auth status &> /dev/null; then
    echo "ERROR: gh CLI not authenticated"
    echo "Run: gh auth login"
    exit 1
fi

# Check exports path exists
if [ ! -d "$EXPORTS_PATH" ]; then
    echo "ERROR: Exports path not found: $EXPORTS_PATH"
    echo "Run /r2r:export --github first"
    exit 1
fi

echo "Importing roadmap to $REPO..."
echo ""

# Create milestones if milestones.json exists
if [ -f "$EXPORTS_PATH/milestones.json" ]; then
    echo "Creating milestones..."
    jq -c '.[]' "$EXPORTS_PATH/milestones.json" | while read -r milestone; do
        title=$(echo "$milestone" | jq -r '.title')
        description=$(echo "$milestone" | jq -r '.description // ""')
        due_on=$(echo "$milestone" | jq -r '.due_on // empty')

        echo "  Creating: $title"

        if [ -n "$due_on" ]; then
            gh api "repos/$REPO/milestones" \
                -f title="$title" \
                -f description="$description" \
                -f due_on="$due_on" \
                --silent || echo "    WARNING: Failed to create milestone (may already exist)"
        else
            gh api "repos/$REPO/milestones" \
                -f title="$title" \
                -f description="$description" \
                --silent || echo "    WARNING: Failed to create milestone (may already exist)"
        fi
    done
    echo ""
fi

# Create issues from issues/*.md files
if [ -d "$EXPORTS_PATH/issues" ]; then
    echo "Creating issues..."
    for issue_file in "$EXPORTS_PATH/issues"/*.md; do
        if [ -f "$issue_file" ]; then
            # Extract frontmatter
            title=$(sed -n 's/^title: "\(.*\)"/\1/p' "$issue_file" | head -1)
            labels=$(sed -n 's/^labels: \[\(.*\)\]/\1/p' "$issue_file" | tr -d '"' | tr ',' ' ')
            milestone=$(sed -n 's/^milestone: "\(.*\)"/\1/p' "$issue_file" | head -1)

            # Get body (everything after frontmatter)
            body=$(sed '1,/^---$/d' "$issue_file" | sed '1,/^---$/d')

            echo "  Creating: $title"

            # Build gh command
            gh_cmd="gh issue create --repo $REPO --title \"$title\" --body \"$body\""

            if [ -n "$labels" ]; then
                for label in $labels; do
                    gh_cmd="$gh_cmd --label \"$label\""
                done
            fi

            if [ -n "$milestone" ]; then
                gh_cmd="$gh_cmd --milestone \"$milestone\""
            fi

            eval "$gh_cmd" --silent 2>/dev/null || echo "    WARNING: Failed to create issue"
        fi
    done
    echo ""
fi

echo "Import complete!"
echo "View issues: https://github.com/$REPO/issues"

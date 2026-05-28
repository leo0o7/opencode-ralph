#!/bin/bash
set -eo pipefail

issues=$(cat issues/*.md 2>/dev/null || echo "No issues found")
commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
prompt=$(cat "$script_dir/prompt.md")

opencode run --dangerously-skip-permissions \
  "Previous commits: $commits Issues: $issues $prompt"

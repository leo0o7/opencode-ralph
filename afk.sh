#!/bin/bash
set -eo pipefail

if [[ ! "$1" =~ ^[1-9][0-9]*$ ]]; then
  echo "Usage: $0 <iterations>"
  exit 1
fi

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

for ((i = 1; i <= $1; i++)); do
  tmpfile=$(mktemp)

  commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
  issues=$(cat issues/*.md 2>/dev/null || echo "No issues found")
  prompt=$(cat "$script_dir/prompt.md")

  opencode run \
    --dangerously-skip-permissions \
    --format json \
    "Previous commits: $commits Issues: $issues $prompt" |
    tee "$tmpfile"

  if grep -q "<promise>NO MORE TASKS</promise>" "$tmpfile"; then
    echo "Ralph complete after $i iterations."
    rm -f "$tmpfile"
    exit 0
  fi

  rm -f "$tmpfile"
done

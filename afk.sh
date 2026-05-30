#!/bin/bash
set -eo pipefail

MODEL=""
VARIANT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m)
      MODEL="$2"
      shift 2
      ;;
    --pick)
      if ! command -v fzf &>/dev/null; then
        echo "fzf is required for --pick. Install with: brew install fzf" >&2
        exit 1
      fi
      MODEL=$(opencode models | fzf --prompt="Select model> ")
      VARIANT=$(printf "none\nminimal\nlow\nmedium\nhigh\nxhigh\nmax" | fzf --prompt="Select variant> ")
      shift
      ;;
    -v|--variant)
      VARIANT="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ ! "$1" =~ ^[1-9][0-9]*$ ]]; then
  echo "Usage: $0 [-m <model> | --pick] [-v <variant>] <iterations>" >&2
  exit 1
fi

iterations=$1
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

for ((i = 1; i <= iterations; i++)); do
  tmpfile=$(mktemp)

  commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
  issues=$(cat issues/*.md 2>/dev/null || echo "No issues found")
  prompt=$(cat "$script_dir/prompt.md")

  model_flag=()
  if [[ -n "$MODEL" ]]; then
    model_flag=(--model "$MODEL")
  fi

  variant_flag=()
  if [[ -n "$VARIANT" ]]; then
    variant_flag=(--variant "$VARIANT")
  fi

  opencode run \
    --dangerously-skip-permissions \
    --format json \
    "${model_flag[@]}" \
    "${variant_flag[@]}" \
    "Previous commits: $commits Issues: $issues $prompt" |
    tee "$tmpfile"

  if grep -q "<promise>NO MORE TASKS</promise>" "$tmpfile"; then
    echo "Ralph complete after $i iterations."
    rm -f "$tmpfile"
    exit 0
  fi

  rm -f "$tmpfile"
done

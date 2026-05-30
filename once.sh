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

issues=$(cat issues/*.md 2>/dev/null || echo "No issues found")
commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
prompt=$(cat "$script_dir/prompt.md")

model_flag=()
if [[ -n "$MODEL" ]]; then
  model_flag=(--model "$MODEL")
fi

variant_flag=()
if [[ -n "$VARIANT" ]]; then
  variant_flag=(--variant "$VARIANT")
fi

opencode run --dangerously-skip-permissions \
  "${model_flag[@]}" \
  "${variant_flag[@]}" \
  "Previous commits: $commits Issues: $issues $prompt"

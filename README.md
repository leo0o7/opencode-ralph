# OpenCode Ralph

A tiny set of scripts for running a Ralph-style coding loop with OpenCode.

This is basically the OpenCode version of Matt Pocock's Claude Code workflow from [here](https://github.com/mattpocock/ai-engineer-workshop-2026-project/tree/main/ralph).

## How It Works

The scripts collect:

- local issues from `issues/*.md`
- the last 5 git commits
- the workflow prompt from this directory's `prompt.md`

Then they pass that context to `opencode run`.

## Usage

```bash
# Run one task
./once.sh

# Run N iterations (stops early on "NO MORE TASKS")
./afk.sh 5

# Select model/variant interactively
./once.sh --pick
./afk.sh --pick 5

# Specify model and/or variant directly
./once.sh -m "anthropic/claude-sonnet-4-5" -v max
./afk.sh -m "openai/gpt-5" 5
```

## Note

Both scripts use `--dangerously-skip-permissions`, so only run them in repos where you're happy for OpenCode to edit and execute without asking each time.

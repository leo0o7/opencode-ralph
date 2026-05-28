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

Run one task:

```bash
./opencode-ralph/once.sh
```

Run a few tasks while AFK:

```bash
./opencode-ralph/afk.sh 5
```

`afk.sh` stops early if OpenCode prints:

```text
<promise>NO MORE TASKS</promise>
```

## Note

Both scripts use `--dangerously-skip-permissions`, so only run them in repos where you're happy for OpenCode to edit and execute without asking each time.

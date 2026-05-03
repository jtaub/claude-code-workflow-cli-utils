---
name: create-pr
description: Use when the user wants to create a pull request from the current feature branch to main
---

First, determine the current git branch. If the current branch is main, tell the user "Already on main, nothing to PR." and stop.

Look at the git diff between the current branch and main, and read the commit messages.

Use the `gh` CLI to create a pull request from the current branch targeting main.

For the PR title: write a concise summary in imperative mood (e.g. 'Add user export endpoint').

For the PR body, use exactly this format:

```markdown
Closes #issue-number (if available, skip if you don't know it)

### ➕ Added

1. (list each new feature, endpoint, component, or capability — one per line)

### ♻️ Changed

1. (list each modification to existing behavior — one per line)

### 🐞 Fixed

1. (list each bug fix — one per line)
```

If a section has no items, omit it entirely.

Rules:
- Each item should be one sentence describing the what and why, not the how
- Prefer emphasis on higher-level user-facing behavior changes and architecture changes, rather than low-level code details.
- Do not list internal refactors or test additions as their own items — mention them under the feature they support
- Do not editorialize or add commentary beyond what the diff shows
- If a commit message is vague, read the actual diff to understand the change

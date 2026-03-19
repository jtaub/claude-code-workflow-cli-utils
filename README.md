# claude-code-workflow-cli-utils
Claude Code skills for automating common workflows: issue specs, implementation, PR creation, and automating code reviews. Works with both Claude Code and Copilot CLI.

The basic idea is to **put your requirements into a GitHub issue**, rather than directly into the CLI prompt.

## Setup

Copy the skills into your Claude skills directory:

```bash
cp -r skills/* ~/.claude/skills/
```

## Usage

### 0. Create a bare-bones GitHub issue
Before using any of these commands, I create an issue in GitHub with a minimal description of what I want to build.

### 1. Improve a GitHub issue description

Given the underspecified issue, ask Claude to refine it into a well-structured spec.

The goal of this step is to clarify requirements **before** desigining the implementation. This is as much for me as it is for Claude.

```
/specs https://github.com/acme/app/issues/42
```

### 2. Implement GitHub issue

Given the well-structured spec, ask Claude to implement it with a TDD-first plan:

```
/implement https://github.com/acme/app/issues/42
```

### 3. Create a PR from the current branch

After completing the implementation, create a PR from the current branch:

```
/pr
```

### 4. Re-review Claude PR comments

This assumes that you have set up [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions) on your repository, and that the action has finished running on the PR. This will re-review the comments left by the action, and fix any test coverage gaps.

```
/review https://github.com/acme/app/pull/17
```

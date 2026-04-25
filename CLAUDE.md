# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A collection of Claude Code skills that automate GitHub development workflows. Skills are installed by copying `skills/*` into `~/.claude/skills/`. There is no build system, package manager, or test framework — the project is pure Markdown skill definitions.

## Skill Workflow

The five skills form a sequential pipeline, each invoked via slash command with a GitHub URL argument (except `/create-pr`):

1. **`/specs <issue-url>`** — Requirements analyst. Fetches issue via `gl` CLI, asks clarifying questions, then rewrites the spec with testable acceptance criteria. Never discusses implementation.
2. **`/implement <issue-url>`** — TDD-first implementation. Breaks work into small testable steps, writes tests before code. Uses "Make the Change Easy, Then Make the Easy Change" pattern.
3. **`/create-pr`** — Creates PR from current branch to main via `gl` CLI. Uses structured body format (Added/Changed/Fixed sections). Warns if diff is too large to be a single PR.
4. **`/operational-readiness-review <pr-url>`** — SRE-focused review. Posts inline PR comments on observability gaps and failure mode handling. Does not block merge — advisory only.
5. **`/re-review <pr-url>`** — Validates automated reviewer comments (often wrong), finds Vitest coverage report, and fixes genuine issues + coverage gaps below 85%.

## Key Design Principles

- Skills use the **`gl` CLI** for all GitHub interactions (fetching issues, creating PRs, reading comments)
- `/specs` deliberately avoids implementation details — it's a requirements role, not engineering
- `/implement` does not perform git operations — the user handles git
- `/re-review` assumes Claude Code GitHub Actions are configured on the target repo

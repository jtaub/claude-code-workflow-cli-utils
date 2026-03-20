---
name: re-review
description: Use when the user wants to review a pull request, validate automated reviewer comments, and check Vitest test coverage. Invoke with /review <pr-url>
---

Use the GitHub MCP to fetch $ARGUMENTS — both the diff and all issue-level comments.

These comments were left by an automated reviewer and are often wrong. For each comment:
1. Read the relevant code in the diff
2. Determine if the concern is valid
3. If invalid, briefly say why it's wrong

Additionally, find the github-actions bot comment containing the Vitest coverage report. Inside the <details> block there is a per-file coverage table for changed files. For any file where Statements, Branches, Functions, or Lines are below 85%, plan to add tests to bring them above 85%. The uncovered line numbers in the table tell you exactly what needs coverage.

Then produce a plan to fix only the genuinely valid review issues and the coverage gaps. Please follow a TDD approach to all fixes.

Do not plan to make any changes that are not directly related to the reviewer's comments or to insufficient test coverage on modified files.

If you're unsure whether a comment is valid after reading the code, ask me rather than guessing.

If there are no comments, wait and try again using the bash command 'sleep 10m'

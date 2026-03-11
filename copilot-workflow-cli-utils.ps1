function copilot-specs {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$IssueUrl
    )

    $prompt = @"
/plan Use the GitHub MCP to fetch $IssueUrl — read the issue title, description, labels, and any comments. Also explore the relevant areas of the codebase mentioned in or implied by the issue.

You will work in two phases. Do not skip ahead.

---

## Phase 1: Clarifying Questions (always required)

Before writing anything, identify gaps and ambiguities in the issue. You must produce a numbered list of clarifying questions for me to answer. Do not skip this phase even if the issue seems well-specified — there are almost always implicit assumptions worth surfacing.

For each question, briefly state *why* it matters for the implementation (one sentence). Group questions by category:

**Scope & Behavior**
- What edge cases or error states are unspecified?
- Could a developer reasonably interpret the scope too broadly or too narrowly?
- Are there user-facing behaviors that aren't pinned down (e.g. empty states, loading states, error messages)?

**Acceptance Criteria**
- Which stated criteria are vague or untestable as written ('should work well', 'handle edge cases')?
- What's the definition of done — how will a reviewer know this is complete?

**Motivation & Trade-offs**
- Is the 'why' clear, or does the issue describe a solution without stating the underlying problem?
- Are there alternative approaches the author may have considered and ruled out?

**Technical Assumptions**
- What does the implementation depend on that isn't stated (APIs, data models, other in-flight work)?
- Are there performance, security, or backwards-compatibility constraints implied but not written?

Ask me between 3 and 10 questions. Prioritize questions where the answer would meaningfully change what gets built or how. Do not ask about things that are clearly specified or genuinely don't matter.

Use the typical 'ask question' tool that you're familiar with to collect my answers, and then proceed to Phase 2.

---

## Phase 2: Rewritten Spec (after I answer your questions)

Once I've answered, produce a rewritten issue description using this structure:

1. **Summary** — What and why. User story format is recommended but not mandatory.
2. **Acceptance Criteria** — Testable, unambiguous statements using Given/When/Then or checklists. Each must be verifiable without asking clarifying questions.
3. **Out of Scope** (optional) — Explicitly bounds the work.
4. **Technical Notes** (optional) — A short section highlighting relevant parts of the code. Do *not* suggest implementation details here. Do *not* use this section for an implementation plan.
5. **Screenshots** (optional) — Links or visuals for UI changes.

Rules for the rewrite:
- Preserve all existing information and intent — discard nothing the author wrote
- Incorporate my answers from Phase 1
- Clearly mark any remaining assumptions you made
- If the original issue already fully satisfies a section, keep it as-is

Present the rewrite as a plan. After I approve, update the issue body via the GitHub MCP.

Do *not* produce an implementation plan. Your only goal is a well-specified GitHub issue.
"@

    copilot --prompt $prompt --model claude-sonnet-4.6
}

function copilot-implement {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$IssueUrl
    )

    $prompt = @"
/plan Use the GitHub MCP to fetch $IssueUrl — read the issue title, description, and view any attachments such as screenshots.

Your goal is to implement this issue. Start by understanding the requirements, then explore the relevant parts of the codebase.

Produce a plan that:
1. Breaks the work into small, testable steps
2. Follows a TDD approach — write/update tests before implementation and aim for 100% code coverage
3. Only makes changes directly required by the issue
4. Make the Change Easy, Then Make the Easy Change - Often (but not always) it is easier to perform a refactor first and then implement your changes, rather than going right into development. I highly encourage this approach when it is applicable.

You do not need to perform any ``git`` operations, I will handle that for you.

If the issue is ambiguous or underspecified, ask me rather than guessing.
"@

    copilot --prompt $prompt --model claude-opus-4.6
}

function copilot-pr {
    $branch = git branch --show-current

    if ($branch -eq "main") {
        Write-Error "Already on main, nothing to PR."
        return
    }

    $prompt = @"
Look at the git diff between $branch and main, and read the commit messages.

Use the GitHub MCP to create a pull request from $branch targeting main.

For the PR title: write a concise summary in imperative mood (e.g. 'Add user export endpoint').

For the PR body, use exactly this format:

### ➕ Added

1. (list each new feature, endpoint, component, or capability — one per line)

### ♻️ Changed

1. (list each modification to existing behavior — one per line)

### 🐞 Fixed

1. (list each bug fix — one per line)

If a section has no items, omit it entirely.

Rules:
- Each item should be one sentence describing the what and why, not the how
- Do not list internal refactors or test additions as their own items — mention them under the feature they support
- Do not editorialize or add commentary beyond what the diff shows
- If a commit message is vague, read the actual diff to understand the change

If the diff is large enough that the PR should probably be split, warn me and suggest how to split it instead of creating the PR.
"@

    copilot --prompt $prompt --model claude-sonnet-4.6
}

function copilot-review {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$PrUrl
    )

    $prompt = @"
/plan Use the GitHub MCP to fetch $PrUrl — both the diff and all issue-level comments.

These comments were left by an automated reviewer and are often wrong. For each comment:
1. Read the relevant code in the diff
2. Determine if the concern is valid
3. If invalid, briefly say why it's wrong

Additionally, find the github-actions bot comment containing the Vitest coverage report. Inside the <details> block there is a per-file coverage table for changed files. For any file where Statements, Branches, Functions, or Lines are below 85%, plan to add tests to bring them above 85%. The uncovered line numbers in the table tell you exactly what needs coverage.

Then produce a plan to fix only the genuinely valid review issues and the coverage gaps. Please follow a TDD approach to all fixes.

Do not plan to make any changes that are not directly related to the reviewer's comments or to insufficient test coverage on modified files.

If you're unsure whether a comment is valid after reading the code, ask me rather than guessing.

If there are no comments, wait and try again using the bash command 'sleep 10m'
"@

    copilot --prompt $prompt --model claude-opus-4.6
}

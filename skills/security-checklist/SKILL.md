---
name: security-checklist
description: "Runs a security review against plans, code changes, or architecture decisions. Integrates with creating-implementation-plan, iterating-plans, and requesting-code-review. Use when you say: 'security check', 'review security', 'check for vulnerabilities', 'security audit'."
---

# Security Checklist

Run a structured security review against plans, code changes, or architecture decisions. Dispatches a security-reviewer subagent when reviewing code, or applies the checklist inline when reviewing plans.

## When to Use

**Mandatory integration points:**
- During `creating-implementation-plan` — after Step 4 (Plan Structure), before writing the final plan
- During `iterating-plans` — when changes touch authentication, authorization, data handling, external APIs, or secrets
- During `requesting-code-review` — dispatched alongside the code-reviewer subagent

**Standalone:**
- When asked to audit a plan, design, or codebase for security concerns
- Before deploying to production
- When introducing new external dependencies or integrations

## Plan Review Mode

When invoked during plan creation or iteration, apply the checklist directly to the plan document. Add findings to a `## Security Review` section at the end of the plan, before `## References`.

### Checklist for Plans

#### Authentication & Authorization
- [ ] Does the plan specify who can perform each action?
- [ ] Are authentication requirements explicit for every endpoint/entry point?
- [ ] Is the authorization model defined (roles, permissions, ownership)?
- [ ] Are privilege escalation paths considered and blocked?

#### Data Handling
- [ ] Are sensitive data fields identified (PII, credentials, tokens)?
- [ ] Is data classified by sensitivity level?
- [ ] Are encryption requirements specified (at rest, in transit)?
- [ ] Is data retention and deletion addressed?
- [ ] Are logging constraints defined (no secrets, no PII in logs)?

#### Input Boundaries
- [ ] Are all system boundaries identified (user input, external APIs, file uploads)?
- [ ] Is validation specified at each boundary?
- [ ] Are injection vectors addressed (SQL, XSS, command injection, path traversal)?
- [ ] Are rate limiting and abuse prevention considered?

#### Secrets & Configuration
- [ ] Are secrets management requirements defined (no hardcoded secrets)?
- [ ] Is the configuration model safe (no secrets in env vars that get logged)?
- [ ] Are API keys and tokens scoped to minimum required permissions?
- [ ] Is secret rotation addressed?

#### Dependencies & Supply Chain
- [ ] Are new dependencies vetted for known vulnerabilities?
- [ ] Are dependency versions pinned?
- [ ] Is the attack surface of new dependencies understood?

#### Error Handling & Information Disclosure
- [ ] Do error responses avoid leaking internal details to callers?
- [ ] Are stack traces suppressed in production?
- [ ] Are error messages safe for external consumption?

#### Infrastructure & Deployment
- [ ] Are network boundaries and access controls defined?
- [ ] Is the deployment pipeline secure (no secrets in CI logs)?
- [ ] Are rollback procedures safe (no dangling permissions or leaked state)?

### Plan Review Output

Add a `## Security Review` section to the plan:

```markdown
## Security Review

**Status:** [Clean | Concerns Noted | Blockers Found]
**Reviewed:** [Date]

### Findings

#### Blockers (Must resolve before implementation)
- [Finding with specific plan section reference]

#### Concerns (Address during implementation)
- [Finding with specific plan section reference]

#### Recommendations
- [Improvement that would strengthen the security posture]

### Checklist Coverage
[Note which checklist categories were applicable and which were not relevant to this plan]
```

## Code Review Mode

When invoked alongside `requesting-code-review`, dispatch a security-reviewer subagent using the Task tool. Fill the template at `security-reviewer.md` with these placeholders:

- `{WHAT_WAS_IMPLEMENTED}` — What was built
- `{PLAN_OR_REQUIREMENTS}` — Security-relevant requirements from the plan
- `{FROM_REV}` — Starting revision
- `{TO_REV}` — Ending revision
- `{DESCRIPTION}` — Brief summary of the change
- `{SECURITY_CONTEXT}` — Known security-sensitive areas (auth, data handling, external APIs, etc.)

### How to Dispatch

```
[Identify security-relevant changes in the diff]

jj diff --from {FROM_REV} --to {TO_REV} --stat

[Dispatch security-reviewer subagent via Task tool using security-reviewer.md template]
```

### Acting on Findings

- **Blockers**: Stop. Fix before proceeding. These are vulnerabilities or missing controls.
- **Concerns**: Track as follow-up items. May proceed if risk is accepted explicitly.
- **Recommendations**: Note for future hardening.

## Integration with Other Skills

**creating-implementation-plan:**
After the plan structure is confirmed (Step 4) and before writing the final plan (Step 5), run the plan-mode checklist. Add the `## Security Review` section to the plan output.

**iterating-plans:**
When plan changes touch security-sensitive areas, re-run the relevant checklist sections against the updated plan. Update the `## Security Review` section.

**requesting-code-review:**
Dispatch the security-reviewer subagent in parallel with the code-reviewer subagent. Both run against the same revision range. Merge findings into the review feedback.

## Guidelines

- **Be specific**: Reference plan sections, file:line locations, or contract numbers — not vague warnings
- **Be proportional**: Not every plan needs every checklist item. Note what's not applicable.
- **No security theater**: Only flag real risks, not theoretical concerns that don't apply to the context
- **Prefer prevention over detection**: Push security left — catch issues in the plan before they become code
- **Trust the framework**: Don't flag framework-provided protections as missing (e.g., CSRF tokens in Rails)
- **Severity matters**: Distinguish between a missing auth check (blocker) and a missing rate limit on an internal endpoint (recommendation)

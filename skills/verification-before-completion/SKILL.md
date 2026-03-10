---
name: verification-before-completion
description: "Use when about to claim work is complete, fixed, or passing, before committing or creating PRs. Requires running verification commands and confirming output before making any success claims. Evidence before assertions, always."
---

# Verification Before Completion

Run the command. Read the output. Only then claim the result.

**Core principle:** Evidence before claims, always. Violating the letter of this rule is violating the spirit of this rule.

## The Iron Law

```text
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If the verification command has not run in this message, you cannot claim it passes.

## The Gate Function

Before claiming any status or expressing satisfaction:

1. **IDENTIFY** — What command proves this claim?
2. **RUN** — Execute the full command fresh and complete
3. **READ** — Full output, check exit code, count failures
4. **VERIFY** — Does the output confirm the claim?
   - If NO: state the actual status with evidence
   - If YES: state the claim with evidence
5. **ONLY THEN** — Make the claim

Skip any step and the claim is unverified.

## What Counts as a Claim

Any communication that implies success, completion, or correctness:

- Exact phrases ("All tests pass", "Build succeeds", "Done")
- Paraphrases and synonyms ("Everything looks good", "That should do it")
- Implications ("Moving on to the next phase", "Ready for review")
- Expressions of satisfaction ("Great!", "Perfect!")

All require fresh evidence.

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output showing 0 failures | Previous run, "should pass" |
| Linter clean | Linter output showing 0 errors | Partial check, extrapolation |
| Build succeeds | Build command exit 0 | Linter passing, "logs look good" |
| Bug fixed | Original symptom verified as resolved | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed task | VCS diff shows correct changes | Agent reports "success" |
| Requirements met | Line-by-line checklist against plan | Tests passing |
| Phase complete | Plan success criteria all confirmed | Some criteria checked |

## Integration with Plan-First Workflow

This skill is the final gate that runs on top of the existing plan workflow. It does not replace the verification steps in sibling skills — it enforces that those steps actually ran and produced evidence.

### With `implementing-plans`

Before marking a phase checkbox complete:

1. Re-read the plan's success criteria for this phase
2. Run every automated verification the plan specifies
3. Confirm each criterion against actual output
4. If the plan has manual verification steps, pause for human confirmation
5. Only then update the checkbox

Do not check off plan items based on "the code looks right" or "the test I wrote should cover this."

### With `specification-driven-tdd`

The RED-GREEN-REFACTOR cycle has its own verification requirements. This skill adds:

- After RED: verify the test actually failed, for the expected contract reason, with evidence
- After GREEN: verify the test actually passed and the suite is still green, with evidence
- After REFACTOR: verify the suite is still green, with evidence

Do not move between phases without running and reading the output.

### With `subagent-driven-development`

When an implementer subagent reports completion:

1. Do not trust the report — verify independently
2. Check VCS diff to confirm the changes match the task
3. Run the task's required automated verification yourself
4. Only mark the task complete after both reviews pass and checks are green

### With plan success criteria

The plan's success criteria are the verification source of truth, not your intuition about whether the code is correct. Verify against the plan, not against your confidence.

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | Run the verification |
| "I'm confident" | Confidence is not evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter is not the compiler |
| "Agent said success" | Verify independently |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |
| "The code looks correct" | Looking is not running |
| "I already verified something similar" | Similar is not this |

## Red Flags — Stop

Stop and run verification if you catch yourself:

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification
- About to commit, push, or create a PR without verification
- Trusting agent success reports without independent checks
- Relying on partial verification for a full claim
- Thinking "just this once"
- Wanting the work to be over
- Wording that implies success without having run the command

## Evidence Patterns

**Tests:**
```
✅ [Run test command] → [See: 34/34 pass] → "All 34 tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD red-green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green evidence)
```

**Build:**
```
✅ [Run build] → [See: exit 0] → "Build passes"
❌ "Linter passed so build should be fine"
```

**Plan requirements:**
```
✅ Re-read plan → Create checklist → Verify each item → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Run verification → Report actual state
❌ Trust agent report
```

## Non-Negotiable Rules

- No completion claims without fresh verification evidence in this message
- No checking off plan items without confirming the plan's success criteria
- No committing, pushing, or creating PRs without verification
- No trusting agent self-reports as a substitute for independent verification
- No partial verification standing in for full verification
- No expressing satisfaction before evidence confirms the claim
- No exceptions

## The Bottom Line

```text
Run the command → Read the output → THEN claim the result
Otherwise → not verified
```

---
name: receiving-code-review
description: "Use when receiving code review feedback, before implementing suggestions. Requires technical verification and evaluation of each item — not performative agreement or blind implementation. Integrates with subagent-driven-development review loops."
---

# Receiving Code Review

Process review feedback with technical rigor. Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## When to Use This Skill

- After a code-quality or spec-compliance reviewer returns findings
- After a human reviewer leaves PR comments
- After an external reviewer suggests changes
- In the subagent-driven-development loop when the controller receives reviewer output

## The Response Pattern

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

## Forbidden Responses

**NEVER say:**
- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Thanks for catching that!" or any gratitude expression
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working — actions over words

**When acknowledging correct feedback:**
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch — [specific issue]. Fixed in [location]."
✅ [Just fix it and show in the code]

❌ Any performative agreement or gratitude
```

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP — do not implement anything yet
  ASK for clarification on ALL unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
Reviewer: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

## Source-Specific Handling

### From Your Human Partner

- **Trusted** — implement after understanding
- **Still ask** if scope is unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment

### From Subagent Reviewers (spec-reviewer, code-quality-reviewer)

When the controller receives reviewer output in a `subagent-driven-development` loop:

1. Read the full reviewer report — do not skim severity labels
2. For each finding, verify by reading the referenced file:line
3. Distinguish between findings that trace to real specification/quality problems and findings that misunderstand context the reviewer lacked
4. If the reviewer lacked context that would change the finding, the controller should provide that context and redispatch the reviewer — not silently dismiss the finding
5. For valid findings, send the task back to the implementer with the specific issues to fix
6. Rerun the same reviewer after fixes — do not skip re-review

### From External Reviewers (PR comments, GitHub reviews)

```
BEFORE implementing:
  1. Check: Technically correct for THIS codebase?
  2. Check: Breaks existing functionality?
  3. Check: Reason for current implementation?
  4. Check: Works on all platforms/versions?
  5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning

IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I investigate/ask/proceed?"

IF conflicts with human partner's prior decisions:
  Stop and discuss with human partner first
```

## YAGNI Check

When a reviewer suggests "implementing properly" or adding features:

```
grep codebase for actual usage

IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
IF used: Then implement properly
```

## Implementation Order

```
FOR multi-item feedback:
  1. Clarify anything unclear FIRST
  2. Then implement in this order:
     - Blocking issues (breaks, security, spec violations)
     - Simple fixes (typos, imports, naming)
     - Complex fixes (refactoring, logic changes)
  3. Test each fix individually
  4. Verify no regressions
```

## When to Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with human partner's architectural decisions
- Contradicts the governing specification

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests or code
- Involve human partner if architectural

**Signal if uncomfortable pushing back out loud:** "Strange things are afoot at the Circle K"

## Gracefully Correcting Your Pushback

If you pushed back and were wrong:
```
✅ "You were right — I checked [X] and it does [Y]. Implementing now."
✅ "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
❌ Over-explaining
```

State the correction factually and move on.

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

## Integration with Subagent-Driven Development

This skill governs the controller's behavior at steps 7–11 of the `subagent-driven-development` workflow:

| SDD Step | This Skill Applies |
|----------|-------------------|
| 7. Spec review returns | READ and VERIFY each finding against code |
| 8. Send back to implementer | Only after confirming findings are valid |
| 9. Code-quality review returns | Same READ → VERIFY → EVALUATE pattern |
| 10. Send back to implementer | Only for validated findings |
| 11. Mark task complete | Only when both reviews pass with no unresolved findings |

**Controller must not:**
- Auto-accept all reviewer findings without verification
- Dismiss findings because the implementer "already self-reviewed"
- Skip re-review after fixes

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |
| Dismissing subagent reviewer | Provide missing context and redispatch |

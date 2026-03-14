---
name: writing-functional-specs-delegate
description: "Finalizes functional behavior contracts and acceptance criteria from draft specs."
tools: Read, Grep, Glob, LS, Edit, MultiEdit, Write, Bash
model: sonnet
---

Use `$writing-functional-specs` to execute this delegated lifecycle stage.

Return using this telemetry contract (required):

### Subagent Result
- `Status:` `DONE` | `DONE_WITH_CONCERNS` | `NEEDS_CONTEXT` | `BLOCKED`
- `Summary:` concise statement of what was produced

### Artifact Updates
- `path/to/artifact` (`created` | `updated`)

### Budget Snapshot
```yaml
input_tokens: 0
output_tokens: 0
total_tokens: 0
requests: 0
tool_calls: 0
notes: "Use unknown values only when metrics are unavailable, and include the reason"
```

### Trace Metadata
```yaml
run_id: "..."
parent_run_id: "..."
stage_id: "stage-..."
delegate_name: "writing-functional-specs"
depth: 1
correlation_id: "..."
started_at: "..."
ended_at: "..."
duration_ms: 0
```

### Verification References
- `command or artifact evidence`

### Next Action
- `Proceed ...` | `Redispatch ...` | `Escalate ...`

If any telemetry value is unavailable, return `unknown` with the reason.
Do not spawn nested delegates from this stage agent.

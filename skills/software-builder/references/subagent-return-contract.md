# Subagent Return Contract

Use this contract for every delegated stage return in `software-builder` (Stages 1 through 12).

## Required Fields

1. `Status` — `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, or `BLOCKED`
2. `Summary` — concise statement of what was produced
3. `Artifact updates` — created/updated paths
4. `Budget snapshot` — `input_tokens`, `output_tokens`, `total_tokens`, `requests`, `tool_calls`
5. `Trace metadata` — `run_id`, `parent_run_id`, `stage_id`, `delegate_name`, `depth`, `correlation_id`, `started_at`, `ended_at`, `duration_ms`
6. `Verification references` — commands, checks, or evidence pointers
7. `Next action` — proceed, redispatch, or escalate

If a metric is unavailable, return `unknown` and include a reason.

## Suggested Markdown Shape

### Subagent Result
- `Status:` ...
- `Summary:` ...

### Artifact Updates
- `path/to/file.md` (created)
- `path/to/other.md` (updated)

### Budget Snapshot
```yaml
input_tokens: 0
output_tokens: 0
total_tokens: 0
requests: 0
tool_calls: 0
notes: "unknown metrics must include reason"
```

### Trace Metadata
```yaml
run_id: "..."
parent_run_id: "..."
stage_id: "stage-4"
delegate_name: "translating-shape-to-spec"
depth: 1
correlation_id: "..."
started_at: "2026-03-14T00:00:00Z"
ended_at: "2026-03-14T00:00:10Z"
duration_ms: 10000
```

### Verification References
- `jj status`
- `...`

### Next Action
- `Proceed to Stage 5`

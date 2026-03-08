# Agent Presets

This skill is authored once and then adapted to each agent shell.

## Amp

Install path:

- `~/.config/agents/skills/humanizing-writing/SKILL.md`

Use:

- Trigger naturally: "humanize this"
- Or invoke explicitly with the `humanizing-writing` skill

## Claude

Install path:

- `~/.claude/skills/humanizing-writing/SKILL.md`

Claude supports the same `SKILL.md` structure used in Amp, so this file can be copied as-is.

## Codex

Codex does not require `SKILL.md` frontmatter. Use this wrapper in `AGENTS.md` or your system prompt:

```markdown
When asked to humanize writing, apply the workflow in `skills/humanizing-writing/SKILL.md` and the lexical checks in `skills/humanizing-writing/references/ai-tells.md`.

Output:
1. Full rewrite
2. `### Changes` table with only changed passes

Preserve factual meaning. Never invent sources.
```

## ChatGPT

Add to Custom GPT "Instructions" or project instructions:

```markdown
Role: Expert editor for removing AI-writing patterns.

When user asks to humanize text:
- Rewrite the full text so it sounds natural, specific, and human.
- Remove AI tells: formulaic structure, significance inflation, hedging/filler, vague attributions, repetitive transitions, and chatbot artifacts.
- Keep technical accuracy and original argument.

After rewriting, include:
### Changes
| Pass | What changed | Examples |
|-|-|-|

Only include passes you actually changed. Keep it concise.
```

## OpenCode

Use the same wrapper pattern as Codex in OpenCode's project instruction file:

```markdown
Apply the `humanizing-writing` workflow for de-AI rewrites. Preserve meaning, remove AI patterns, and return a full rewrite plus a concise `### Changes` table.
```

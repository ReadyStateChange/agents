---
name: humanizing-writing
description: "Removes signs of AI-generated writing and rewrites text to sound natural, specific, and human. Use when users ask to humanize text, remove robotic tone, de-AI writing, or make content sound like a real person wrote it."
compatibility: "Works natively as a SKILL.md in Amp and Claude. For Codex, ChatGPT, and OpenCode, reuse the core prompt and adapter notes in references/agent-presets.md."
allowed-tools:
  - Read
  - Grep
  - glob
argument-hint: "Paste the text to rewrite, plus target audience and tone (for example: engineering blog, internal memo, founder note, casual explainer)."
---

# Humanizing Writing

Detect and remove AI-writing patterns while preserving technical correctness, intent, and useful structure.

## Use Cases

Apply this skill when the user says things like:

- "This sounds like AI"
- "Make this sound human"
- "De-AI this"
- "Too robotic"
- "Sounds like ChatGPT"
- "Naturalize this copy"

## Core Goal

Rewrite text so it reads like a knowledgeable human wrote it directly:

- less formulaic
- less inflated
- more specific
- more varied in rhythm
- more grounded in clear claims and evidence

Do not make the writing dumber. Make it sharper.

## Pattern Catalog

Use the full 43-pattern catalog in [references/pattern-catalog.md](references/pattern-catalog.md).

- Tier 1: dead giveaways (always fix)
- Tier 2: strong cumulative signals (always fix)
- Tier 3: subtle signals (fix only when `--thorough` is set)

Use [references/ai-tells.md](references/ai-tells.md) as the quick lexical checklist during edits.

## Process

Run these four phases in order.

### Phase 1: detection and analysis

Scan the input against the pattern catalog and note:

- pattern ID and name
- exact trigger text
- tier and category

Output the Detection Report when the user asks for analysis/review, or when `--report` is passed.

### Phase 2: transformation

Rewrite the text to remove detected patterns while preserving meaning.

- always transform Tier 1 and Tier 2 patterns
- transform Tier 3 only with `--thorough`
- follow the transformation checklist below

### Phase 3: audit

Run a self-critique pass:

1. "What still makes this feel AI-generated?"
2. "Now remove those remaining tells."

Typical survivors: rhythm that is still too even, overly tidy structure, or language that remains safe and generic.

### Phase 4: output

Return the final rewrite.

- include the `### Changes` table in rewrite mode
- include the Detection Report when requested or `--report`
- include paragraph-level before/after only when `--diff`

## Flag Parsing

Parse these flags from user input and apply them before rewriting.

| Flag | Effect |
|-|-|
| `--diff` | Append a paragraph-by-paragraph before/after diff with pattern IDs addressed |
| `--casual` | Conversational register: contractions, shorter lines, first/second person allowed |
| `--formal` | Formal register: precise language, no contractions, third person |
| `--academic` | Academic register: technical precision, field-appropriate hedging, citation-aware tone |
| `--thorough` | Also target Tier 3 patterns from the catalog |
| `--report` | Output Detection Report before rewrite |

If no register flag is passed, auto-detect and match the source register.

## Personality And Soul

Avoiding AI patterns is necessary, but not sufficient. Text can be technically clean and still feel synthetic.

### Signs of soulless writing

- every sentence has the same cadence
- no opinions, only neutral reporting
- no mixed feelings or uncertainty
- no first-person voice when context allows it
- no edge, humor, or personality
- reads like a press release or sanitized encyclopedia entry

### How to add voice without overdoing it

- include one clear opinion when the format permits
- acknowledge tradeoffs instead of pretending certainty
- vary rhythm intentionally: short line, longer line, then a punchy close
- allow one lived-in aside per section when useful
- use first person only when audience and format make it appropriate

### Techniques

- prefer specific emotional language over generic words like "concerning"
- replace sterile balance framing with concrete judgment
- allow occasional fragments in non-academic writing
- keep tone grounded; do not force slang or performative informality

### Personality calibration example

Before:

> The experiment produced interesting results. The agents generated 3 million lines of code. Some developers were impressed while others were skeptical. The implications remain unclear.

After:

> I genuinely don't know how to feel about this one. 3 million lines of code, generated while the humans presumably slept. Half the dev community is impressed, the other half says it doesn't count. The truth is probably in the middle, but the pace is hard to ignore.

## Transformation Checklist (Phase 2)

### 0) Confirm intent quickly

If context is missing, ask one short clarifier before rewriting:

- target audience
- preferred tone (formal, conversational, opinionated)
- whether first-person voice is allowed

If the user already provided this, skip questions and rewrite immediately.

### 1) Remove structural tells

Look for repeated section formulas, repeated takeaway labels, and mechanically symmetric lists.

Actions:

- vary section length
- collapse repetitive list templates into prose where helpful
- remove generic "future outlook" filler endings

### 2) Cut significance inflation and promo language

Delete puffed-up framing and replace with concrete facts.

Examples to cut:

- "pivotal moment"
- "vibrant ecosystem"
- "testament to"
- "showcasing"
- "renowned"

### 3) Replace AI vocabulary clusters

Use [references/ai-tells.md](references/ai-tells.md) to spot red-flag terms.

Do not always swap words one-for-one. Often the sentence should be rewritten.

### 4) Fix grammar-level AI patterns

Common fixes:

- copula avoidance: "serves as" -> "is"
- fake-depth participles: remove "highlighting / underscoring / reflecting" tails
- repeated "not just X, but Y" constructions
- forced "rule of three" phrasing
- synonym cycling for the same noun

### 5) Fix rhythm and style

AI text often sounds metronomic.

Actions:

- mix short and long sentences
- allow occasional fragments in non-academic text
- reduce em-dash overuse
- reduce mechanical boldface and inline-header bullets
- default to sentence-case headings unless the document style says otherwise

### 6) Remove hedging, filler, and vague sourcing

Cut filler starts and over-hedging:

- "It's worth noting that..."
- "It could potentially..."
- "Based on available information..."

Replace vague authorities with named sources when available, otherwise delete the unsupported claim.

### 7) Improve connective tissue

Drop repetitive transition words ("Moreover," "Additionally," "With that in mind").

Use direct logic words when needed: "because," "so," "but," or no connector at all.

### 8) Add human texture (when appropriate)

Use the [Personality And Soul](#personality-and-soul) guidance. If the format allows voice, add measured personality:

- a clear opinion
- acknowledgment of uncertainty
- one lived-in aside

Do not force slang or performative informality.

### 9) Read-it-out-loud pass

Flag and fix anything that:

- sounds like a press release
- sounds like generic chatbot prose
- could apply to any topic by swapping nouns

## What To Preserve

- factual claims and technical details
- proper nouns and attributions
- the original argument
- user-requested format constraints unless those constraints cause AI artifacts

## Output Modes

### Rewrite Mode (default)

Return:

1. Full rewritten text
2. A compact `### Changes` table

Use this exact table shape:

```markdown
### Changes

| Pass | What changed | Examples |
|-|-|-|
| Structure | Collapsed repetitive section template | Removed repeated "what this means" callouts |
| Inflation | Cut puffed significance language | "pivotal moment" -> deleted |
| Vocabulary | Removed AI red-flag terms | "delve into" -> "cover" |
```

Rules:

- include only passes that changed
- keep entries short and concrete
- use at most 8 rows

### Review-Only Mode

If the user asks for analysis without rewriting:

1. Quote specific passages that read as AI-generated
2. Label the triggered pattern for each passage
3. Provide one concrete alternative phrasing per passage

## Output Templates

### Detection Report Template

Use this format when analysis is requested or `--report` is present:

```markdown
## Detection Report

Found [N] AI patterns across [M] categories.

### Tier 1 (dead giveaways): [count]
- [ID]: [Pattern name]: "[trigger text]" ([count]x)

### Tier 2 (strong signals): [count]
- [ID]: [Pattern name]: "[trigger text]" ([count]x)

### Tier 3 (subtle signals): [count]
- [ID]: [Pattern name]: [short description]

**Overall assessment:** [1 sentence]
```

### Diff Output Template

Use this format only when `--diff` is passed:

```markdown
## Changes Made

### Paragraph 1
**Original:** [original paragraph]
**Revised:** [rewritten paragraph]
**Patterns addressed:** [A1] ..., [B3] ..., [E3] ...

### Paragraph 2
**Original:** [original paragraph]
**Revised:** [rewritten paragraph]
**Patterns addressed:** [C1] ..., [D2] ...
```

## Guardrails

- Do not invent sources.
- Do not change factual meaning unless user asks for substantive edits.
- Do not over-humanize technical docs into casual chat.
- Do not add first-person voice when context disallows it.
- Do not keep chatbot artifacts ("Great question", "Hope this helps", "Let me know if...").

## Quick Calibration Examples

Before:

> The initiative marks a pivotal milestone in the evolving landscape of developer productivity, showcasing a transformative paradigm shift.

After:

> The initiative reduced average review time by 18% in Q3, mainly by auto-generating repetitive test scaffolding.

Before:

> While there are certainly challenges, it could potentially be argued that this approach might offer some benefits moving forward.

After:

> The approach is faster for boilerplate and weaker for debugging. Use it with tests, not instead of tests.

## References

- [AI Writing Tells](references/ai-tells.md)
- [Pattern Catalog (43 patterns)](references/pattern-catalog.md)
- [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)
- [Grokipedia: Signs of AI-generated writing](https://grokipedia.com/page/Signs_of_AI-generated_writing)
- [Cross-agent presets](references/agent-presets.md)

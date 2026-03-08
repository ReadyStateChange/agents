---
name: locating-thoughts
description: "Finds relevant research, plan, and decision documents in the project. Use when you say: 'do we already have a plan for...', 'find prior decisions about...', 'look for previous research or design notes'."
allowed-tools:
  - finder
  - Grep
  - glob
  - Read
---

# Locating Documents

Find and categorize research, plan, and decision documents in the project without deep analysis of their contents.

## Workflow

1. **Search the project** for docs directories using `glob` (e.g., `docs/**/*.md`, `plans/**/*.md`, `research/**/*.md`)
2. **Use Grep** for content keywords and `glob` for filename patterns
3. **Use multiple search terms** — include synonyms, technical terms, and related concepts
4. **Categorize** findings into research documents vs implementation plans vs decisions
5. **Return organized results** grouped by type with file paths and one-line descriptions from the title/header

## Output Format

```
## Documents about [Topic]

### Research Documents
- `path/to/YYYY-MM-DD-topic.md` - Brief description from title

### Implementation Plans
- `path/to/YYYY-MM-DD-topic.md` - Brief description from title

### Decisions / Design Docs
- `path/to/topic.md` - Brief description from title

Total: N relevant documents found
```

## Guidelines

- Don't read full file contents — just scan titles and headers for relevance
- Be thorough — use multiple search terms and check all subdirectories
- Group logically by document type
- Include the date from the filename to help assess recency
- Report complete file paths from the repository root

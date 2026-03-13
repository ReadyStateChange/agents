# Repository Guidance

## Purpose

This repository is a skill library for AI coding agents.

- Skill definitions live under `skills/<skill-name>/SKILL.md`
- Supporting references, scripts, and assets should stay scoped to each skill directory

## Version Control

This repo uses **Jujutsu (`jj`)** as the primary VCS workflow.

- Prefer `jj` commands for history, status, diffs, branching, and commits
- Do not default to git-only workflows when `jj` equivalents exist
- If interoperability is needed, use `jj git` bridge commands explicitly

### Required JJ Commit And Push Flow

- Before committing, verify scope with `jj status` and `jj diff --summary`
- Commit the working change with `jj commit -m "<what changed and why>"`
- Move `main` to the committed change with `jj bookmark move main --to @-`
- Push with `jj git push --bookmark main`

## Change Style

- Keep skill docs concise and scannable
- Prefer progressive disclosure: keep `SKILL.md` focused and move large catalogs into `references/`
- Preserve existing skill naming and frontmatter conventions

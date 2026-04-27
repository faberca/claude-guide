---
name: commit-flow
description: Quick git commit with proper format
disable-model-invocation: true
---

Stage, commit, and optionally push changes.

1. Run `git status` and `git diff --staged` to see changes
2. Analyze all changes and draft a concise commit message
3. Stage relevant files (never use `git add -A` blindly)
4. Commit with descriptive message
5. Ask user: "Push to remote?"
6. If yes, push. If no, done.

Commit message format:
- feat: new feature
- fix: bug fix
- docs: documentation
- refactor: code restructuring
- test: adding tests

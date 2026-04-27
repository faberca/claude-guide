---
name: review
description: Review code changes before committing
disable-model-invocation: true
---

Review all uncommitted changes for quality and correctness.

1. Run `git diff` to see all changes
2. For each changed file, check:
   - Does the change do what was intended?
   - Any security issues? (injection, hardcoded secrets, XSS)
   - Any edge cases missed?
   - Is error handling adequate?
   - Could it be simpler?
3. Run tests if they exist: find test command in package.json, Makefile, etc.
4. Report findings with specific file:line references
5. Suggest fixes for any issues found

# Self-Improving Rules

When Claude makes a mistake:
1. Abstract it into a general pattern
2. Add a rule to .claude/rules/ to prevent recurrence
3. If Claude already does something correctly, don't add a rule for it

## Fix Loop Detection
- Same file gets 2+ fix commits -> analyze root cause before more fixes
- Don't stack band-aid fixes. Find the architectural solution.
- 3 "quick fixes" in a row = likely a design problem.

## Execution Bias
- Task stuck 3+ days -> break into 5-unit chunks
- Don't over-engineer rules. Write once, validate through execution.
- If an approach feels wrong on first try, STOP and reconsider.

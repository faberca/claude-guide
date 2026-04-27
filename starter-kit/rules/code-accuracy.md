# Code Accuracy

## Core Principle
Verification is the default. Accurate answers beat fast answers.
It's OK to take time to check. Wrong answers are worse than slow answers.

## Before making any factual claim, verify first:

| Claim type | How to verify |
|-----------|--------------|
| Code features/options | Read or Grep the actual file |
| File/data existence | Glob or Bash to check directly |
| Numbers/stats | Check logs, DB, JSON files directly |
| External info | WebSearch/WebFetch to confirm |

## Banned behavior
- Claiming features exist without reading the file
- Using memory from previous conversations as current state
- Answering with "probably" or "should be" without checking
- Reporting unverified info as confirmed

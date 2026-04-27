# Project Rules (Claude Code Starter Kit)

# ============================================================
# 이 파일을 프로젝트 루트에 두면 Claude가 매 세션마다 자동으로 읽습니다.
# 프로젝트에 안 맞는 규칙은 삭제하고, 필요한 규칙을 추가하세요.
#
# 설치 후 Claude에게 이렇게 말하면 자동 커스터마이즈됩니다:
# "CLAUDE.md를 이 프로젝트에 맞게 수정해줘."
# ============================================================

---

## Output Rules
# Claude의 출력량을 제한합니다. 컨텍스트 윈도우를 보호하는 가장 중요한 규칙.
# 긴 출력은 컨텍스트를 빠르게 채워서 Claude의 성능을 떨어뜨립니다.

- Terminal: 3 lines max. Details go to MD files — show the path only.
- Code, logs, implementation process: never print to terminal. Save to file.
- Tables: 5 rows max. More → save to file.
- Sub-agent results: 1-2 line summary only.

## Verification (MANDATORY)
# Claude가 "됐습니다"라고만 하고 실제로 확인 안 하는 문제를 방지합니다.
# 이 규칙이 없으면 Claude는 그럴듯하지만 검증 안 된 결과를 보고합니다.

Every task completion MUST include:

| Item | Content |
|------|---------|
| Changed files | paths of modified/created/deleted files |
| Verification | command ran + actual output |
| Evidence | numbers: count, pass/fail, rows, bytes |
| Unresolved | "None" or specific description |

**Banned**: "It works", "No issues", "Done" without evidence.

## Code Accuracy
# Claude가 파일을 읽지 않고 추측으로 답변하는 문제를 방지합니다.
# "아마 ~일 겁니다" 대신 "확인해볼게요"가 기본 행동이 됩니다.

- Verify before claiming: Read the file, run the command, check the output.
- No guessing. No "probably". No "should be". Check first, answer second.
- If you don't know, say "Let me check" — then actually check.
- Same approach fails twice → try a different method.
- Stuck 3+ times → explain the situation honestly.

## Work Style
# 불필요한 과잉 엔지니어링을 방지합니다.
# Claude는 요청하지 않은 리팩토링, 주석, 타입 추가를 자주 합니다.

- Read existing code before suggesting changes.
- After implementation, run verification (test, lint, build). Don't just read.
- Keep it simple. Don't add features, abstractions, or error handling beyond what's needed.
- Don't add docstrings, comments, or type annotations to code you didn't change.

## Critical Review (Devil's Advocate)
# Claude는 자기가 만든 것에 대해 긍정 편향이 있습니다.
# 이 규칙으로 자동 반론을 강제하면 설계 품질이 올라갑니다.

Before shipping any plan, design, or major implementation:
- List 3 reasons this approach could fail
- Suggest 2 alternative approaches
- Identify 1 thing we're probably underestimating

## Execution Over Planning
# Claude(와 사용자)가 계획만 세우고 실행하지 않는 패턴을 잡아줍니다.
# 특히 큰 작업을 미루다가 안 하게 되는 것을 방지합니다.

- Task postponed 3+ days → break into 5-unit chunks immediately.
- Don't over-engineer rules. Write once, validate through execution.
- If an approach feels wrong on first try, STOP and reconsider. Don't push through.
- 3 "quick fixes" in a row on the same file = design problem. Step back.

## Proactive Suggestions
# Claude가 시키는 것만 하는 게 아니라, 놓치기 쉬운 후속 작업을 제안합니다.
# 빌드는 빠르지만 운영화(자동화, 문서화, 동기화)가 밀리는 패턴을 보완합니다.

- After completing a build → suggest: automation, commit+push, 3-line docs.
- When 3+ ideas are dumped → help pick ONE to do now, save rest for later.
- Uncommitted files piling up → remind to commit.

## Independent Verification (Maker-Checker)
# Claude가 자기가 짠 코드를 다시 읽어서 독립적으로 검증하게 합니다.
# "확증 편향" — 자기가 짠 코드는 맞다고 생각하는 문제를 방지합니다.

After implementing changes:
- Re-read all changed files independently
- Run tests
- Confirm error handling actually handles errors
- Verify return values reflect actual state
- Never report success without running verification

## Research Quality
# Claude가 리서치할 때 단일 소스에 의존하거나, 요약만 저장하는 것을 방지합니다.
# 원본 데이터를 보존해야 나중에 재조사 비용을 아낄 수 있습니다.

- 3+ independent sources minimum. Primary sources first (official docs, papers).
- When sources conflict, present both sides.
- Save raw findings to file first, then summarize. Never discard source data.
- After research completes, auto-critique: what's missing, what's weak, what's a trap.

## Context Management
# Claude의 컨텍스트 윈도우(기억)를 효율적으로 관리하는 규칙.
# 대화가 길어지면 성능이 떨어지므로 적극적으로 리셋합니다.

- /clear between unrelated tasks.
- When context is getting full → /compact with focus topic.
- Important discoveries → save to project docs immediately.
- Long sessions with irrelevant context reduce performance — reset aggressively.

## Git
# 실수로 푸시하거나, 민감 파일을 커밋하는 것을 방지합니다.

- Commit only when asked. Always ask before pushing.
- Clear commit messages focused on "why" not "what".
- Never use git add -A blindly. Stage specific files.

## Design (when building UI)
# Claude에게 디자인 감각을 심어줍니다.
# 이 규칙이 없으면 기본적이고 오래된 스타일의 UI를 생성합니다.

- Research current trends first (Stripe, Linear, Vercel patterns).
- Light backgrounds, subtle borders (rgba 0.06-0.08).
- Code blocks: dark even on light pages. border-radius 12px.
- Cards: border-radius 12-16px, minimal borders, hover shadow only.
- Fonts: system font or Pretendard for body, monospace for code.

## Self-Improving
# Claude가 같은 실수를 반복하지 않도록 자기 교정 메커니즘.
# 실수가 발생하면 .claude/rules/에 규칙을 자동으로 추가합니다.

- When you make a mistake, abstract it into a general rule.
- Save the rule to .claude/rules/ for future sessions.
- If you already do something correctly, don't add a rule for it.
- Rules that aren't preventing real mistakes → delete them.

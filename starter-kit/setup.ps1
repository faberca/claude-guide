# Claude Code Starter Kit — 프로젝트 지침 추가
# 내용을 확인한 뒤 프로젝트 폴더에서 실행하세요. 기존 파일은 보존합니다.
# 기존 설정과 새 지침의 충돌은 별도로 비교하세요.

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$baseUrl = "https://claude-guide-sandy.vercel.app/starter-kit"

Write-Host ""
Write-Host "  Claude Code Starter Kit" -ForegroundColor Cyan
Write-Host "  ======================" -ForegroundColor DarkGray
Write-Host ""

# --- CLAUDE.md (짧은 공통 지침) ---
if (Test-Path "CLAUDE.md") {
    Write-Host "  [있음] CLAUDE.md" -ForegroundColor DarkGray
} else {
    Invoke-WebRequest "$baseUrl/CLAUDE.md" -OutFile "CLAUDE.md"
    Write-Host "  [설치] CLAUDE.md" -ForegroundColor Green
}

# --- 상세 절차: 필요할 때만 읽는 참고자료 ---
New-Item -ItemType Directory -Path ".claude/references" -Force | Out-Null
if (!(Test-Path ".claude/references/guide-workflows.md")) {
    Invoke-WebRequest "$baseUrl/references/guide-workflows.md" -OutFile ".claude/references/guide-workflows.md"
    Write-Host "  [설치] .claude/references/guide-workflows.md" -ForegroundColor Green
} else {
    Write-Host "  [보존] .claude/references/guide-workflows.md" -ForegroundColor DarkGray
}
# 기존 .claude/rules 파일은 수정하거나 삭제하지 않습니다.

# --- .claude/skills/ (유틸 스킬) ---
$skills = @("commit-flow", "review", "explain")
foreach ($s in $skills) {
    New-Item -ItemType Directory -Path ".claude/skills/$s" -Force | Out-Null
    if (!(Test-Path ".claude/skills/$s/SKILL.md")) {
        Invoke-WebRequest "$baseUrl/skills/$s/SKILL.md" -OutFile ".claude/skills/$s/SKILL.md"
        Write-Host "  [설치] .claude/skills/$s" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "  파일 준비 완료. 새 Claude Code 세션에서 지침과 작은 작업 결과를 확인하세요." -ForegroundColor White
Write-Host ""
Write-Host "  기존 지침과 중복되는 규칙이 있다면 다음처럼 요청하세요:" -ForegroundColor Yellow
Write-Host ""
Write-Host '  CLAUDE.md와 기존 rules를 먼저 읽고 중복과 충돌을 비교해줘.' -ForegroundColor Cyan
Write-Host '  기존 지침은 보존하고 필요한 변경을 설명한 뒤,' -ForegroundColor Cyan
Write-Host '  승인된 범위에서 반영하고 실제 적용을 확인해줘.' -ForegroundColor Cyan
Write-Host ""

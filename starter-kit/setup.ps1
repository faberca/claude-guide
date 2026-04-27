# Claude Code Starter Kit — 원클릭 세팅
# 프로젝트 폴더에서 실행하면 끝. Claude가 알아서 잘 하게 됩니다.
# irm https://claude-guide-sandy.vercel.app/starter-kit/setup.ps1 | iex

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$baseUrl = "https://claude-guide-sandy.vercel.app/starter-kit"

Write-Host ""
Write-Host "  Claude Code Starter Kit" -ForegroundColor Cyan
Write-Host "  ======================" -ForegroundColor DarkGray
Write-Host ""

# --- CLAUDE.md (올인원 프로젝트 규칙) ---
if (Test-Path "CLAUDE.md") {
    Write-Host "  [있음] CLAUDE.md" -ForegroundColor DarkGray
} else {
    Invoke-WebRequest "$baseUrl/CLAUDE.md" -OutFile "CLAUDE.md"
    Write-Host "  [설치] CLAUDE.md" -ForegroundColor Green
}

# --- .claude/rules/ (행동 규칙) ---
$rules = @("context-management.md", "verification.md", "code-accuracy.md", "self-improving.md")
New-Item -ItemType Directory -Path ".claude/rules" -Force | Out-Null
foreach ($r in $rules) {
    if (!(Test-Path ".claude/rules/$r")) {
        Invoke-WebRequest "$baseUrl/rules/$r" -OutFile ".claude/rules/$r"
        Write-Host "  [설치] .claude/rules/$r" -ForegroundColor Green
    }
}

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
Write-Host "  완료. 이제 claude 를 실행하세요." -ForegroundColor White
Write-Host ""
Write-Host "  다음 한마디면 프로젝트에 맞게 자동 커스터마이즈됩니다:" -ForegroundColor Yellow
Write-Host ""
Write-Host '  CLAUDE.md를 이 프로젝트에 맞게 수정해줘.' -ForegroundColor Cyan
Write-Host '  프로젝트 구조를 파악하고, 불필요한 규칙은 빼고,' -ForegroundColor Cyan
Write-Host '  이 프로젝트에 필요한 규칙을 추가해줘.' -ForegroundColor Cyan
Write-Host ""

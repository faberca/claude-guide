# Claude Code Windows 원클릭 설치 스크립트
# 사용법: irm https://claude-guide.vercel.app/install.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Claude Code 원클릭 설치" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# winget 확인
Write-Host "[확인] winget 설치 여부..." -ForegroundColor Yellow
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[오류] winget이 설치되어 있지 않습니다." -ForegroundColor Red
    Write-Host ""
    Write-Host "Windows 10 (1809+) 또는 Windows 11이 필요합니다." -ForegroundColor Red
    Write-Host "Microsoft Store에서 '앱 설치 관리자'를 설치해주세요:" -ForegroundColor Yellow
    Write-Host "  https://apps.microsoft.com/detail/9NBLGGH4NNS1" -ForegroundColor White
    Write-Host ""
    Read-Host "설치 후 Enter를 눌러 다시 시도하세요"
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "[실패] winget을 찾을 수 없습니다. 수동 설치가 필요합니다." -ForegroundColor Red
        exit 1
    }
}
Write-Host "[OK] winget 사용 가능" -ForegroundColor Green
Write-Host ""

$installed = @()
$skipped = @()

# ---- Git ----
Write-Host "[1/3] Git 확인 중..." -ForegroundColor Yellow
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVer = git --version 2>$null
    Write-Host "  [건너뜀] Git 이미 설치됨 ($gitVer)" -ForegroundColor DarkGray
    $skipped += "Git"
} else {
    Write-Host "  [설치] Git for Windows..." -ForegroundColor Cyan
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [완료] Git 설치 성공" -ForegroundColor Green
        $installed += "Git"
    } else {
        Write-Host "  [경고] Git 설치에 문제가 있을 수 있습니다" -ForegroundColor Yellow
    }
}

# ---- VSCode ----
Write-Host "[2/3] VSCode 확인 중..." -ForegroundColor Yellow
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "  [건너뜀] VSCode 이미 설치됨" -ForegroundColor DarkGray
    $skipped += "VSCode"
} else {
    Write-Host "  [설치] Visual Studio Code..." -ForegroundColor Cyan
    winget install --id Microsoft.VisualStudioCode -e --accept-source-agreements --accept-package-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [완료] VSCode 설치 성공" -ForegroundColor Green
        $installed += "VSCode"
    } else {
        Write-Host "  [경고] VSCode 설치에 문제가 있을 수 있습니다" -ForegroundColor Yellow
    }
}

# ---- Claude Code ----
Write-Host "[3/3] Claude Code 확인 중..." -ForegroundColor Yellow
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "  [건너뜀] Claude Code 이미 설치됨" -ForegroundColor DarkGray
    $skipped += "Claude Code"
} else {
    Write-Host "  [설치] Claude Code..." -ForegroundColor Cyan
    winget install --id Anthropic.ClaudeCode -e --accept-source-agreements --accept-package-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [완료] Claude Code 설치 성공" -ForegroundColor Green
        $installed += "Claude Code"
    } else {
        Write-Host "  [경고] Claude Code 설치에 문제가 있을 수 있습니다" -ForegroundColor Yellow
    }
}

# PATH 리프레시
Write-Host ""
Write-Host "[설정] 환경변수 갱신 중..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
Write-Host "[OK] 환경변수 갱신 완료" -ForegroundColor Green

# 결과 요약
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  설치 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($installed.Count -gt 0) {
    Write-Host "  새로 설치: $($installed -join ', ')" -ForegroundColor Green
}
if ($skipped.Count -gt 0) {
    Write-Host "  이미 있음: $($skipped -join ', ')" -ForegroundColor DarkGray
}

Write-Host ""

# 최종 확인
$allGood = $true
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  [!] Git을 찾을 수 없습니다 - 터미널을 재시작해보세요" -ForegroundColor Yellow
    $allGood = $false
}
if (!(Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "  [!] Claude Code를 찾을 수 없습니다 - 터미널을 재시작해보세요" -ForegroundColor Yellow
    $allGood = $false
}

if ($allGood) {
    Write-Host "  모든 도구가 정상 작동합니다!" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  다음 단계:" -ForegroundColor White
    Write-Host "  1. VSCode를 엽니다" -ForegroundColor White
    Write-Host "  2. Ctrl+` 로 터미널을 엽니다" -ForegroundColor White
    Write-Host "  3. claude 를 입력합니다" -ForegroundColor Cyan
    Write-Host "  4. 브라우저에서 로그인하면 끝!" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "  일부 도구를 찾을 수 없습니다." -ForegroundColor Yellow
    Write-Host "  PowerShell을 닫고 다시 열어보세요." -ForegroundColor Yellow
    Write-Host "  그래도 안 되면 PC를 재시작해보세요." -ForegroundColor Yellow
}

Write-Host ""

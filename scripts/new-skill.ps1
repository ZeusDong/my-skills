param(
    [Parameter(Mandatory = $true)]
    [string]$SkillName,

    [Parameter(Mandatory = $false)]
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$pattern = "^[a-z0-9]+(-[a-z0-9]+)*$"
if ($SkillName -notmatch $pattern) {
    throw "SkillName must be kebab-case and match: $pattern"
}

$skillDir = Join-Path $RepoRoot $SkillName
if (Test-Path -LiteralPath $skillDir) {
    throw "Skill directory already exists: $skillDir"
}

$skillTemplate = Join-Path $RepoRoot "templates/SKILL.md"
$changelogTemplate = Join-Path $RepoRoot "templates/CHANGELOG.md"
if (-not (Test-Path -LiteralPath $skillTemplate)) {
    throw "Missing template: $skillTemplate"
}
if (-not (Test-Path -LiteralPath $changelogTemplate)) {
    throw "Missing template: $changelogTemplate"
}

New-Item -ItemType Directory -Path $skillDir | Out-Null
foreach ($sub in @("references", "scripts", "assets")) {
    $subDir = Join-Path $skillDir $sub
    New-Item -ItemType Directory -Path $subDir | Out-Null
    New-Item -ItemType File -Path (Join-Path $subDir ".gitkeep") | Out-Null
}

$date = Get-Date -Format "yyyy-MM-dd"
$skillContent = (Get-Content -LiteralPath $skillTemplate -Raw -Encoding UTF8).
    Replace("{{SKILL_NAME}}", $SkillName).
    Replace("{{DATE}}", $date)
$changelogContent = (Get-Content -LiteralPath $changelogTemplate -Raw -Encoding UTF8).
    Replace("{{SKILL_NAME}}", $SkillName).
    Replace("{{DATE}}", $date)

Set-Content -LiteralPath (Join-Path $skillDir "SKILL.md") -Value $skillContent -Encoding UTF8 -NoNewline
Set-Content -LiteralPath (Join-Path $skillDir "CHANGELOG.md") -Value $changelogContent -Encoding UTF8 -NoNewline

Write-Host "Created skill scaffold successfully." -ForegroundColor Green
Write-Host "Skill directory : $skillDir"
Write-Host "Files generated :"
Write-Host "  - $SkillName/SKILL.md"
Write-Host "  - $SkillName/CHANGELOG.md"
Write-Host "  - $SkillName/references/.gitkeep"
Write-Host "  - $SkillName/scripts/.gitkeep"
Write-Host "  - $SkillName/assets/.gitkeep"

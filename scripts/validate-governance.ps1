param(
    [Parameter(Mandatory = $false)]
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$errors = New-Object System.Collections.Generic.List[string]

function Add-ValidationError {
    param([string]$Message)
    $script:errors.Add($Message)
}

$requiredPaths = @(
    "README.md",
    "docs/skills-governance.md",
    "templates/SKILL.md",
    "templates/CHANGELOG.md",
    "scripts/new-skill.ps1",
    "scripts/new-skill.sh",
    "scripts/validate-governance.ps1",
    "scripts/validate-governance.sh"
)

foreach ($path in $requiredPaths) {
    if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot $path))) {
        Add-ValidationError "Missing required path: $path"
    }
}

$infraDirs = @(".git", ".github", "docs", "scripts", "templates")
$skillDirs = @(Get-ChildItem -LiteralPath $RepoRoot -Directory | Where-Object {
    $infraDirs -notcontains $_.Name -and -not $_.Name.StartsWith(".")
})

if ($skillDirs.Count -eq 0) {
    Add-ValidationError "No skill directory found at repository root."
}

$namePattern = "^[a-z0-9]+(-[a-z0-9]+)*$"
$versionPattern = "^## v\d+\.\d+\.\d+ - \d{4}-\d{2}-\d{2}$"
$placeholderPattern = "{{SKILL_NAME}}|{{DATE}}"

foreach ($dir in $skillDirs) {
    $skillName = $dir.Name
    $skillPath = $dir.FullName
    $skillMd = Join-Path $skillPath "SKILL.md"
    $changelog = Join-Path $skillPath "CHANGELOG.md"

    if ($skillName -notmatch $namePattern) {
        Add-ValidationError "Skill directory name is not kebab-case: $skillName"
    }

    if (-not (Test-Path -LiteralPath $skillMd)) {
        Add-ValidationError "Missing SKILL.md: $skillName/SKILL.md"
    }
    if (-not (Test-Path -LiteralPath $changelog)) {
        Add-ValidationError "Missing CHANGELOG.md: $skillName/CHANGELOG.md"
    }

    if (Test-Path -LiteralPath $skillMd) {
        $skillText = Get-Content -LiteralPath $skillMd -Raw -Encoding UTF8
        if ($skillText -match $placeholderPattern) {
            Add-ValidationError "Unresolved template placeholder found in $skillName/SKILL.md"
        }
    }

    if (Test-Path -LiteralPath $changelog) {
        $changelogText = Get-Content -LiteralPath $changelog -Raw -Encoding UTF8
        if ($changelogText -match $placeholderPattern) {
            Add-ValidationError "Unresolved template placeholder found in $skillName/CHANGELOG.md"
        }
        $hasVersionHeader = Select-String -Path $changelog -Pattern $versionPattern -SimpleMatch:$false -Quiet
        if (-not $hasVersionHeader) {
            Add-ValidationError "No valid version heading in $skillName/CHANGELOG.md. Expected: ## vX.Y.Z - YYYY-MM-DD"
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Governance validation failed:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Governance validation passed." -ForegroundColor Green
Write-Host "Validated skills: $($skillDirs.Count)"

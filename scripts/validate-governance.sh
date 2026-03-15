#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
errors=0

add_error() {
  echo "  - $1"
  errors=$((errors + 1))
}

required_paths=(
  "README.md"
  "docs/skills-governance.md"
  "templates/SKILL.md"
  "templates/CHANGELOG.md"
  "scripts/new-skill.ps1"
  "scripts/new-skill.sh"
  "scripts/validate-governance.ps1"
  "scripts/validate-governance.sh"
)

for path in "${required_paths[@]}"; do
  if [[ ! -e "$repo_root/$path" ]]; then
    add_error "Missing required path: $path"
  fi
done

skill_count=0
name_pattern='^[a-z0-9]+(-[a-z0-9]+)*$'
version_pattern='^## v[0-9]+\.[0-9]+\.[0-9]+ - [0-9]{4}-[0-9]{2}-[0-9]{2}$'

while IFS= read -r -d '' dir; do
  name="$(basename "$dir")"
  case "$name" in
    .git|.github|docs|scripts|templates) continue ;;
    .*) continue ;;
  esac

  skill_count=$((skill_count + 1))
  skill_md="$dir/SKILL.md"
  changelog="$dir/CHANGELOG.md"

  if [[ ! "$name" =~ $name_pattern ]]; then
    add_error "Skill directory name is not kebab-case: $name"
  fi
  if [[ ! -f "$skill_md" ]]; then
    add_error "Missing SKILL.md: $name/SKILL.md"
  fi
  if [[ ! -f "$changelog" ]]; then
    add_error "Missing CHANGELOG.md: $name/CHANGELOG.md"
  fi

  if [[ -f "$skill_md" ]] && grep -Eq '{{SKILL_NAME}}|{{DATE}}' "$skill_md"; then
    add_error "Unresolved template placeholder found in $name/SKILL.md"
  fi
  if [[ -f "$changelog" ]] && grep -Eq '{{SKILL_NAME}}|{{DATE}}' "$changelog"; then
    add_error "Unresolved template placeholder found in $name/CHANGELOG.md"
  fi
  if [[ -f "$changelog" ]] && ! grep -Eq "$version_pattern" "$changelog"; then
    add_error "No valid version heading in $name/CHANGELOG.md. Expected: ## vX.Y.Z - YYYY-MM-DD"
  fi
done < <(find "$repo_root" -mindepth 1 -maxdepth 1 -type d -print0)

if [[ "$skill_count" -eq 0 ]]; then
  add_error "No skill directory found at repository root."
fi

if [[ "$errors" -gt 0 ]]; then
  echo "Governance validation failed:"
  exit 1
fi

echo "Governance validation passed."
echo "Validated skills: $skill_count"

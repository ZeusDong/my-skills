#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <skill_name> [repo_root]"
  exit 1
fi

skill_name="$1"
repo_root="${2:-$(cd "$(dirname "$0")/.." && pwd)}"
pattern='^[a-z0-9]+(-[a-z0-9]+)*$'

if [[ ! "$skill_name" =~ $pattern ]]; then
  echo "Error: skill_name must be kebab-case and match: $pattern"
  exit 1
fi

skill_dir="$repo_root/$skill_name"
if [[ -e "$skill_dir" ]]; then
  echo "Error: skill directory already exists: $skill_dir"
  exit 1
fi

skill_template="$repo_root/templates/SKILL.md"
changelog_template="$repo_root/templates/CHANGELOG.md"
if [[ ! -f "$skill_template" ]]; then
  echo "Error: missing template: $skill_template"
  exit 1
fi
if [[ ! -f "$changelog_template" ]]; then
  echo "Error: missing template: $changelog_template"
  exit 1
fi

mkdir -p "$skill_dir/references" "$skill_dir/scripts" "$skill_dir/assets"
touch "$skill_dir/references/.gitkeep" "$skill_dir/scripts/.gitkeep" "$skill_dir/assets/.gitkeep"

date_value="$(date +%F)"
sed -e "s/{{SKILL_NAME}}/$skill_name/g" -e "s/{{DATE}}/$date_value/g" "$skill_template" > "$skill_dir/SKILL.md"
sed -e "s/{{SKILL_NAME}}/$skill_name/g" -e "s/{{DATE}}/$date_value/g" "$changelog_template" > "$skill_dir/CHANGELOG.md"

echo "Created skill scaffold successfully."
echo "Skill directory : $skill_dir"
echo "Files generated :"
echo "  - $skill_name/SKILL.md"
echo "  - $skill_name/CHANGELOG.md"
echo "  - $skill_name/references/.gitkeep"
echo "  - $skill_name/scripts/.gitkeep"
echo "  - $skill_name/assets/.gitkeep"

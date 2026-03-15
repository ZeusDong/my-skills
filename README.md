# my-skills

平台为通用 Skill 的集中仓库。
你可以只拉取单个 Skill 使用，也可以按统一治理流程创建、更新和发布 Skill。

## 一分钟上手
### 前置要求
- Git `>= 2.25`（需要支持 `sparse-checkout`）
- 任一终端：Windows CMD、PowerShell、macOS/Linux Bash
- 可访问目标仓库地址（官方仓库、fork 或镜像均可）

### 30 秒拉取一个 Skill（PowerShell 示例）
```powershell
$Skill = "openclaw-troubleshooting"
$Repo = "https://github.com/ZeusDong/my-skills.git"
$Tmp = "_tmp_skill"

git clone --depth 1 --filter=blob:none --sparse $Repo $Tmp
git -C $Tmp sparse-checkout set $Skill
Move-Item "$Tmp/$Skill" "./$Skill"
Remove-Item $Tmp -Recurse -Force
```

其他终端命令见 [获取单个 Skill](#获取单个-skill)。

## 快速导航
| 入口 | 适用人群 | 说明 |
|---|---|---|
| [获取单个 Skill](#获取单个-skill) | 使用者 | 只下载你需要的 Skill |
| [给 LLM 的最短指令](#给-llm-的最短指令) | 使用者 | 用 `GOV_RUN` 直接驱动流程 |
| [贡献者流程](#贡献者流程) | 贡献者 | 创建、校验、提交、发布 |
| [规则速览](#规则速览) | 贡献者 | 提交规范、tag 规则、CI 约束 |
| [延伸文档](#延伸文档) | 全部 | 完整治理规则与细节 |

**目录（TOC）**
- [一分钟上手](#一分钟上手)
- [快速导航](#快速导航)
- [获取单个 Skill](#获取单个-skill)
- [给 LLM 的最短指令](#给-llm-的最短指令)
- [贡献者流程](#贡献者流程)
- [规则速览](#规则速览)
- [常见问题](#常见问题)
- [延伸文档](#延伸文档)

## 获取单个 Skill
### 参数说明（统一）
| 参数 | 说明 | 示例 |
|---|---|---|
| `<skill-name>` | 目标 Skill 目录名（`kebab-case`） | `openclaw-troubleshooting` |
| `<repo-url>` | 仓库地址（官方仓库或你的 fork/镜像） | `https://github.com/ZeusDong/my-skills.git` |
| `<tmp-dir>` | 临时目录名（当前目录不能同名） | `_tmp_skill` |

### Windows CMD
```bat
set SKILL=openclaw-troubleshooting
set REPO=https://github.com/ZeusDong/my-skills.git
set TMP=_tmp_skill

git clone --depth 1 --filter=blob:none --sparse %REPO% %TMP%
git -C %TMP% sparse-checkout set %SKILL%
move "%TMP%\%SKILL%" ".\%SKILL%"
rmdir /s /q %TMP%
```

### Windows PowerShell
```powershell
$Skill = "openclaw-troubleshooting"
$Repo = "https://github.com/ZeusDong/my-skills.git"
$Tmp = "_tmp_skill"

git clone --depth 1 --filter=blob:none --sparse $Repo $Tmp
git -C $Tmp sparse-checkout set $Skill
Move-Item "$Tmp/$Skill" "./$Skill"
Remove-Item $Tmp -Recurse -Force
```

### macOS / Linux Bash
```bash
SKILL="openclaw-troubleshooting"
REPO="https://github.com/ZeusDong/my-skills.git"
TMP="_tmp_skill"

git clone --depth 1 --filter=blob:none --sparse "$REPO" "$TMP"
git -C "$TMP" sparse-checkout set "$SKILL"
mv "$TMP/$SKILL" "./$SKILL"
rm -rf "$TMP"
```

注意：不同终端的语法不兼容，请只使用与你当前终端匹配的代码块。

## 给 LLM 的最短指令
```text
GOV_RUN task=<create|update|release> skill=<kebab-case> version=<vX.Y.Z|->
```

示例：
- `GOV_RUN task=create skill=my-new-skill version=-`
- `GOV_RUN task=update skill=openclaw-troubleshooting version=-`
- `GOV_RUN task=release skill=openclaw-troubleshooting version=v0.1.0`

## 贡献者流程
### 1) 创建 Skill
Windows（PowerShell）：
```powershell
.\scripts\new-skill.ps1 -SkillName my-new-skill
```

macOS / Linux（Shell）：
```bash
./scripts/new-skill.sh my-new-skill
```

### 2) 运行治理校验（提交前必做）
Windows（PowerShell）：
```powershell
.\scripts\validate-governance.ps1
```

macOS / Linux（Shell）：
```bash
./scripts/validate-governance.sh
```

### 3) 提交变更（Conventional Commits）
```bash
git add <skill-name>
git commit -m "feat(<skill-name>): <change-summary>"
git push
```

示例：
```bash
git add openclaw-troubleshooting
git commit -m "feat(openclaw-troubleshooting): add gateway timeout diagnostic"
git push
```

### 4) 发布 Skill（先更新并提交 CHANGELOG，再打 tag）
```bash
# 先更新 <skill-name>/CHANGELOG.md，并确保包含目标版本标题
git add <skill-name>/CHANGELOG.md <skill-name>
git commit -m "chore(<skill-name>): release vX.Y.Z"
git push

git tag skill/<skill-name>/vX.Y.Z
git push origin skill/<skill-name>/vX.Y.Z
```

示例：
```bash
git add openclaw-troubleshooting/CHANGELOG.md openclaw-troubleshooting
git commit -m "chore(openclaw-troubleshooting): release v0.1.0"
git push

git tag skill/openclaw-troubleshooting/v0.1.0
git push origin skill/openclaw-troubleshooting/v0.1.0
```

## 规则速览
- 提交信息必须采用 Conventional Commits，且 `scope` 必须等于 Skill 名。
- Skill 目录名必须为 `kebab-case`。
- 每个 Skill 必须包含 `SKILL.md` 与 `CHANGELOG.md`。
- 发布 tag 固定为 `skill/<skill-name>/vX.Y.Z`。
- `CHANGELOG.md` 版本标题格式为 `## vX.Y.Z - YYYY-MM-DD`。
- 提交前必须通过 `scripts/validate-governance.ps1` 或 `scripts/validate-governance.sh`。
- CI 在 `.github/workflows/skills-governance.yml` 中会执行相同治理校验。

## 常见问题
### 1) 命令报错：`sparse-checkout` 不存在
请确认 Git 版本是否满足前置要求（建议 `>= 2.25`）。

### 2) 提示临时目录已存在
把 `<tmp-dir>`（例如 `_tmp_skill`）改为当前目录下不存在的名字。

### 3) 我用的是 fork 或镜像仓库
把命令中的 `<repo-url>` 替换为你的仓库地址即可，其他步骤不变。

### 4) 为什么命令复制后不能运行
常见原因是跨终端混用语法（例如把 Bash 命令放到 PowerShell 运行）。请按当前终端选择对应代码块。

## 延伸文档
- 完整治理规则：`docs/skills-governance.md`
- 建议在每次提交前都执行：`scripts/validate-governance.*`

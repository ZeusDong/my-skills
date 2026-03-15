# Skills Governance（my-skills）

## 0. 给 LLM 的固定指令（短指令优先）
### 0.1 最短指令（推荐）
以后你只需要给 LLM 这一行：

```text
GOV_RUN task=<create|update|release> skill=<kebab-case> version=<vX.Y.Z|-> 
```

示例：
- `GOV_RUN task=create skill=my-new-skill version=-`
- `GOV_RUN task=update skill=openclaw-troubleshooting version=-`
- `GOV_RUN task=release skill=openclaw-troubleshooting version=v0.1.0`

解释：
- `task=create`：创建新 skill（必须走 `scripts/new-skill.*`）
- `task=update`：只更新指定 skill（提交前必须跑 `scripts/validate-governance.*`）
- `task=release`：在 update 基础上额外打 tag `skill/<skill>/vX.Y.Z`

### 0.2 完整模板（仅在模型不稳定时使用）
如果某个模型不按短指令执行，再使用下面完整模板：

```text
你现在在仓库 d:\cydprojects\skills 中工作。
必须严格遵守 docs/skills-governance.md，不允许跳过脚本流程。

任务类型：<create|update|release>
skill_name：<kebab-case，例如 openclaw-troubleshooting>
version：<仅 release 时填写，例如 v0.1.0；否则留空>

执行规则：
1) 只改与 skill_name 相关的文件（以及必要的治理文件）。
2) create 必须使用 scripts/new-skill.ps1（或 .sh）。
3) 提交前必须运行 scripts/validate-governance.ps1（或 .sh）并通过。
4) commit message 必须是 Conventional Commits，且 scope=skill_name。
5) release 时必须创建并推送 tag：skill/<skill_name>/<version>。
6) 回复时必须给出：修改文件清单、校验结果、commit hash、tag（若有）。
```

## 1. 目标
本规范用于让不同 LLM 或人工协作者在同一仓库内执行一致操作，核心是四层约束：
- 文档约束：规则写清楚
- 模板约束：输出骨架固定
- 脚本约束：关键动作走统一入口
- 校验约束：提交前与 CI 自动检查

## 2. 目录与命名规则
### 2.1 根目录规则
- 每个 skill 必须位于仓库根目录：`<skill-name>/`
- skill 目录名必须使用 `kebab-case`，正则：`^[a-z0-9]+(-[a-z0-9]+)*$`

### 2.2 必需文件
- 每个 skill 必须包含 `SKILL.md` 与 `CHANGELOG.md`

### 2.3 可选目录
- `references/`
- `scripts/`
- `assets/`

## 3. 标准化入口（必须优先使用）
### 3.1 创建 skill
- Windows：`scripts/new-skill.ps1`
- macOS/Linux：`scripts/new-skill.sh`
- 禁止手工跳过模板直接创建首版文件。

### 3.2 单 skill 快速获取
- 使用 README 中的手工命令（CMD / PowerShell / Bash）按需拉取单个 skill。

### 3.3 规则校验
- Windows：`scripts/validate-governance.ps1`
- macOS/Linux：`scripts/validate-governance.sh`
- 每次提交前必须运行一次；CI 会重复执行。

## 4. 版本与发布规则
### 4.1 版本号
- 使用语义化版本：`vMAJOR.MINOR.PATCH`

### 4.2 Tag 规则
- 固定格式：`skill/<skill-name>/vX.Y.Z`
- 示例：`skill/openclaw-troubleshooting/v0.1.0`

### 4.3 CHANGELOG 规则
- 每次发布前必须更新该 skill 的 `CHANGELOG.md`
- 版本标题格式：`## vX.Y.Z - YYYY-MM-DD`

## 5. 提交规范
- 必须使用 Conventional Commits。
- scope 必须等于 skill 目录名。
- 示例：`feat(openclaw-troubleshooting): add command ladder fallback`
- 示例：`fix(openclaw-troubleshooting): handle empty gateway probe output`
- 示例：`docs(openclaw-troubleshooting): clarify security incident escalation`

## 6. 自动校验内容
`validate-governance` 脚本会校验：
- 仓库基础文件是否存在（README、治理文档、模板、关键脚本）
- skill 目录名是否满足 kebab-case
- 每个 skill 是否同时存在 `SKILL.md` 与 `CHANGELOG.md`
- `CHANGELOG.md` 是否存在至少一个合法版本标题
- 模板占位符是否被错误保留在生成结果中

## 7. CI 规则
- GitHub Actions 工作流：`.github/workflows/skills-governance.yml`
- 在 `push` 和 `pull_request` 时自动运行 `scripts/validate-governance.sh`
- 校验失败即阻断合并

## 8. 兼容与弃用
- 不允许直接移除已发布能力；先在 `CHANGELOG.md` 标记 `Deprecated`
- 至少经过一个 MINOR 版本后再删除
- 涉及行为变化必须在 `CHANGELOG.md` 写迁移说明

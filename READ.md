# my-skills 技能仓库说明

## Executive Summary
- 本仓库用于沉淀和维护平台无关的通用技能（以 `SKILL.md` 为核心说明），不限定于任何单一平台。
- 本地仓库已初始化完成：当前分支为 `main`，并存在初始化空提交。
- 远程仓库地址已确定为 `git@github.com:ZeusDong/my-skills.git`，后续可直接绑定并推送。

## 仓库定位
该仓库用于统一管理个人技能资产，目标是形成可复用、可版本化、可持续迭代的技能集合，支持在不同项目中快速复用。

## 当前状态
| 项目 | 状态 |
|---|---|
| 本地 Git 仓库 | 已初始化 |
| 默认分支 | `main` |
| 初始化提交 | `chore: initialize repository` |
| 远端配置 | 未绑定（待执行） |
| 远程地址 | `git@github.com:ZeusDong/my-skills.git` |

## 建议目录约定
```text
my-skills/
  skills/
    <skill-name>/
      SKILL.md
      references/        # 可选
      scripts/           # 可选
      assets/            # 可选
  READ.md
```

## 首次绑定并推送到 GitHub
```bash
git remote add origin git@github.com:ZeusDong/my-skills.git
git push -u origin main
```

## 日常更新流程
```bash
git add .
git commit -m "feat: add/update <skill-name>"
git push
```

## 技能文档最小规范
- 每个技能目录必须包含 `SKILL.md`。
- `SKILL.md` 需明确：触发条件、输入输出、执行步骤、边界与回退策略。
- 若技能依赖模板或脚本，优先放入 `assets/`、`scripts/` 并在 `SKILL.md` 中引用相对路径。

## Open Questions
- 是否需要为仓库补充 `README.md`（面向 GitHub 首页展示）与 `LICENSE`？
- 是否需要约定统一的技能命名规则（例如 `kebab-case`）？

## Next Steps
- [ ] Owner: ZeusDong - 绑定远端并执行首次推送 - Due: 本周内
- [ ] Owner: ZeusDong - 创建第一个技能目录与 `SKILL.md` - Due: 本周内

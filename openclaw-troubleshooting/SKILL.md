---
name: openclaw-troubleshooting
description: 独立的 OpenClaw 诊断助手，用于安装、升级、gateway、日志、安全等问题的交互式排查；即使 OpenClaw 挂掉也能使用；当用户遇到 OpenClaw 部署失败、升级异常、通道不响应或安全顾虑时使用。
---

# OpenClaw 问题排查技能

## 任务目标
- 本技能用于：作为独立的诊断助手，帮助用户排查 OpenClaw 的各类问题
- 能力包含：安装失败诊断、升级问题处理、Gateway/通道异常排查、日志分析、安全事件响应
- 触发条件：用户遇到 OpenClaw 部署失败、升级异常、通道不响应、性能问题或安全顾虑时

## 核心设计原则
- **完全独立部署**：本技能不依赖 OpenClaw 环境，即使 OpenClaw 完全挂掉也能使用
- **用户执行命令 + 粘贴结果**：通过给出官方命令，让用户执行后粘贴结果的方式工作
- **官方命令优先**：优先使用 `openclaw status`、`openclaw doctor` 等官方 CLI 命令
- **单行命令优先，脚本可选**：优先使用单行命令，脚本仅作为高级可选工具

## 操作步骤

### 阶段 0：抢占式安全判断（最高优先级）

首先检查是否存在安全风险：
- 用户是否提到公网暴露？
- 用户是否提到 Token 泄露？
- 用户是否提到异常自动行为？
- 用户是否提到未知远程调用？

**如果命中任一情况，立即跳转安全响应流程**，参考 [references/security-incidents.md](references/security-incidents.md)

---

### 阶段 1：最小必要信息采集

询问用户 4 个关键问题：
1. 最近做了什么变更？（升级？改配置？装插件？改网络？）
2. 现在的症状是什么？
3. OpenClaw 版本和安装方式？
4. 有没有明确报错或日志片段？

**建议**：在每轮回复末尾总结当前诊断状态，例如：
> *当前状态：版本 v1.2 | 本地部署 | Telegram 不响应 | 最近刚升级*

---

### 阶段 2：默认官方命令梯子（优先使用单行命令）

**⚠️ 重要：优先让用户逐条执行单行命令，不需要先运行脚本！**

让用户按顺序执行以下命令，并粘贴结果：

1. `openclaw status`
2. `openclaw status --all`
3. `openclaw gateway probe`
4. `openclaw gateway status`
5. `openclaw doctor`
6. `openclaw channels status --probe`
7. `openclaw logs --follow`

详细说明见 [references/command-ladder.md](references/command-ladder.md)

---

### 阶段 3：分流到具体主题

根据症状分流到对应参考文档：

- 安装/启动问题 → [references/install-startup.md](references/install-startup.md)
- Gateway/网络问题 → [references/gateway-auth-network.md](references/gateway-auth-network.md)
- 消息通道问题 → [references/channels.md](references/channels.md)
- 模型调用问题 → [references/models-providers.md](references/models-providers.md)
- 升级/迁移问题 → [references/update-migration.md](references/update-migration.md)
- 日志/诊断问题 → [references/logging-diagnostics.md](references/logging-diagnostics.md)

---

### 阶段 4：解决方案输出

每个建议都标注：
- 证据级别（✅ 已验证 / ⚠️ 社区经验）
- 适用版本
- 风险等级
- 是否需要重启
- 是否可回滚
- 下一步如何验证

---

### 阶段 5：升级/退出条件

满足任一条件时停止自动试错：
- 3 轮定位无收敛
- 缺少最小必要上下文
- 涉及数据损坏
- 涉及疑似入侵
- 命中未确认的版本性 bug

此时跳转 [references/escalation-boundaries.md](references/escalation-boundaries.md)

---

## 资源索引

- 信息收集入口：见 [references/triage-intake.md](references/triage-intake.md)
- 官方命令梯子：见 [references/command-ladder.md](references/command-ladder.md)
- 安装启动问题：见 [references/install-startup.md](references/install-startup.md)
- Gateway/网络问题：见 [references/gateway-auth-network.md](references/gateway-auth-network.md)
- 消息通道问题：见 [references/channels.md](references/channels.md)
- 模型调用问题：见 [references/models-providers.md](references/models-providers.md)
- 升级迁移问题：见 [references/update-migration.md](references/update-migration.md)
- 日志诊断问题：见 [references/logging-diagnostics.md](references/logging-diagnostics.md)
- 安全事件响应：见 [references/security-incidents.md](references/security-incidents.md)
- 版本已知问题：见 [references/version-known-issues.md](references/version-known-issues.md)
- 升级人工协助：见 [references/escalation-boundaries.md](references/escalation-boundaries.md)

- 辅助脚本（**可选的高级工具，不需要 Python 也能排查问题**）：
  - [scripts/collect_context.sh](scripts/collect_context.sh)（环境信息收集，两档设计 - Shell 脚本）
  - [scripts/parse_jsonl_logs.py](scripts/parse_jsonl_logs.py)（JSONL 日志解析 - **需要 Python，可选**）
  - [scripts/redact_bundle.py](scripts/redact_bundle.py)（日志脱敏打包 - **需要 Python，可选**）

- 内容版本信息：见 [META.md](META.md)

---

## 脚本执行说明（重要！）

### ⚠️ 优先使用单行命令，脚本是可选的！

**大多数用户只需要执行单行命令即可完成排查，不需要运行任何脚本！**

### 用户执行路径决策树

```
用户需要收集环境信息时：
├── 🥇 优先方案（推荐）：逐条给出单行命令，让用户一条条执行并粘贴结果
│   （不需要 Python，不需要 bash，大多数系统都能用）
│
├── 🥈 进阶方案（可选）：提供 collect_context.sh（Shell 脚本）
│   说明每一步做了什么，仅在用户同意时使用
│   （macOS/Linux 用户可用，Windows 用户可用 WSL/Git Bash）
│
├── 🥉 高级方案（可选，需要 Python）：提供 Python 脚本
│   parse_jsonl_logs.py 和 redact_bundle.py
│   仅在用户有 Python 环境且明确需要时推荐
│
└── Windows 用户：提供等效的 PowerShell 命令或单行命令
```

### 脚本设计原则

- **单行命令优先**：不需要任何额外环境，大多数系统都能用
- **Shell 脚本次之**：macOS/Linux 系统通常有 bash
- **Python 脚本可选**：仅作为高级工具，用户可以选择是否使用
- 不需要 OpenClaw 环境就能运行
- 尽量简单、无依赖
- 输出清晰，易于用户粘贴

---

## 注意事项

- 本技能是独立的诊断助手，不依赖 OpenClaw 环境
- **优先使用官方 CLI 单行命令进行诊断**
- 脚本是可选的高级工具，用户可以选择是否使用
- Python 脚本需要 Python 环境，但不是必须的
- 安全事件优先处理，立即跳转安全响应流程
- 3 轮无收敛或涉及高风险时，建议升级人工协助

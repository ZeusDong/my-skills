# 升级人工协助与边界规则

## 升级条件

满足任一条件时停止自动试错：
- 3 轮定位无收敛
- 缺少最小必要上下文
- 涉及数据损坏
- 涉及疑似入侵
- 命中未确认的版本性 bug

---

## 边界说明

### 本技能处理：
- 安装失败
- 升级失败
- Gateway / Dashboard / 认证 / 日志 / 诊断 / 安全审计
- 常见通道 / Provider 故障

### 本技能不处理：
- 二次开发调试
- 非官方插件源码分析
- 未验证第三方发行版
- 深度入侵取证

---

## Issue 报告模板

```markdown
## Issue 报告模板

### 环境信息
- OpenClaw 版本：
- 操作系统：
- 安装方式：

### 问题描述
- 症状：
- 首次出现时间：
- 最近变更：

### 已尝试的排查步骤
1. ...
2. ...

### 相关日志（已脱敏）
```

---

## 升级路径

- 官方文档：[https://docs.openclaw.ai/](https://docs.openclaw.ai/)
- 官方 Troubleshooting：[https://docs.openclaw.ai/gateway/troubleshooting](https://docs.openclaw.ai/gateway/troubleshooting)
- 官方 Help：[https://docs.openclaw.ai/help](https://docs.openclaw.ai/help)
- 社区论坛：[待确认]
- 内部运维团队（如适用）

---

## 相关官方文档链接

- [Quick start](https://docs.openclaw.ai/start/quickstart)
- [Troubleshooting](https://docs.openclaw.ai/gateway/troubleshooting)
- [Doctor](https://docs.openclaw.ai/gateway/doctor)
- [Security](https://docs.openclaw.ai/gateway/security)
- [Logging](https://docs.openclaw.ai/logging)
- [Help / FAQ](https://docs.openclaw.ai/help)

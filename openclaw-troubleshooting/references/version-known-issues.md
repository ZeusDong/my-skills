# 版本已知问题

## 说明

本文档合并了版本兼容性矩阵和已知问题索引。

---

## 已知问题（来自官方文档）

### 升级后常见问题

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#if-you-upgraded-and-something-suddenly-broke

| 问题类型 | 受影响版本 | 症状 | 首选命令 | 是否优先升级 | 解决方案 | 证据级别 |
|---------|-----------|------|---------|------------|---------|---------|
| Auth and URL override behavior changed | 升级后 | gateway connect failed, unauthorized | `openclaw gateway status`, `openclaw config get gateway.mode` | 否 | 检查 gateway.mode，检查 URL 目标 | ✅ 已验证 |
| Bind and auth guardrails are stricter | 升级后 | refusing to bind gateway ... without auth, RPC probe failed | `openclaw config get gateway.bind`, `openclaw gateway status` | 否 | 配置 auth，检查新旧键名 | ✅ 已验证 |
| Pairing and device identity state changed | 升级后 | device identity required, pairing required | `openclaw devices list`, `openclaw doctor` | 否 | 批准待处理请求，重新安装服务 | ✅ 已验证 |

---

### Anthropic 429 问题

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#anthropic-429-extra-usage-required-for-long-context

| 问题类型 | 受影响版本 | 症状 | 首选命令 | 是否优先升级 | 解决方案 | 证据级别 |
|---------|-----------|------|---------|------------|---------|---------|
| Anthropic 429 long context | 使用 1M context 时 | HTTP 429: rate_limit_error | `openclaw logs --follow`, `openclaw models status` | 视情况 | 禁用 context1m，或启用 Extra Usage | ✅ 已验证 |

---

### Gateway 服务不运行

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#gateway-service-not-running

| 问题类型 | 受影响版本 | 症状 | 首选命令 | 是否优先升级 | 解决方案 | 证据级别 |
|---------|-----------|------|---------|------------|---------|---------|
| Gateway start blocked | 配置问题 | Gateway start blocked: set gateway.mode=local | `openclaw gateway status`, `openclaw doctor` | 否 | 设置 gateway.mode="local"，或运行 `openclaw configure` | ✅ 已验证 |
| Port conflict | 通用 | another gateway instance is already listening, EADDRINUSE | `openclaw gateway status --deep` | 否 | 检查端口冲突，停止其他实例 | ✅ 已验证 |
| Bind without auth | 配置问题 | refusing to bind gateway ... without auth | `openclaw config get gateway.bind`, `openclaw config get gateway.auth.token` | 否 | 配置 auth token，或使用 loopback bind | ✅ 已验证 |

---

### Dashboard/Control UI 连接问题

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#dashboard-control-ui-connectivity

| 问题类型 | 受影响版本 | 症状 | 首选命令 | 是否优先升级 | 解决方案 | 证据级别 |
|---------|-----------|------|---------|------------|---------|---------|
| Device identity required | 配置问题 | device identity required | `openclaw gateway status`, `openclaw logs --follow` | 否 | 检查安全上下文和 device auth | ✅ 已验证 |
| Auth token mismatch | 认证问题 | AUTH_TOKEN_MISMATCH | `openclaw config get gateway.auth.token` | 否 | 重试或刷新 token | ✅ 已验证 |
| Device nonce/signature error | Device auth v2 | device nonce required, device signature invalid | `openclaw --version`, `openclaw doctor` | 视情况 | 更新客户端，验证挑战流程 | ✅ 已验证 |

---

## 问题条目模板

```markdown
## [问题标题]

- 受影响版本：v1.0 - v1.2
- 安装方式：npm / git / installer
- 症状：[描述]
- 首选命令：`openclaw xxx`
- 是否优先升级：是 / 否
- 解决方案：[步骤]
- 证据级别：✅ 已验证 / ⚠️ 社区经验
```

---

## 待补充内容

- [ ] 从 GitHub Issues 收集更多真实问题
- [ ] 补充完整的版本兼容性矩阵
- [ ] 补充更多已知 workaround
- [ ] 实际安装后补充更多真实问题数据

---

## 相关文档

- [/gateway/troubleshooting](https://docs.openclaw.ai/gateway/troubleshooting)
- [/help/troubleshooting](https://docs.openclaw.ai/help/troubleshooting)

# 模型 Provider 问题

## Anthropic 429 extra usage required for long context

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#anthropic-429-extra-usage-required-for-long-context

当日志/错误包含以下内容时使用此诊断：
`HTTP 429: rate_limit_error: Extra usage is required for long context requests`

### 诊断命令
```bash
openclaw logs --follow
openclaw models status
openclaw config get agents.defaults.models
```

### 检查要点

| 检查项 | 说明 |
|--------|------|
| Selected Anthropic Opus/Sonnet model has `params.context1m: true` | 模型是否启用了 1M context |
| Current Anthropic credential is not eligible for long-context usage | 凭证是否有资格使用长上下文 |
| Requests fail only on long sessions/model runs that need the 1M beta path | 是否仅在需要 1M beta 路径的长会话/模型运行时失败 |

### 修复选项

1. 为该模型禁用 `context1m`，回退到正常上下文窗口
2. 使用带计费的 Anthropic API key，或在订阅账户上启用 Anthropic Extra Usage
3. 配置 fallback models，以便在 Anthropic 长上下文请求被拒绝时继续运行

### 相关文档
- [/providers/anthropic](https://docs.openclaw.ai/providers/anthropic)
- [/reference/token-use](https://docs.openclaw.ai/reference/token-use)
- [/help/faq#why-am-i-seeing-http-429-ratelimiterror-from-anthropic](https://docs.openclaw.ai/help/faq#why-am-i-seeing-http-429-ratelimiterror-from-anthropic)

---

## 模型 auth health（OAuth expiry）

来自官方文档：https://docs.openclaw.ai/gateway/doctor#5-model-auth-health-oauth-expiry

Doctor 检查 auth store 中的 OAuth profiles，在 token 过期/即将过期时发出警告，并在安全时可以刷新它们。

### 如果 Anthropic Claude Code profile 过期
建议运行：
```bash
claude setup-token
```
或粘贴一个 setup-token。

### 刷新提示
刷新提示仅在交互式运行时（TTY）出现；`--non-interactive` 跳过刷新尝试。

### Doctor 也报告暂时不可用的 auth profiles
原因包括：
- 短期冷却（rate limits/timeouts/auth failures）
- 长期禁用（billing/credit failures）

---

## 常见模型/Provider 问题

### API key 错误
- 检查 API key 是否正确配置
- 检查 API key 是否有效且未过期
- 检查 API key 是否已被撤销

### Provider 配置错误
- 检查 provider 配置是否正确
- 检查 provider 是否在允许列表中
- 检查 provider 连接性

### 401 / 429 / Quota / Auth-profile 问题
- `401 Unauthorized`：认证失败，检查 API key/token
- `429 Too Many Requests`：速率限制，等待或增加 quota
- `Quota exceeded`：配额超限，升级配额或等待重置
- `Auth-profile cooldown/disabled`：auth profile 冷却或禁用，等待或检查配置

### 相关文档
- [/providers/](https://docs.openclaw.ai/providers/)
- [/help/faq](https://docs.openclaw.ai/help/faq)

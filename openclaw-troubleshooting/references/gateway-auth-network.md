# Gateway / 认证 / 网络问题

## Dashboard Control UI 连接问题

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#dashboard-control-ui-connectivity

### 诊断命令
```bash
openclaw gateway status
openclaw status
openclaw logs --follow
openclaw doctor
openclaw gateway status --json
```

### 检查要点

| 检查项 | 说明 |
|--------|------|
| Correct probe URL and dashboard URL | 验证 URL 是否正确 |
| Auth mode/token mismatch | 客户端和 gateway 之间的认证模式/token 不匹配 |
| HTTP usage where device identity is required | 需要 device identity 的地方使用了 HTTP |

### 常见错误签名

| 错误签名 | 含义 | 推荐操作 |
|----------|------|---------|
| `device identity required` | 非安全上下文或缺少 device auth | 检查安全上下文和 device auth |
| `device nonce required` / `device nonce mismatch` | 客户端未完成基于挑战的 device auth 流程 | 客户端需要等待 `connect.challenge` 并完成流程 |
| `device signature invalid` / `device signature expired` | 客户端为当前握手签名了错误的 payload（或时间戳过期） | 验证客户端签名流程 |
| `AUTH_TOKEN_MISMATCH` 且 `canRetryWithDeviceToken=true` | 客户端可以使用缓存的 device token 进行一次可信重试 | 允许一次重试 |
| 重试后仍重复 `unauthorized` | 共享 token/device token 漂移 | 刷新 token 配置，必要时重新批准/轮换 device token |
| `gateway connect failed:` | 错误的 host/port/url 目标 | 检查 URL 目标 |

### Auth detail codes quick map

使用失败的 `connect` 响应中的 `error.details.code` 来选择下一步操作：

| Detail code | 含义 | 推荐操作 |
|-------------|------|---------|
| `AUTH_TOKEN_MISSING` | 客户端未发送必需的共享 token | 在客户端粘贴/设置 token 并重试。对于 dashboard 路径：`openclaw config get gateway.auth.token` 然后粘贴到 Control UI 设置 |
| `AUTH_TOKEN_MISMATCH` | 共享 token 与 gateway auth token 不匹配 | 如果 `canRetryWithDeviceToken=true`，允许一次可信重试。如果仍然失败，运行 [token drift recovery checklist](https://docs.openclaw.ai/cli/devices#token-drift-recovery-checklist) |
| `AUTH_DEVICE_TOKEN_MISMATCH` | 缓存的 per-device token 过期或被撤销 | 使用 [devices CLI](https://docs.openclaw.ai/cli/devices) 轮换/重新批准 device token，然后重新连接 |
| `PAIRING_REQUIRED` | Device identity 已知但未批准此角色 | 批准待处理请求：`openclaw devices list` 然后 `openclaw devices approve <requestId>` |

### Device auth v2 迁移检查
```bash
openclaw --version
openclaw doctor
openclaw gateway status
```

如果日志显示 nonce/signature 错误，更新连接的客户端并验证它：
1. 等待 `connect.challenge`
2. 签署与挑战绑定的 payload
3. 发送 `connect.params.device.nonce` 并使用相同的挑战 nonce

### 相关文档
- [/web/control-ui](https://docs.openclaw.ai/web/control-ui)
- [/gateway/authentication](https://docs.openclaw.ai/gateway/authentication)
- [/gateway/remote](https://docs.openclaw.ai/gateway/remote)
- [/cli/devices](https://docs.openclaw.ai/cli/devices)

# 安装启动问题

## 官方 Quick Start

来自官方文档：https://docs.openclaw.ai/

### 1. 安装 OpenClaw
```bash
npm install -g openclaw@latest
```

### 2. 配置并安装服务
```bash
openclaw onboard --install-daemon
```

### 3. 登录通道并启动 Gateway
```bash
openclaw channels login
openclaw gateway --port 18789
```

### Dashboard 默认地址
- Local default: http://127.0.0.1:18789/

---

## Gateway 服务不运行

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#gateway-service-not-running

### 诊断命令
```bash
openclaw gateway status
openclaw status
openclaw logs --follow
openclaw doctor
openclaw gateway status --deep
```

### 检查要点

| 检查项 | 预期结果 | 常见问题 |
|--------|---------|---------|
| `Runtime: stopped` | 应该显示 `running` | 服务未启动 |
| Config (cli) vs Config (service) | 应该一致 | 服务配置不匹配 |
| Port/listener | 应该无冲突 | 端口冲突 |

### 常见错误签名

- `Gateway start blocked: set gateway.mode=local` → local gateway mode 未启用
  - 修复：设置 `gateway.mode="local"` 或运行 `openclaw configure`
- `refusing to bind gateway ... without auth` → 非 loopback 绑定但没有 token/password
- `another gateway instance is already listening` / `EADDRINUSE` → 端口冲突

### 相关文档
- [/gateway/background-process](https://docs.openclaw.ai/gateway/background-process)
- [/gateway/configuration](https://docs.openclaw.ai/gateway/configuration)
- [/gateway/doctor](https://docs.openclaw.ai/gateway/doctor)

---

## 如果升级后突然出问题

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#if-you-upgraded-and-something-suddenly-broke

大多数升级后的问题是配置漂移或更严格的默认值现在被强制执行。

### 1) Auth and URL override behavior changed
```bash
openclaw gateway status
openclaw config get gateway.mode
openclaw config get gateway.remote.url
openclaw config get gateway.auth.mode
```

检查：
- 如果 `gateway.mode=remote`，CLI 调用可能指向远程，而本地服务正常
- 显式 `--url` 调用不会回退到存储的凭证

常见错误签名：
- `gateway connect failed:` → 错误的 URL 目标
- `unauthorized` → 端点可达但认证错误

### 2) Bind and auth guardrails are stricter
```bash
openclaw config get gateway.bind
openclaw config get gateway.auth.token
openclaw gateway status
openclaw logs --follow
```

检查：
- 非 loopback 绑定（`lan`, `tailnet`, `custom`）需要配置 auth
- 旧键如 `gateway.token` 不会替换 `gateway.auth.token`

常见错误签名：
- `refusing to bind gateway ... without auth` → bind+auth 不匹配
- `RPC probe: failed` 而 runtime 正在运行 → gateway 活着但用当前 auth/url 无法访问

### 3) Pairing and device identity state changed
```bash
openclaw devices list
openclaw pairing list --channel <channel> [--account <id>]
openclaw logs --follow
openclaw doctor
```

检查：
- Dashboard/nodes 的待处理设备审批
- 策略或身份更改后待处理的 DM pairing 审批

常见错误签名：
- `device identity required` → device auth 未满足
- `pairing required` → sender/device 必须被批准

### 如果服务配置和 runtime 仍然不一致
```bash
openclaw gateway install --force
openclaw gateway restart
```

### 相关文档
- [/gateway/pairing](https://docs.openclaw.ai/gateway/pairing)
- [/gateway/authentication](https://docs.openclaw.ai/gateway/authentication)
- [/gateway/background-process](https://docs.openclaw.ai/gateway/background-process)

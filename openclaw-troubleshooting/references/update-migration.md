# 升级迁移问题

## 如果升级后突然出问题

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#if-you-upgraded-and-something-suddenly-broke

大多数升级后的问题是配置漂移或更严格的默认值现在被强制执行。

---

### 1) Auth and URL override behavior changed

#### 诊断命令
```bash
openclaw gateway status
openclaw config get gateway.mode
openclaw config get gateway.remote.url
openclaw config get gateway.auth.mode
```

#### 检查要点

| 检查项 | 说明 |
|--------|------|
| If `gateway.mode=remote`, CLI calls may be targeting remote while your local service is fine | CLI 调用可能指向远程，而本地服务正常 |
| Explicit `--url` calls do not fall back to stored credentials | 显式 `--url` 调用不会回退到存储的凭证 |

#### 常见错误签名

| 错误签名 | 含义 |
|----------|------|
| `gateway connect failed:` | 错误的 URL 目标 |
| `unauthorized` | 端点可达但认证错误 |

---

### 2) Bind and auth guardrails are stricter

#### 诊断命令
```bash
openclaw config get gateway.bind
openclaw config get gateway.auth.token
openclaw gateway status
openclaw logs --follow
```

#### 检查要点

| 检查项 | 说明 |
|--------|------|
| Non-loopback binds (`lan`, `tailnet`, `custom`) need auth configured | 非 loopback 绑定需要配置 auth |
| Old keys like `gateway.token` do not replace `gateway.auth.token` | 旧键如 `gateway.token` 不会替换 `gateway.auth.token` |

#### 常见错误签名

| 错误签名 | 含义 |
|----------|------|
| `refusing to bind gateway ... without auth` | bind+auth 不匹配 |
| `RPC probe: failed` while runtime is running | gateway 活着但用当前 auth/url 无法访问 |

---

### 3) Pairing and device identity state changed

#### 诊断命令
```bash
openclaw devices list
openclaw pairing list --channel <channel> [--account <id>]
openclaw logs --follow
openclaw doctor
```

#### 检查要点

| 检查项 | 说明 |
|--------|------|
| Pending device approvals for dashboard/nodes | Dashboard/nodes 的待处理设备审批 |
| Pending DM pairing approvals after policy or identity changes | 策略或身份更改后待处理的 DM pairing 审批 |

#### 常见错误签名

| 错误签名 | 含义 |
|----------|------|
| `device identity required` | device auth 未满足 |
| `pairing required` | sender/device 必须被批准 |

---

### 如果服务配置和 runtime 仍然不一致

重新安装服务元数据：
```bash
openclaw gateway install --force
openclaw gateway restart
```

---

## Doctor 迁移功能

来自官方文档：https://docs.openclaw.ai/gateway/doctor

### 1) Config normalization
如果配置包含旧值形状，doctor 将它们规范化为当前模式。

### 2) Legacy config key migrations
当配置包含已弃用的键时，其他命令拒绝运行并要求运行 `openclaw doctor`。

Doctor 会：
- 解释发现了哪些旧键
- 显示应用的迁移
- 用更新后的模式重写 `~/.openclaw/openclaw.json`

**当前迁移**：
- `routing.allowFrom` → `channels.whatsapp.allowFrom`
- `routing.groupChat.requireMention` → `channels.whatsapp/telegram/imessage.groups."*".requireMention`
- `routing.groupChat.historyLimit` → `messages.groupChat.historyLimit`
- `routing.groupChat.mentionPatterns` → `messages.groupChat.mentionPatterns`
- `routing.queue` → `messages.queue`
- `routing.bindings` → top-level `bindings`
- `routing.agents`/`routing.defaultAgentId` → `agents.list` + `agents.list[].default`
- 等等...

### 3) Legacy state migrations (disk layout)
Doctor 可以将旧的磁盘布局迁移到当前结构：
- Sessions store + transcripts：从 `~/.openclaw/sessions/` 到 `~/.openclaw/agents/<agentId>/sessions/`
- Agent dir：从 `~/.openclaw/agent/` 到 `~/.openclaw/agents/<agentId>/agent/`
- WhatsApp auth state：从旧的 `~/.openclaw/credentials/*.json` 到 `~/.openclaw/credentials/whatsapp/<accountId>/...`

### 3b) Legacy cron store migrations
Doctor 还检查 cron job store 中的旧任务形状。

### 4) State integrity checks
检查 state dir 的完整性和权限。

---

## 升级前检查清单

1. [ ] 备份配置文件：`~/.openclaw/openclaw.json`
2. [ ] 备份 state 目录：`~/.openclaw/`
3. [ ] 记录当前版本：`openclaw --version`
4. [ ] 检查是否有未保存的更改
5. [ ] 阅读 release notes
6. [ ] 计划回滚方案

---

## 升级回滚方案

如果升级后出现问题：

1. 停止 Gateway 服务
2. 恢复备份的配置文件和 state 目录
3. 重新安装旧版本（如果需要）
4. 重启 Gateway

---

## 相关文档

- [/gateway/pairing](https://docs.openclaw.ai/gateway/pairing)
- [/gateway/authentication](https://docs.openclaw.ai/gateway/authentication)
- [/gateway/background-process](https://docs.openclaw.ai/gateway/background-process)
- [/gateway/doctor](https://docs.openclaw.ai/gateway/doctor)

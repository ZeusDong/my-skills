# 消息通道问题

## 无回复（通道已连接但无响应）

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#no-replies

如果通道已启动但没有任何回复，在重新连接任何东西之前先检查路由和策略。

### 诊断命令
```bash
openclaw status
openclaw channels status --probe
openclaw pairing list --channel <channel> [--account <id>]
openclaw config get channels
openclaw logs --follow
```

### 检查要点

| 检查项 | 说明 |
|--------|------|
| Pairing pending for DM senders | DM 发送者的 pairing 待处理 |
| Group mention gating (`requireMention`, `mentionPatterns`) | 群组提及门控 |
| Channel/group allowlist mismatches | 通道/群组允许列表不匹配 |

### 常见错误签名

| 错误签名 | 含义 |
|----------|------|
| `drop guild message (mention required` | 群组消息在提及前被忽略 |
| `pairing request` | 发送者需要批准 |
| `blocked` / `allowlist` | 发送者/通道被策略过滤 |

### 相关文档
- [/channels/troubleshooting](https://docs.openclaw.ai/channels/troubleshooting)
- [/channels/pairing](https://docs.openclaw.ai/channels/pairing)
- [/channels/groups](https://docs.openclaw.ai/channels/groups)

---

## 通道已连接但消息不流动

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#channel-connected-messages-not-flowing

如果通道状态为已连接但消息流停止，关注策略、权限和通道特定的投递规则。

### 诊断命令
```bash
openclaw channels status --probe
openclaw pairing list --channel <channel> [--account <id>]
openclaw status --deep
openclaw logs --follow
openclaw config get channels
```

### 检查要点

| 检查项 | 说明 |
|--------|------|
| DM policy (`pairing`, `allowlist`, `open`, `disabled`) | DM 策略 |
| Group allowlist and mention requirements | 群组允许列表和提及要求 |
| Missing channel API permissions/scopes | 缺少通道 API 权限/范围 |

### 常见错误签名

| 错误签名 | 含义 |
|----------|------|
| `mention required` | 消息被群组提及策略忽略 |
| `pairing` / pending approval traces | 发送者未被批准 |
| `missing_scope`, `not_in_channel`, `Forbidden`, `401/403` | 通道认证/权限问题 |

### 相关文档
- [/channels/troubleshooting](https://docs.openclaw.ai/channels/troubleshooting)
- [/channels/whatsapp](https://docs.openclaw.ai/channels/whatsapp)
- [/channels/telegram](https://docs.openclaw.ai/channels/telegram)
- [/channels/discord](https://docs.openclaw.ai/channels/discord)

---

## 通道专用日志

来自官方文档：https://docs.openclaw.ai/logging#channel-only-logs

要过滤通道活动（WhatsApp/Telegram/etc），使用：
```bash
openclaw channels logs --channel whatsapp
```

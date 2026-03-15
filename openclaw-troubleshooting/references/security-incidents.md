# 安全事件响应

## ⚠️ 风险提示

**本技能提供的安全建议仅供参考。**

- 关键操作请咨询安全专家
- 生产环境操作前请先备份
- 以下操作可能影响服务可用性，请评估后执行

---

## 抢占式安全判断（最高优先级）

只要用户提到以下任一情况，**立即跳转此流程**，不走普通 triage：
- 公网暴露
- Token 泄露
- 异常自动行为
- 未知远程调用

---

## 官方安全响应流程（严格按此顺序）✅

来自官方文档：https://docs.openclaw.ai/gateway/security#incident-response

### 1. Contain（先停）
- 停 gateway
- 缩回 loopback
- 冻结高风险入口

### 2. Rotate（轮换）
- 轮换 token
- 轮换 provider 凭证
- **假设 compromise if secrets leaked**

### 3. Audit（审计）
- 查看日志
- 查看会话记录
- 运行安全审计：`openclaw security audit` / `--deep`

---

## 安全审计命令

### 快速检查
```
openclaw security audit
```

### 深度检查
```
openclaw security audit --deep
```

### 自动修复
```
openclaw security audit --fix
```

### JSON 输出
```
openclaw security audit --json
```

**安全审计检查内容**（高层面）：
- **Inbound access**（DM policies, group policies, allowlists）：can strangers trigger the bot?
- **Tool blast radius**（elevated tools + open rooms）：could prompt injection turn into shell/file/network actions?
- **Network exposure**（Gateway bind/auth, Tailscale Serve/Funnel, weak/short auth tokens）
- **Browser control exposure**（remote nodes, relay ports, remote CDP endpoints）
- **Local disk hygiene**（permissions, symlinks, config includes, "synced folder" paths）
- **Plugins**（extensions exist without an explicit allowlist）
- **Policy drift/misconfig**
- **Runtime expectation drift**
- **Model hygiene**

---

## 安全审计检查清单优先级

来自官方文档：https://docs.openclaw.ai/gateway/security#security-audit-checklist

1. **Anything "open" + tools enabled**：lock down DMs/groups first（pairing/allowlists）, then tighten tool policy/sandboxing.
2. **Public network exposure**（LAN bind, Funnel, missing auth）：fix immediately.
3. **Browser control remote exposure**：treat it like operator access（tailnet-only, pair nodes deliberately, avoid public exposure）.
4. **Permissions**：make sure state/config/credentials/auth are not group/world-readable.
5. **Plugins/extensions**：only load what you explicitly trust.
6. **Model choice**：prefer modern, instruction-hardened models for any bot with tools.

---

## Hardened baseline in 60 seconds

来自官方文档的推荐安全基线配置：

```json
{
  "gateway": {
    "mode": "local",
    "bind": "loopback",
    "auth": { "mode": "token", "token": "replace-with-long-random-token" }
  },
  "session": {
    "dmScope": "per-channel-peer"
  },
  "tools": {
    "profile": "messaging",
    "deny": ["group:automation", "group:runtime", "group:fs", "sessions_spawn", "sessions_send"],
    "fs": { "workspaceOnly": true },
    "exec": { "security": "deny", "ask": "always" },
    "elevated": { "enabled": false }
  },
  "channels": {
    "whatsapp": { "dmPolicy": "pairing", "groups": { "*": { "requireMention": true } } }
  }
}
```

---

## 后续步骤

- 确认入侵范围
- 修复漏洞
- 恢复服务（谨慎）
- 总结经验，加强防护

---

## 相关官方文档

- [Security 🔒](https://docs.openclaw.ai/gateway/security)
- [Incident Response](https://docs.openclaw.ai/gateway/security#incident-response)
- [Formal Verification (Security Models)](https://docs.openclaw.ai/security/formal-verification)
- [THREAT MODEL ATLAS](https://docs.openclaw.ai/security/THREAT-MODEL-ATLAS)

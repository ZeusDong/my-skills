# 日志诊断问题

## 日志位置

来自官方文档：https://docs.openclaw.ai/logging#where-logs-live

默认情况下，Gateway 在以下位置写入滚动日志文件：
```
/tmp/openclaw/openclaw-YYYY-MM-DD.log
```

日期使用 gateway 主机的本地时区。

可以在 `~/.openclaw/openclaw.json` 中覆盖：
```json
{
  "logging": {
    "file": "/path/to/openclaw.log"
  }
}
```

---

## 如何读取日志

### CLI: live tail（推荐）

使用 CLI 通过 RPC 跟踪 gateway 日志文件：
```bash
openclaw logs --follow
```

### 输出模式

| 模式 | 说明 |
|------|------|
| **TTY sessions** | pretty, colorized, structured log lines |
| **Non-TTY sessions** | plain text |
| `--json` | line-delimited JSON（one log event per line） |
| `--plain` | force plain text in TTY sessions |
| `--no-color` | disable ANSI colors |

### JSON 模式

在 JSON 模式下，CLI 发出 `type` 标签的对象：
- `meta`: stream metadata（file, cursor, size）
- `log`: parsed log entry
- `notice`: truncation / rotation hints
- `raw`: unparsed log line

如果 Gateway 不可达，CLI 打印简短提示运行：
```bash
openclaw doctor
```

---

## 日志格式

### File logs (JSONL)

日志文件中的每一行都是一个 JSON 对象。CLI 和 Control UI 解析这些条目以呈现结构化输出（time, level, subsystem, message）。

### Console output

控制台日志是 **TTY-aware** 的，并为可读性格式化：
- Subsystem prefixes（例如 `gateway/channels/whatsapp`）
- Level coloring（info/warn/error）
- Optional compact or JSON mode

控制台格式化由 `logging.consoleStyle` 控制。

---

## 配置日志

所有日志配置都位于 `~/.openclaw/openclaw.json` 的 `logging` 下：
```json
{
  "logging": {
    "level": "info",
    "file": "/tmp/openclaw/openclaw-YYYY-MM-DD.log",
    "consoleLevel": "info",
    "consoleStyle": "pretty",
    "redactSensitive": "tools",
    "redactPatterns": ["sk-.*"]
  }
}
```

### 日志级别

- `logging.level`: **file logs**（JSONL）级别
- `logging.consoleLevel`: **console** 详细程度级别

可以通过 **`OPENCLAW_LOG_LEVEL`** 环境变量覆盖两者（例如 `OPENCLAW_LOG_LEVEL=debug`）。环境变量优先于配置文件，因此可以在不编辑 `openclaw.json` 的情况下提高单次运行的详细程度。也可以传递全局 CLI 选项 **`--log-level <level>`**（例如 `openclaw --log-level debug gateway run`），它会覆盖该命令的环境变量。

`--verbose` 仅影响控制台输出；它不会更改文件日志级别。

### 控制台样式

`logging.consoleStyle`:
- `pretty`: human-friendly, colored, with timestamps
- `compact`: tighter output（best for long sessions）
- `json`: JSON per line（for log processors）

### Redaction

工具摘要可以在到达控制台之前脱敏敏感 token：
- `logging.redactSensitive`: `off` \| `tools`（default: `tools`）
- `logging.redactPatterns`: 正则表达式字符串列表以覆盖默认集合

Redaction **仅影响控制台输出**，不会更改文件日志。

---

## Diagnostics flags（targeted logs）

来自官方文档：https://docs.openclaw.ai/logging#diagnostics-flags-targeted-logs

使用 flags 可以在不提高 `logging.level` 的情况下打开额外的、有针对性的调试日志。Flags 不区分大小写，支持通配符（例如 `telegram.*` 或 `*`）。

### 配置示例
```json
{
  "diagnostics": {
    "flags": ["telegram.http"]
  }
}
```

### 环境变量覆盖（一次性）
```bash
OPENCLAW_DIAGNOSTICS=telegram.http,telegram.payload
```

### 注意事项
- Flag 日志进入标准日志文件（与 `logging.file` 相同）
- 输出仍根据 `logging.redactSensitive` 进行脱敏
- 完整指南：[/diagnostics/flags](https://docs.openclaw.ai/diagnostics/flags)

---

## 故障排除提示

来自官方文档：https://docs.openclaw.ai/logging#troubleshooting-tips

- **Gateway not reachable?** 先运行 `openclaw doctor`
- **Logs empty?** 检查 Gateway 正在运行并写入 `logging.file` 中的文件路径
- **Need more detail?** 将 `logging.level` 设置为 `debug` 或 `trace` 并重试

---

## 相关文档

- [Logging](https://docs.openclaw.ai/logging)
- [Gateway logging](https://docs.openclaw.ai/gateway/logging)
- [Diagnostics flags](https://docs.openclaw.ai/diagnostics/flags)

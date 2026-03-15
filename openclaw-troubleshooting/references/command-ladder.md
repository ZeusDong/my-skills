# 官方命令梯子

## 官方推荐诊断顺序（按此顺序执行）✅

来自官方文档：https://docs.openclaw.ai/gateway/troubleshooting#command-ladder

```
openclaw status
openclaw gateway status
openclaw logs --follow
openclaw doctor
openclaw channels status --probe
```

---

## 预期健康信号

### `openclaw gateway status`
应该显示：
- `Runtime: running`
- `RPC probe: ok`

### `openclaw doctor`
应该报告：
- no blocking config/service issues

### `openclaw channels status --probe`
应该显示：
- connected/ready channels

---

## 命令详解

### 1. `openclaw status`
- 用途：查看 OpenClaw 基本状态
- 预期输出：[待实际安装后补充]

### 2. `openclaw gateway status`
- 用途：查看 Gateway 详细状态
- 预期输出：包含 Runtime 和 RPC probe 状态
- 附加选项：`--json`（JSON 格式输出）、`--deep`（深度检查）

### 3. `openclaw logs --follow`
- 用途：实时查看日志
- 输出模式：
  - TTY sessions：pretty, colorized, structured
  - Non-TTY：plain text
  - `--json`：line-delimited JSON
  - `--plain`：force plain text
  - `--no-color`：disable ANSI colors
- 如果 Gateway 不可达，CLI 提示运行：`openclaw doctor`

### 4. `openclaw doctor`
- 用途：自动诊断并修复常见问题
- 详细说明：见 [/gateway/doctor](https://docs.openclaw.ai/gateway/doctor)
- 选项：
  - `--yes`：接受默认修复而不提示
  - `--repair`：应用推荐修复而不提示
  - `--repair --force`：应用激进修复（覆盖自定义配置）
  - `--non-interactive`：仅应用安全迁移，跳过需要确认的操作
  - `--deep`：扫描系统服务查找额外的 gateway 安装

### 5. `openclaw channels status --probe`
- 用途：探测消息通道状态
- 预期输出：connected/ready channels

---

## 其他有用命令

### 通道专用日志
```
openclaw channels logs --channel whatsapp
```

### 安全审计
```
openclaw security audit
openclaw security audit --deep
openclaw security audit --fix
```

### Gateway 服务管理
```
openclaw gateway install --force
openclaw gateway restart
```

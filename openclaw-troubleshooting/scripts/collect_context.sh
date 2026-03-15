#!/bin/bash

# OpenClaw 环境信息收集脚本
# 两档设计：默认安全采集 / 扩展采集
#
# 使用说明：
#   ./collect_context.sh          # 默认安全采集
#   ./collect_context.sh --full   # 扩展采集（需用户明确同意）

set -e

echo "========================================="
echo "OpenClaw 环境信息收集脚本"
echo "========================================="
echo ""

# 默认安全采集
echo "[1/6] 收集版本信息..."
if command -v openclaw &> /dev/null; then
    OPENCLAW_VERSION=$(openclaw --version 2>&1 || echo "无法获取版本")
    echo "OpenClaw 版本: $OPENCLAW_VERSION"
else
    echo "OpenClaw 命令未找到"
fi

echo ""
echo "[2/6] 检查安装方式..."
if [ -d ".git" ]; then
    echo "安装方式: git 仓库"
elif command -v npm &> /dev/null && npm list -g openclaw &> /dev/null; then
    echo "安装方式: npm 全局安装"
else
    echo "安装方式: 未知（需用户补充）"
fi

echo ""
echo "[3/6] 收集 Gateway 状态..."
if command -v openclaw &> /dev/null; then
    echo "Gateway 状态（摘要）:"
    openclaw gateway status 2>&1 | head -20 || echo "无法获取 Gateway 状态"
fi

echo ""
echo "[4/6] 运行 doctor 摘要（非交互模式）..."
if command -v openclaw &> /dev/null; then
    echo "Doctor 输出（摘要）:"
    openclaw doctor --non-interactive 2>&1 | head -30 || echo "无法运行 doctor"
fi

echo ""
echo "[5/6] 检查最近日志（最后 50 行）..."
# 官方日志路径：/tmp/openclaw/openclaw-YYYY-MM-DD.log
LOG_PATH="/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
if [ -f "$LOG_PATH" ]; then
    echo "日志文件: $LOG_PATH"
    echo "日志尾部（最后 50 行）:"
    tail -50 "$LOG_PATH" 2>&1 | head -50
else
    echo "日志文件未找到: $LOG_PATH"
    echo "尝试查找其他日志文件..."
    ls -la /tmp/openclaw/ 2>/dev/null || echo "/tmp/openclaw/ 目录不存在"
fi

echo ""
echo "[6/6] 检查配置文件..."
CONFIG_PATH="$HOME/.openclaw/openclaw.json"
if [ -f "$CONFIG_PATH" ]; then
    echo "配置文件存在: $CONFIG_PATH"
    echo "配置文件权限:"
    ls -la "$CONFIG_PATH"
else
    echo "配置文件未找到: $CONFIG_PATH"
fi

echo ""
echo "========================================="
echo "默认安全采集完成"
echo "========================================="

# 扩展采集（需用户明确同意）
if [ "$1" = "--full" ]; then
    echo ""
    echo "========================================="
    echo "开始扩展采集..."
    echo "========================================="
    
    echo ""
    echo "[扩展 1/3] 收集 channels 状态..."
    if command -v openclaw &> /dev/null; then
        openclaw channels status --probe 2>&1 || echo "无法获取 channels 状态"
    fi
    
    echo ""
    echo "[扩展 2/3] 运行安全审计..."
    if command -v openclaw &> /dev/null; then
        openclaw security audit 2>&1 || echo "无法运行安全审计"
    fi
    
    echo ""
    echo "[扩展 3/3] 收集完整状态..."
    if command -v openclaw &> /dev/null; then
        openclaw status --deep 2>&1 || echo "无法获取完整状态"
    fi
    
    echo ""
    echo "扩展采集完成"
fi

echo ""
echo "请将以上输出粘贴到对话中。"
echo ""
echo "注意：请确保已移除敏感信息（token、密码等）后再粘贴！"

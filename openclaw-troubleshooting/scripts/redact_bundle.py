#!/usr/bin/env python3
"""
OpenClaw 日志脱敏打包脚本
⚠️ 注意：此脚本需要 Python 环境，是可选的高级工具！
🥇 优先方案：让用户手动脱敏关键信息后再粘贴，不需要 Python！
"""

import argparse
import re
import sys


def redact_text(text):
    """
    脱敏处理文本内容
    """
    # 脱敏 IP 地址
    text = re.sub(r'\b(?:\d{1,3}\.){3}\d{1,3}\b', '[INTERNAL_IP]', text)
    
    # 脱敏内网 IP
    text = re.sub(r'\b192\.168\.\d{1,3}\.\d{1,3}\b', '[INTERNAL_IP]', text)
    text = re.sub(r'\b10\.\d{1,3}\.\d{1,3}\.\d{1,3}\b', '[INTERNAL_IP]', text)
    text = re.sub(r'\b172\.(?:1[6-9]|2\d|3[01])\.\d{1,3}\.\d{1,3}\b', '[INTERNAL_IP]', text)
    
    # 脱敏密码
    text = re.sub(r'password\s*=\s*[^\s]+', 'password=[REDACTED]', text, flags=re.IGNORECASE)
    text = re.sub(r'passwd\s*=\s*[^\s]+', 'passwd=[REDACTED]', text, flags=re.IGNORECASE)
    
    # 脱敏 Token 和 API Key
    text = re.sub(r'token\s*=\s*[^\s]+', 'token=[REDACTED]', text, flags=re.IGNORECASE)
    text = re.sub(r'api[_-]?key\s*=\s*[^\s]+', 'api_key=[REDACTED]', text, flags=re.IGNORECASE)
    text = re.sub(r'secret\s*=\s*[^\s]+', 'secret=[REDACTED]', text, flags=re.IGNORECASE)
    
    # 脱敏 Bearer Token
    text = re.sub(r'Bearer\s+[A-Za-z0-9\-._~+/]+=*', 'Bearer [REDACTED]', text)
    
    return text


def parse_args():
    parser = argparse.ArgumentParser(description="OpenClaw 日志脱敏打包（可选的高级工具）")
    parser.add_argument("input", help="输入文件或文本")
    parser.add_argument("--output", "-o", help="输出文件")
    parser.add_argument("--stdin", action="store_true", help="从标准输入读取")
    return parser.parse_args()


def main():
    args = parse_args()
    
    print("=" * 60)
    print("OpenClaw 日志脱敏打包脚本")
    print("=" * 60)
    print("")
    print("⚠️  注意：这是可选的高级工具！")
    print("🥇 优先方案：手动检查并脱敏关键信息后再粘贴")
    print("   （不需要 Python，大多数用户都不需要这个脚本）")
    print("")
    print("提示：请确保移除或替换以下敏感信息：")
    print("  - IP 地址（替换为 [INTERNAL_IP]）")
    print("  - 密码、Token、API Key（替换为 [REDACTED]）")
    print("  - 其他敏感信息")
    print("=" * 60)
    print("")
    
    # 读取输入
    if args.stdin:
        content = sys.stdin.read()
    else:
        try:
            with open(args.input, 'r') as f:
                content = f.read()
        except FileNotFoundError:
            content = args.input
    
    # 脱敏处理
    redacted = redact_text(content)
    
    # 输出
    if args.output:
        with open(args.output, 'w') as f:
            f.write(redacted)
        print(f"已生成脱敏文件: {args.output}")
    else:
        print("\n脱敏后的内容（示例）：")
        print("-" * 60)
        print(redacted[:500] + "..." if len(redacted) > 500 else redacted)
        print("-" * 60)
        print("\n（仅展示前 500 字符，完整内容请使用 --output 参数）")


if __name__ == "__main__":
    main()

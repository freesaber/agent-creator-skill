#!/bin/bash

# ==========================================
# OpenClaw 自动化创建 Agent 脚本
# 接收两个参数：
# $1: agent_name_en (如 java_senior_dev)
# $2: identity_prompt (详细的身份设定 prompt)
# ==========================================

# 1. 安全检查：确保 LLM 传对了两个参数
if [ "$#" -ne 2 ]; then
    echo "❌ Error: 参数数量不正确。"
    echo "用法: bash create_agent.sh <agent_name_en> \"<identity_prompt>\""
    exit 1
fi

AGENT_NAME=$1
PERSONA=$2
# 定义目标工作区路径，统一放在 ~/.openclaw 目录下
WORKSPACE_DIR="$HOME/.openclaw/workspace-${AGENT_NAME}"

echo "🚀 开始为 OpenClaw 创建新 Agent: ${AGENT_NAME}"
echo "📂 规划工作区路径: ${WORKSPACE_DIR}"

# ==========================================
# 步骤 1: 创建 Agent 并指定工作区
# ==========================================
echo "------------------------------------------"
echo "👉 [1/2] 正在执行创建命令..."

# 执行并检查是否成功
if openclaw agents add "${AGENT_NAME}" --workspace "${WORKSPACE_DIR}"; then
    echo "✅ Agent [${AGENT_NAME}] 工作区创建成功！"
else
    echo "❌ Agent 创建失败！该 Agent 可能已存在，或者路径无权限。"
    exit 1 # 失败则退出，不要继续执行下一步
fi

# ==========================================
# 步骤 2: 给 Agent 发送 Message，初始化身份设定
# ==========================================
echo "------------------------------------------"
echo "👉 [2/2] 正在注入身份设定 (Persona)..."

# 组装初始指令，告诉这个新 Agent 记住自己的身份
FULL_MESSAGE="记住你的身份设定：\n${PERSONA}"

# 调用对应 Agent 并发送消息
if openclaw agent --agent "${AGENT_NAME}" --message "${FULL_MESSAGE}"; then
    echo "✅ 身份设定注入成功！"
else
    echo "❌ 身份设定注入失败！请检查 OpenClaw 核心服务状态。"
    exit 1
fi

# ==========================================
# 完成
# ==========================================
echo "------------------------------------------"
echo "🎉 SUCCESS! 代理 [${AGENT_NAME}] 创建与初始化全部完成！"
exit 0

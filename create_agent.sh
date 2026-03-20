#!/bin/bash

# ==========================================
# OpenClaw 自动化创建 Agent 脚本 (Enhanced)
# $1: agent_id (如 java_senior_dev)
# $2: agent_display_name (如 Java高级开发)
# $3: identity_prompt (详细设定)
# ==========================================

if [ "$#" -ne 3 ]; then
    echo "❌ Error: 参数数量不正确。"
    echo "用法: bash create_agent.sh <id> <name> <prompt>"
    exit 1
fi

AGENT_ID=$1
DISPLAY_NAME=$2
PERSONA=$3
WORKSPACE_DIR="$HOME/.openclaw/workspace-${AGENT_ID}"

echo "🚀 开始创建 Agent: ${DISPLAY_NAME} (ID: ${AGENT_ID})"

# ==========================================
# 步骤 1: 创建 Agent，使用 --name 指定显示名称
# ==========================================
# 注意：${AGENT_ID} 作为位置参数传给 [name]，--name 传给显示名称
if openclaw agents add "${AGENT_ID}" --name "${DISPLAY_NAME}" --workspace "${WORKSPACE_DIR}"; then
    echo "✅ Agent [${DISPLAY_NAME}] 创建成功！"
else
    echo "❌ Agent 创建失败！"
    exit 1
fi

# ==========================================
# 步骤 2: 注入身份设定
# ==========================================
FULL_MESSAGE="记住你的身份设定：\n${PERSONA}"

# 调用时使用 AGENT_ID
if openclaw agent --agent "${AGENT_ID}" --message "${FULL_MESSAGE}"; then
    echo "✅ 身份设定注入成功！"
else
    echo "❌ 注入失败！"
    exit 1
fi

echo "🎉 SUCCESS! 代理 [${DISPLAY_NAME}] 已准备就绪！"
exit 0
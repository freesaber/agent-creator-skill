# OpenClaw Agent Creator Skill

一个轻量级的 OpenClaw 技能，允许你通过口语化的方式让主 Agent 自动帮你创建并初始化其他 Agent。

## 工作原理
1. 龙虾 (主 Agent) 接收到自然语言指令（例："创建一个精通Python爬虫的代理"）。
2. 龙虾根据 `SKILL.md` 的规范，自动将名字翻译为 `python_spider_expert`，并自动撰写数百字的“Python爬虫专家”身份提示词。
3. 龙虾调用 `bash create_agent.sh "python_spider_expert" "你是一个资深..."`。
4. Shell 脚本自动执行 `openclaw agents add` 和 `openclaw agent --message`，完成环境创建和记忆注入。

## 安装与使用
1. 将此文件夹放入 `~/.openclaw/workspace/skills/` 目录下。
2. 确保脚本有执行权限：`chmod +x create_agent.sh`
3. 重启 OpenClaw，直接在聊天框发送指令即可。
4. 使用的时候，还需要明确指出，不创建子代理，比如：使用agent-creator创建一个精通爬虫的代理。不要创建subagent。

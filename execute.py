import os
import subprocess
import logging

logger = logging.getLogger(__name__)

def create_sub_agent(agent_name_en: str, identity_prompt: str) -> str:
    """
    具体的执行逻辑：通过系统命令调用 OpenClaw CLI 来创建和初始化 Agent。
    """
    logger.info(f"LLM 请求创建 Agent: {agent_name_en}")
    
    # 定义工作区路径
    workspace_path = os.path.expanduser(f"~/.openclaw/workspace-{agent_name_en}")
    
    try:
        # 动作 1: 执行创建命令
        add_cmd = ["openclaw", "agents", "add", agent_name_en, "--workspace", workspace_path]
        logger.info(f"执行创建命令: {' '.join(add_cmd)}")
        subprocess.run(add_cmd, capture_output=True, text=True, check=True)
        
        # 动作 2: 执行初始化身份命令
        init_message = f"记住你的身份：\n{identity_prompt}"
        init_cmd = ["openclaw", "agent", "--agent", agent_name_en, "--message", init_message]
        logger.info(f"执行初始化命令, 赋予 {agent_name_en} 身份设定")
        subprocess.run(init_cmd, capture_output=True, text=True, check=True)
        
        # 返回成功结果给大模型
        return (f"SUCCESS! Agent '{agent_name_en}' created successfully.\n"
                f"Workspace path: {workspace_path}\n"
                f"Persona successfully initialized.")

    except subprocess.CalledProcessError as e:
        error_msg = f"Failed to execute command. Error: {e.stderr.strip()}"
        logger.error(error_msg)
        return error_msg
    except Exception as e:
        error_msg = f"Unknown error occurred: {str(e)}"
        logger.error(error_msg)
        return error_msg

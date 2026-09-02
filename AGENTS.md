# AGENTS.md - 自动加载规约
当 agent (Claude Code / Codex / Hermes) 进入本项目目录时,自动加载本文件。无需显式 trigger。
# 本项目是 c-coding-style skill
C 编码风格与 Doxygen 注释规约,合并通用基线 + MISRA C 2012 叠加项。
# 触发条件
- 写 / 改 / 审查 .c / .h 文件 (命名 / 缩进 / 控制流 / 宏 / 内存 / 错误处理 / Doxygen 注释)
- 用户提到 C / 嵌入式 / 固件 / 驱动 / MISRA C / Autosar / doxygen 注释
- 用户要求按 C 规约生成代码
# 文档结构
- SKILL.md - 触发条件 + 操作流程 (渐进披露入口)
- references/C_CODING_STYLE.md - 18 章主规约 (按需加载)
- references/DOXYGEN_STYLE.md - Doxygen 注释规约 (按需加载)
- .clang-format - 排版自检配置
- scripts/check.sh - 规约自检脚本
# 操作流程
1. 确认任务涉及 .c / .h (写 / 改 / 审查)
2. 按场景决定读哪份 references (命名 / 排版 / 控制流 → C_CODING_STYLE; 注释 → DOXYGEN_STYLE)
3. 按章节速查定位章节,按硬约束自检
4. 写完后跑 bash scripts/check.sh 自检
# 引用关系

references/C_CODING_STYLE.md 第 0 章与第 11 章明文指向 references/DOXYGEN_STYLE.md 作为注释规约正本。任一份更新时同步另一边,避免引用断链。


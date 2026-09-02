# c-coding-style
C 编码风格与 Doxygen 注释规约，合并通用基线 + MISRA C 2012 叠加项，适用于嵌入式 / 安全 / 汽车行业的 C 团队。
![License](https://img.shields.io/badge/license-MIT-blue)
![Stars](https://img.shields.io/github/stars/USER/c-coding-style)
![Last commit](https://img.shields.io/github/last-commit/USER/c-coding-style)
![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blue)
![Codex](https://img.shields.io/badge/Codex-compatible-green)
![Hermes](https://img.shields.io/badge/Hermes-compatible-lightgrey)
![Cursor](https://img.shields.io/badge/Cursor-compatible-purple)
## 这是什么
一个面向 agent (Claude Code / Codex / Hermes / Cursor 等) 的 C 代码规约 skill。合并主规约 + Doxygen 注释规约，覆盖命名 / 类型 / 控制流 / 宏 / 内存 / 并发 / 错误处理 / MISRA C 2012 叠加项。配套 .clang-format 排版 + scripts/check.sh 自检。
## 为什么用
- 用了之前: agent 生成 C 代码风格混乱，命名不一致，注释格式随缘，团队代码 review 扯皮
- 用了之后: agent 严格按规约生成，.clang-format 自动排版，scripts/check.sh 提交前自检
- 适用: 嵌入式 / 汽车 / 安全 / 医疗等 C 团队；通用 C 项目也可参考
- 不适用: C++ / Objective-C / Rust / Go 等其它语言（除非用户明确要求套用 C 风格）
- 差异化: 通用基线 + MISRA C 2012 叠加项 + Doxygen 规约，三合一目前无人占位
## 快速开始
Claude Code:
cp -r ~/.claude/skills/c-coding-style ~/.claude/skills/c-coding-style
Codex:
cp -r ~/.codex/skills/c-coding-style ~/.codex/skills/c-coding-style
Hermes (用 multi-star-skill 的 sync-hermes.py 同步):
python ~/.codex/skills/multi-star-skill/assets/sync-hermes.py --verbose
Cursor / Kilo Code / Windsurf / OpenCode / Augment / Antigravity / Aider:
bash ~/.codex/skills/multi-star-skill/assets/platform-conversion.sh --skill . --tool all --out integrations/
bash ~/.codex/skills/multi-star-skill/assets/platform-install.sh --tool cursor --target /path/to/your/project
重复 --tool 参数直至所有平台都安装完
验证 (所有平台):
bash scripts/check.sh
## 主要功能
- 命名约定 (PascalCase 类型 + 双下划线后缀, UPPER_SNAKE_CASE 宏, snake_case 变量 + 模块前缀)
- 排版规约 (4 空格缩进, K&R 紧凑花括号, Yoda 风格 if)
- 类型与字面量 (定宽整数, U/L/LL/f 后缀)
- 头文件保护宏 (传统 ifndef 形式, 禁止 pragma once)
- 控制流 (Yoda, switch default, goto 单一出口)
- 宏 (多语句宏用 do-while-0)
- 内存 (malloc NULL 检查, free 后置 NULL, 静态优先)
- 并发 (ISR 极短, 共享变量加 volatile / 原子类型)
- 错误处理 (goto err_out 模式, 错误码命名)
- MISRA C 2012 叠加项
- Doxygen 注释 (中文 brief, .h 禁用 details, param 方向标注)
## 对照其它方案
| 维度 | 本 skill | jdubray/puffin | xwos/XWOS | williamzujkowski/standards |
|---|---|---|---|---|
| 覆盖范围 | 18 章全栈 | 仅命名 | 命名+类型+错误+注释+格式+段属性 | 多语言规约集 |
| 配套工具 | .clang-format + scripts/check.sh | 无 | .clang-format | 无 |
| 多 agent 兼容 | 10 平台 | 仅 Claude | 仅项目内 | 仅 Claude |
| 注释规约 | 独立 references | 无 | 内嵌章节 | 无 |
| MISRA C 2012 | 第 18 章叠加项 | 无 | 强制 + 抑制清单 | 无 |
| 适用范围 | 通用基线 + MISRA 叠加 | 通用 C | 嵌入式 RTOS 专用 | 多语言 |
## 文档结构
- SKILL.md - 触发条件 + 操作流程 (agent 加载入口)
- references/C_CODING_STYLE.md - 18 章主规约
- references/DOXYGEN_STYLE.md - Doxygen 注释规约
- .clang-format - 排版自检配置
- scripts/check.sh - 自检脚本
- plugin.json - Codex 插件元数据
- LICENSE - MIT 许可证
## 配套工具
- .clang-format - 排版自检配置
- scripts/check.sh - 规约自检脚本
- references/ - 渐进加载详细规约
## 支持的 agent
- Claude Code (~/.claude/skills/c-coding-style/)
- Codex CLI (~/.codex/skills/c-coding-style/)
- Hermes Agent (经 multi-star-skill sync-hermes.py 同步)
- Cursor (.cursor/rules/c-coding-style.mdc)
- Kilo Code (.kilocode/rules/c-coding-style.md)
- Windsurf (.windsurf/skills/c-coding-style/SKILL.md)
- OpenCode (.opencode/skills/c-coding-style/SKILL.md)
- Augment (.augment/skills/c-coding-style/SKILL.md)
- Antigravity (~/.gemini/antigravity/skills/c-coding-style/)
- Aider (CONVENTIONS.md 单文件)
多平台转换: 用 multi-star-skill 的 platform-conversion.sh + platform-install.sh。
## 贡献
参见 CONTRIBUTING.md。规则变更请同步更新 references/C_CODING_STYLE.md 和 references/DOXYGEN_STYLE.md 互相引用。
## 许可证
MIT


# c-coding-style
C 编码风格与 Doxygen 注释规约，合并通用基线 + MISRA C 2012 叠加项，适用于嵌入式 / 安全 / 汽车行业的 C 团队。
![License](https://img.shields.io/badge/license-MIT-blue)
![Stars](https://img.shields.io/github/stars/CC-GIT-MAX/c-coding-style)
![Last commit](https://img.shields.io/github/last-commit/CC-GIT-MAX/c-coding-style)
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

1. 获取仓库
   git clone https://github.com/CC-GIT-MAX/c-coding-style.git
   cd c-coding-style

2. 安装到目标 agent 的 skills 目录（按平台选一条）

   Claude Code:
   mkdir -p ~/.claude/skills && cp -r . ~/.claude/skills/c-coding-style/

   Codex:
   mkdir -p ~/.codex/skills && cp -r . ~/.codex/skills/c-coding-style/

   Windows PowerShell:
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.codex\skills\c-coding-style"
   Copy-Item -Recurse -Force -Path .\* -Destination "$env:USERPROFILE\.codex\skills\c-coding-style\"

3. 验证
   bash scripts/check.sh

详细安装与多平台说明见 README 各 agent 段。
## 主要功能
- 25 条硬规则（每条带 ID + 严重程度 + BAD/GOOD/ACCEPTABLE 三例）
- 命名约定（PascalCase 类型 + 双下划线后缀，UPPER_SNAKE_CASE 宏，snake_case 变量 + 模块前缀）
- 排版规约（4 空格缩进，K&R 紧凑花括号，Yoda 风格 if）
- 类型与字面量（定宽整数，U/L/LL/f 后缀）
- 头文件保护宏（传统 ifndef 形式，禁止 #pragma once）
- 控制流（Yoda，switch default，goto 单一出口）
- 宏（多语句宏用 do-while-0）
- 内存（malloc NULL 检查，free 后置 NULL，静态优先）
- 并发（ISR 极短，共享变量加 volatile / 原子类型）
- 错误处理（goto err_out 模式，错误码命名）
- MISRA C 2012 叠加项（references/C14 §18 + misra-suppressions.txt）
- Doxygen 注释（中文 brief，.h 禁用 details，@param 方向标注）
## 文档结构
- SKILL.md — agent 加载入口（frontmatter description + 25 条硬规则清单 + 文件布局 + 软化条件）
- references/ — 详细规约，按主题分文件
  - C00-baseline-formatting.md — §0–§4 基线与排版
  - C05-naming-types.md — §5–§6 命名与类型
  - C07-headers-variables-functions.md — §7–§9 头文件 / 变量 / 函数
  - C10-control-flow-files.md — §10–§13 控制流 / 文件位置 / #include 顺序
  - C14-macros-memory-safety.md — §14–§19 宏 / 内存 / 并发 / 错误 / MISRA
  - D-doxygen-comment-style.md — Doxygen 全 6 章注释规约
  - misra-suppressions.txt — MISRA C 2012 抑制清单
- scripts/check.sh — 25 条硬规则 + 6 文件结构 + 3 severity + 3 example 标签自检
- .clang-format — 排版自检配置
- plugin.json — Codex 插件元数据
- agents/openai.yaml — Codex 平台加载入口
- assets/social-preview.png — GitHub 仓库卡片预览
- CONTRIBUTING.md — 规则变更与 PR 流程
- CHANGELOG.md — 版本演进
- LICENSE — MIT 许可证
## 配套工具
- .clang-format — 排版自检配置（agent 生成代码后跑 clang-format）
- scripts/check.sh — 规约自检脚本（CI 或提交前跑）
- references/ — 渐进披露详细规约（按需加载，不一次塞满上下文）
## 支持的 agent
- Claude Code — `~/.claude/skills/c-coding-style/`（克隆后 cp 整个仓库到该路径）
- Codex CLI — `~/.codex/skills/c-coding-style/`（自动加载 `agents/openai.yaml` + `plugin.json`）
- Hermes — `~/.hermes/skills/c-coding-style/`（手动 cp 即可）
- Cursor — `.cursor/rules/c-coding-style.mdc`（单文件，把 SKILL.md 内容塞进去）
- Kilo Code — `.kilocode/rules/c-coding-style.md`（同上）
- Windsurf — `.windsurf/skills/c-coding-style/SKILL.md`（同上）
- OpenCode — `.opencode/skills/c-coding-style/SKILL.md`（同上）
- Augment — `.augment/skills/c-coding-style/SKILL.md`（同上）
- Antigravity — `~/.gemini/antigravity/skills/c-coding-style/`（cp 整个仓库）
- Aider — `CONVENTIONS.md`（项目根单文件，把 SKILL.md 内容塞进去）

各平台手动安装命令在快速开始段已列。无需任何外部 multi-star-skill 工具。
## 贡献
参见 CONTRIBUTING.md。规则变更需同步更新 references/ 下相关 C 文件和 D-doxygen-comment-style.md 的交叉引用。
## 许可证
MIT

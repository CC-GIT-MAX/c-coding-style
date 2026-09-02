---
name: c-coding-style
description: Apply when writing, editing, reviewing, or generating C source or header files (`.c`, `.h`). Covers naming, layout, control flow, macros, memory, concurrency, MISRA C 2012, and Doxygen comment conventions. Make sure to use this skill whenever the user mentions C, embedded C, firmware, drivers, MISRA, or doxygen comments, even if they don't explicitly ask for code style. Do NOT trigger for C++ or Objective-C unless explicitly asked.
---

# C 代码风格与 Doxygen 注释规约

本 skill 合并了两份正本规约（一份主规约 + 一份注释规约），按需加载对应 references。

| 文件 | 加载时机 |
|---|---|
| [references/C_CODING_STYLE.md](references/C_CODING_STYLE.md) | 任何 `.c` / `.h` 写、改、审查、命名、缩进、控制流、宏、内存、并发、错误处理、MISRA 叠加 |
| [references/DOXYGEN_STYLE.md](references/DOXYGEN_STYLE.md) | 任何涉及 `@brief` / `@param` / `@return` / `@retval` / `@details` / `@file` 等 Doxygen 注释 |

正文一律以 references 中的两份正本为准；本 SKILL.md 只放"何时用 / 何时不用 / 章节速查 / 硬约束"。

## 触发与不触发

**触发**：
- 写、改、审查 `.c` / `.h`（命名、缩进、控制流、宏、内存、错误处理、Doxygen 注释等）
- 用户提到"嵌入式"、"固件"、"驱动"、"MISRA C"、"Autosar"、"doxygen 注释"
- 用户明确要求"按我们项目的 C 规约"生成代码

**不触发**（避免误命中）：
- C++ / Objective-C / 其它语言（除非用户明确要求套用 C 风格）
- 只读不改 `.c` / `.h` 的场景（生成调用图、词法分析等），按需只读 references，不强制走完整流程

## 关键硬约束（速记）

以下是正本里的强约束，速记版本在此。生成代码前必须自检；细节回 references 对应章节：

- 缩进 4 空格、禁用 tab；UTF-8 无 BOM；行尾 LF
- K&R 紧凑花括号；`if / for / while / switch` 一律带 `{}`；空块写 `{}` 不省略
- `if` 条件 Yoda 风格（`if (0U == x)`）；`switch` 必须有 `default`
- 头文件 `#ifndef / #define / #endif` 形式，**禁止** `#pragma once`
- Doxygen `@brief` **必须中文**；`.h` 中**禁止** `@details`；`@param[in|out|in,out]` 按形参顺序逐行写
- 编译警告 `-Wall -Wextra -Werror -Wshadow -Wpedantic` 必须零警告
- MISRA C 2012 叠加项（递归、运行时 malloc、char 算术、函数指针不兼容强转、unsigned/signed 混用比较等）在适用项目里强制

## 章节速查

读 `references/C_CODING_STYLE.md` 时按场景定位：

| 章节 | 看什么 |
|---|---|
| 0. 优先级与基线 | C99/C11、警告旗标、MISRA 触发条件 |
| 1-4. 缩进 / 行长 / 空行 / 花括号 | 排版 |
| 5. 命名约定 | 函数 / 类型 / 变量 / 宏 / 计数器 / 标志 / 模块前缀 / `__t` `__n` `__en` 后缀 |
| 6. 类型 | `<stdint.h>` 字面量后缀、显式转换、禁止 `float`→`int` 隐式 |
| 7. 头文件 | 命名、保护宏、自包含、不放定义 |
| 8. 变量 | 作用域、初始化、`const` / `volatile` / `restrict` |
| 9. 函数 | 形参顺序 ≤5、返回值约定、长度建议 ≤50 行 |
| 10. 控制流 | Yoda、`switch` default、循环层数、goto 单一出口 |
| 11. 注释 | 注释字符与 TODO/FIXME；Doxygen 标签以 DOXYGEN 规约为准 |
| 12. 文件位置 | `.h` / `.c` 段内顺序模板 |
| 13. `#include` 顺序 | 五组分类与空行 |
| 14-17. 宏 / 内存 / 并发 / 错误 | 多语句宏、malloc/free、ISR、错误码、`goto err_out` |
| 18. MISRA C 2012 叠加 | 汽车 / 安全项目触发 |

读 `references/DOXYGEN_STYLE.md` 时按对象定位：

| 章节 | 看什么 |
|---|---|
| 1. 适用范围 | 哪些对象必须 / 哪些不需要 |
| 2. 标准模板 | `.h` 模板 vs `.c` 模板；强约束（中文 `@brief`、禁止 `.h` 用 `@details`） |
| 3. 补充实例 | void 返回 / 无参 / `static` helper |
| 4. 头文件 vs `.c` | 注释放哪 |
| 5. 变量 / 状态机 / 结构体成员 | 中文注释规则 |
| 6. 自查清单 | 提交前逐项打勾 |

## 操作流程

1. 确认任务涉及 `.c` / `.h`（写 / 改 / 审查）。
2. 按场景决定读哪份 references（命名 / 排版 / 控制流 → C_CODING_STYLE；注释 → DOXYGEN_STYLE）。
3. 按章节速查定位章节，按硬约束自检。
4. 写完后回读代码，按 references 第 6 章（DOXYGEN）+ 各章"建议"项自查。

## 引用关系（维护时同步）

`references/C_CODING_STYLE.md` 第 0 章与第 11 章明文指向 `references/DOXYGEN_STYLE.md` 作为注释规约正本。任一份更新时同步另一边，避免引用断链。

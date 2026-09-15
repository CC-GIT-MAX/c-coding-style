---
name: c-coding-style
description: Apply when writing, editing, reviewing, or generating C source or header files (`.c`, `.h`). Covers naming, layout, control flow, macros, memory, concurrency, MISRA C 2012, and Doxygen comment conventions. Make sure to use this skill whenever the user mentions C, embedded C, firmware, drivers, MISRA, or doxygen comments, even if they don't explicitly ask for code style. Do NOT trigger for C++ or Objective-C unless explicitly asked.
---

# C Coding Style Skill

## Purpose

When writing, modifying, or reviewing C code (`.c` / `.h`), apply two project rule sets together:

- Style rules → `references/C00-baseline-formatting.md` / `C05-naming-types.md` / `C07-headers-variables-functions.md` / `C10-control-flow-files.md` / `C14-macros-memory-safety.md` (按主题分组，章节号 §0–§19)
- Comment rules → `references/D-doxygen-comment-style.md`

This SKILL.md is a thin entry point that summarizes the 25 hard rules and points you to the full documents in `references/`. For full context, read the relevant reference file.

## How to apply

1. On `.c` / `.h` file operations, read the relevant reference file in `references/` (按章节号) before generating or reviewing C code.
2. Apply style + comment rules together — they overlap on file layout and naming.
3. On review tasks, cross-check generated code against the rules in this file line by line.
4. Run `bash scripts/check.sh` before reporting done.

## Hard rules

Violations of these are bugs, not style preferences. Each rule carries a stable ID, a severity tag, and three examples: BAD (forbidden), GOOD (canonical form), and ACCEPTABLE (edge cases explicitly allowed — omitted if none).

### ID & severity

- IDs: `C-NN` from `references/C*.md`, `D-NN` from `references/D-doxygen-comment-style.md`.
- CRITICAL — violation breaks compilation, ABI, correctness, or safety; reject on review.
- HIGH — violation floods warnings, breaks portability, or contradicts a hard contract.
- MEDIUM — violation hurts consistency / readability but does not break the build.

### C — C 编码风格 (references/C00–C14)

#### C-01 [HIGH] 缩进：4 空格，禁止 tab

- BAD
  ```c
  void Foo(void) {
  \tif (x) {     // tab
  \t\tbar();   // tab
  \t}
  }
  ```
- GOOD
  ```c
  void Foo(void) {
      if (x) {
          bar();
      }
  }
  ```
- ACCEPTABLE — tab 一律禁用；编辑器关闭"按 tab 缩进"，tab 显示宽度设为 4。

#### C-02 [HIGH] 文件编码 UTF-8 无 BOM；行尾 LF

- BAD — 文件含 UTF-8 BOM 头；行尾混用 CRLF / LF
- GOOD — UTF-8 无 BOM，行尾 LF
- ACCEPTABLE — Windows 工具链强制 CRLF 时保留 CRLF；编辑器开启 `trim trailing whitespace`。

#### C-03 [HIGH] 花括号 K&R；单行也必须带 `{}`

- BAD
  ```c
  if (cond)
      do_a();
  if (cond) do_a();

  for (i = 0; i < n; i++);   // 裸分号
  ```
- GOOD
  ```c
  if (cond) {
      do_a();
  }

  for (i = 0; i < n; ++i) {
      work(i);
  }
  ```
- ACCEPTABLE — 无。单行也保留 `{}`；空语句块写 `{}`，不写 `;`。

#### C-04 [HIGH] `if` 条件 Yoda 风格（常量在左）

- BAD — `if (x == 0) { ... }` 误写 = 时编译器不警告
- GOOD — `if (0 == x) { ... }` 误写 = 时编译器立即报错
- ACCEPTABLE — 比较两侧都是变量 (如 `a == b`) 保持自然顺序，不需要反转。

#### C-05 [MEDIUM] 命名约定

- BAD
  ```c
  #define accBufSize 16
  typedef struct { int x; } watchtime_sig8;
  void get_aec1(void);
  static int ACC_Count;
  int RetryCnt;
  ```
- GOOD
  ```c
  #define ACC_BUF_SIZE (16U)
  typedef struct { uint8_t v; } WatchTime_Sig8_t;
  void AEC_GetAEC1(void);
  static int AEC_Count;
  int retry_cnt;
  ```
- ACCEPTABLE — 计数器后缀 `_tick` / `_Counter` / `_cnt`；数组索引用 PascalCase；布尔标志后缀 `_Flag` / `_flag`；老代码段允许 Hungarian snake_case，新代码禁止。

#### C-06 [CRITICAL] 头文件保护：#ifndef / #define / #endif，禁止 #pragma once

- BAD
  ```c
  #pragma once
  /* ... */
  ```
- GOOD
  ```c
  #ifndef _AEC_Function_H
  #define _AEC_Function_H

  /* ... */

  #endif /* _AEC_Function_H */
  ```
- ACCEPTABLE — 无。`#pragma once` 跨编译器不一致，禁止使用。

#### C-07 [CRITICAL] 头文件自包含

- BAD
  ```c
  /* Speed_Function.h */
  /* 没有 #include <stdint.h>，但下文直接用 uint16_t */
  uint16_t Speed_Get(void);
  ```
- GOOD
  ```c
  /* Speed_Function.h */
  #include <stdint.h>

  uint16_t Speed_Get(void);
  ```
- ACCEPTABLE — 无。每个 `.h` 必须独立可编译；`.c` 第一个项目内 include 必须是它对应的 `.h`。

#### C-08 [CRITICAL] switch 必有 default；case 必有 break

- BAD
  ```c
  switch (state) {
      case ACC_STATE_IDLE:
          ACC_OnIdle();   // 缺 break：fall-through
      case ACC_STATE_RUN:
          ACC_OnRun();
          break;
      /* 缺 default */
  }
  ```
- GOOD
  ```c
  switch (state) {
      case ACC_STATE_IDLE:
          ACC_OnIdle();
          break;
      case ACC_STATE_RUN:
          ACC_OnRun();
          break;
      default:
          /* no-op */
          break;
  }
  ```
- ACCEPTABLE — 确有需要的多 case 共用体（共用逻辑前）必须紧跟 `/* fall through */` 注释。

#### C-09 [MEDIUM] 循环：for(;;) 表示无限循环；嵌套 ≤ 3 层

- BAD — `while (1) { ... }`、`while (true) { ... }`、循环嵌套 4 层及以上
- GOOD
  ```c
  for (;;) { /* ... */ }
  for (i = 0; i < n; ++i) {
      for (j = 0; j < m; ++j) {
          for (k = 0; k < p; ++k) {
              work(k);
          }
      }
  }
  ```
- ACCEPTABLE — 局部 ≤ 3 层循环可接受；超出需抽取函数。

#### C-10 [CRITICAL] goto 仅用于单出口模式

- BAD
  ```c
  void Foo(void) {
      if (err) { goto outer_label; }   // 跨函数 goto
  }
  void outer(void) { ... }
  ```
- GOOD
  ```c
  ret_t Foo(void) {
      ret_t ok = RET_OK;
      /* ... */
      if (err) { ok = RET_ERR; goto err_out; }
      /* ... */
  err_out:
      Bar_Release();
      return ok;
  }
  ```
- ACCEPTABLE — 仅允许 `goto err_out;` / `goto cleanup;` 形式的单出口收尾；标签独占一行，小写。

#### C-11 [CRITICAL] 编译警告必须保持零警告

- BAD — 编译出现任何 `-Wall -Wextra -Werror -Wshadow -Wpedantic` 警告
- GOOD — 编译输出中无任何上述警告；`-Werror` 把警告升级为错误，必须清零
- ACCEPTABLE — 无。零警告是合并门槛。

#### C-12 [HIGH] C 标准：C99+（默认 C11）；允许 C11 关键字

- BAD — 使用 C89 风格隐式 `int` 返回；使用 `gets`
- GOOD — 默认按 C11 编译；可使用 `static_assert` / `_Generic` / `_Alignas`
- ACCEPTABLE — 老工具链必须停在 C99 时显式声明；不再支持 C89 及更早。

#### C-13 [CRITICAL] .h 内容：仅声明，禁定义

- BAD
  ```c
  /* foo.h */
  int g_counter = 0;
  static int s_local = 0;
  const int kTable[10] = {...};
  ```
- GOOD
  ```c
  /* foo.h */
  extern int g_counter;
  /* 不暴露 s_local */
  ```
- ACCEPTABLE — 短小的 `static inline` 函数可放 `.h`，但必须简短且不依赖模块私有状态（见 C-14）。

#### C-14 [HIGH] static inline 函数必须简短且无模块私有依赖

- BAD
  ```c
  /* foo.h */
  static inline uint32_t Foo_Get(void) {
      return s_local + 1;   // 依赖 .c 私有 static
  }
  ```
- GOOD
  ```c
  /* foo.h */
  static inline uint32_t Foo_Clz(uint32_t x) {
      return (x == 0U) ? 32U : __builtin_clz(x);
  }
  ```
- ACCEPTABLE — `static inline` 仅承载纯计算 / 短包装；任何涉及模块状态的逻辑必须放 `.c`。

#### C-15 [MEDIUM] 模块私有静态变量禁 Hungarian snake_case

- BAD
  ```c
  static u8 s_au8Ready = 0;
  static int acc_cnt;
  ```
- GOOD
  ```c
  static uint8_t WatchTime_MS = 0U;
  static int eep_count = 0;
  ```
- ACCEPTABLE — 维护老代码段可保留 `s_au8Foo` / `accdata` 旧风格以减少 churn，但新增符号不得沿用。

### D — Doxygen 注释 (references/D-doxygen-comment-style.md)

#### D-01 [CRITICAL] .h API：中文 @brief + @param[in|out] + @return（非 void）；禁 @details

- BAD
  ```c
  /** */
  ret_t Foo_Set(uint8_t id, uint32_t v);   // 无 @brief / @param / @return

  /**
   * @brief   设置参数。
   * @details 写入 flash 等待 5ms。   // .h 中禁止 @details
   */
  void Foo_Set2(uint8_t id, uint32_t v);
  ```
- GOOD
  ```c
  /**
   * @brief   设置指定 ID 的运行参数。
   *
   * @param[in]   id  参数编号
   * @param[in]   v   参数取值
   *
   * @return  ret_t    RET_OK: 写入成功
   *                   RET_ERR_PARAM: id 越界
   */
  ret_t Foo_Set(uint8_t id, uint32_t v);
  ```
- ACCEPTABLE — 无参数函数可仅写 `/** @brief   xxx    */`；`@details` 必须放 `.c`。

#### D-02 [HIGH] .c API：同 .h，可选 @details / @note / @warning / @see

- BAD
  ```c
  ret_t Foo_Set(uint8_t id, uint32_t v) { /* 缺 @brief */ }
  ```
- GOOD
  ```c
  /**
   * @brief   设置指定 ID 的运行参数。
   *
   * @details 先写影子寄存器，5ms 后提交 flash。
   *
   * @param[in]   id  参数编号
   * @param[in]   v   参数取值
   *
   * @return  ret_t    RET_OK / RET_ERR_PARAM / RET_ERR_BUSY
   *
   * @note    不可在 ISR 中调用。
   */
  ret_t Foo_Set(uint8_t id, uint32_t v) { /* ... */ }
  ```
- ACCEPTABLE — 简单函数可省 `@details`；有副作用、状态依赖或实现超 5 行时必须补 `@details`。

#### D-03 [HIGH] static helpers：至少一行 @brief

- BAD
  ```c
  static uint16_t prv_filter(uint16_t raw);   // 无任何注释
  ```
- GOOD
  ```c
  /** @brief  一阶 IIR 低通滤波电池电压（alpha=1/8）。 */
  static uint16_t prv_filter_bat_mv(uint16_t raw_mv);
  ```
- ACCEPTABLE — 无。

#### D-04 [HIGH] 注释字符规则

- BAD — 普通解释混用 `/** */`；实现说明写在 doxygen 块里
- GOOD
  ```c
  // 行内注释，默认首选。
  int g_dbg = 0;

  /*
   * 多行 / 块注释：函数实现说明、临时屏蔽代码、版权头。
   */

  /**
   * @brief   设置。
   */
  void Foo_Set(void);
  ```
- ACCEPTABLE — `/* ... */` 多用于函数头上的实现说明、临时屏蔽代码、版权头；`/** ... */` 仅供 Doxygen。

#### D-05 [CRITICAL] void 函数必须省略 @return

- BAD
  ```c
  /**
   * @brief   初始化电源管理模块。
   * @return  void    // 多余
   */
  void Power_Init(uint8_t cold_boot);
  ```
- GOOD
  ```c
  /**
   * @brief   初始化电源管理模块。
   *
   * @param[in]  cold_boot  1 = 冷启动（KAM 丢失），0 = 热启动（KAM 保留）
   *
   * @note    必须在 Scheduler_Init() 之前调用一次。
   */
  void Power_Init(uint8_t cold_boot);
  ```
- ACCEPTABLE — 无。

#### D-06 [HIGH] 同一函数只允许一个 @return

- BAD — 多个 `@return` 标签
- GOOD
  ```c
  /**
   * @brief   设置参数。
   *
   * @return  ret_t    RET_OK: 成功
   *                   RET_ERR_PARAM: 参数越界
   *                   RET_ERR_BUSY: 设备忙
   */
  ret_t Foo_Set(void);
  ```
- ACCEPTABLE — 多返回值允许在同一 `@return` 块内换行对齐；不得拆成多个 `@return`。

#### D-07 [HIGH] @param 顺序与形参声明顺序一致

- BAD — `@param` 顺序与函数形参顺序不一致
- GOOD — `@param[in] out` / `@param[in] len` / `@param[in] src` 与形参声明一致
- ACCEPTABLE — 无参数函数不写 `@param`。

#### D-08 [MEDIUM] 注释中文为主，技术名词 / API / 文件名 / 寄存器名保留英文

- BAD — `/** @brief   Init the power module. */`
- GOOD — `/** @brief   初始化电源管理模块。 */`
- ACCEPTABLE — `CAN ID` / `AEC1` / `Std_Types.h` / `RTE_CAR_CONFIG` 等技术名词保留英文。

#### D-09 [MEDIUM] 中文 @brief 用全角标点；返回值说明用半角冒号

- BAD — 中文 + 半角句号 / 半角冒号缺空格
- GOOD
  ```c
  /**
   * @brief   获取 AEC1 值。
   *
   * @return  ret_t    RET_OK: 获取成功
   *                   RET_ERR_PARAM: out 为空
   */
  ret_t AEC_Get1(uint32_t *out);
  ```
- ACCEPTABLE — 无。

#### D-10 [MEDIUM] TODO / FIXME 必须带负责人与日期

- BAD — `// TODO: 适配新平台` / `// FIXME: 这里会空指针`
- GOOD
  ```c
  // TODO(zhangsan): 2026-08-31 适配新平台
  // FIXME(lisi): 2026-09-01 待补 NULL 校验
  ```
- ACCEPTABLE — 临时屏蔽代码段必须注释原因；长期遗留的 TODO/FIXME 视为缺陷。

## Standard file layout

详细版见 references/C10 §12。

### .c file

1. File-level Doxygen header (@file / @brief / @details / @author / @date / @version)
2. Includes (按 §13 顺序分组：own .h → project std → RTE → other modules → C stdlib)
3. Macros (模块私有)
4. Types (模块私有)
5. Static Variables (带 /**< */ 行尾注释)
6. Static Function Prototypes
7. Public API
8. Static Helpers

Each section separated by 1 blank line and a `/*========== Section ==========*/` header. Public API order in `.c` mirrors `.h` declaration order.

### .h file

1. File-level Doxygen header
2. #ifndef / #define / #endif header guard (never #pragma once)
3. Includes
4. Macros
5. Types
6. Extern Variables
7. Public API (Doxygen here, no @details)

`.h` contains declarations only; definitions live in `.c`.

### Include order

详细版见 references/C10 §13。1=own .h, 2=project std, 3=RTE, 4=other modules, 5=C stdlib, 组间空 1 行。

## When to soften the rules

- Legacy code using Hungarian `s_au8Foo` or `accdata`-style names: keep the surrounding style, do not refactor unless explicitly asked.
- Vendor SDK / third-party: out of scope, no style edits.
- MISRA C 2012 overlay: when project declares Autosar / safety / medical / automotive context, add C-11 零警告 + references/C14 §18 rules on top of the defaults (no recursion, no runtime `malloc`, no plain `char` arithmetic, no function-pointer type punning, etc.).
- Soft suggestions (`references/C07-headers-variables-functions.md` §9.4, `references/C00-baseline-formatting.md` §2): 函数体 ≤ 50 行 / 圈复杂度 ≤ 10 / 嵌套 ≤ 4 层 / 行宽 120-180 — 软建议, 不强制。

## Build verification (before reporting done)

1. Run the project's build (Make / CMake / IDE) — confirm zero warnings under the project's warning flags (C-11).
2. Run `bash scripts/check.sh` — confirm all hard rules pass.
3. Spot-check 2–3 files against the 25 hard rules list above.
4. For MISRA-overlay projects, also run the MISRA checker (see references/C14 §18) and confirm zero violations.

## If something is unclear

When two rules conflict, prefer in this order:

1. The full reference file (`references/C00-baseline-formatting.md` / `C05-naming-types.md` / `C07-headers-variables-functions.md` / `C10-control-flow-files.md` / `C14-macros-memory-safety.md` / `D-doxygen-comment-style.md`) — this SKILL.md is a summary.
2. `references/C00` §0 优先级：可读性 > 一致性 > 个人偏好。
3. Ask the user before introducing a new convention.

## Scope declaration

This skill covers only C language. C++ / embedded C++ use a different rule set and are out of scope here.

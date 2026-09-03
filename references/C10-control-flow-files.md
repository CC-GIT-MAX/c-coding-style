# C 编码风格 — §10–§13 控制流 / 注释引用 / 文件位置 / #include

# 硬规则快速索引（详见各章节）：
# - C-04 [HIGH]     if 条件 Yoda 风格
# - C-08 [CRITICAL] switch 必有 default / case 必有 break
# - C-09 [MEDIUM]  循环 for(;;) + 嵌套 ≤ 3
# - C-10 [CRITICAL] goto 仅单出口模式

## §10 控制流

### §10.1 `if` / `switch`

- **`if` 条件采用 Yoda 风格**（`if (0 == x)`），把常量写在左侧
- `switch` 必须有 `default` 分支；`default` 内若无事可做，加 `/* no-op */` 或 `break;` 并注释
- 每个非空 `case` 必须以 `break;` / `return;` / `continue;` 结尾
- **禁止 fall-through**；确需 fall-through 必须加 `/* fall through */` 注释

### §10.2 `for` / `while` / `do-while`

- 无限循环统一 `for (;;)`，避免 `while(1)` 与 `while (true)` 混用
- 循环变量初始化在循环头：`for (uint8_t i = 0U; i < n; ++i)`
- 循环嵌套**不超过 3 层**

### §10.3 `goto`

- **仅允许单一函数出口模式**：出错时 `goto cleanup;`
- goto 标签命名：`cleanup:` / `err_out:`，标签独占一行，小写
- 禁止跨函数 `goto`；不在循环/条件块内跳入

## §11 注释

# 本章内容已外移：Doxygen 注释规约以 references/D-doxygen-comment-style.md 为准；本文档不重复。
# 本节仅重申与本规约其它章节强相关的注释原则。

### §11.1 注释字符

| 形态 | 用途 |
|---|---|
| `//` | 行内 / 单行注释（默认首选）；一行一句 |
| `/* ... */` | 多行 / 块注释：函数实现说明、临时屏蔽代码、版权头 |
| `/** ... */` | Doxygen 文档注释：专给公开 API 自动生成文档 |

### §11.2 TODO / FIXME

- TODO / FIXME 标注要带负责人与日期：`// TODO(zhangsan): 2026-08-31 适配新平台`
- 临时屏蔽代码段加注释说明原因；**不允许长期遗留**

## §12 文件位置约定（.c / .h 内符号顺序）

### §12.1 `.h` 文件推荐顺序

```
1. 文件头 doxygen 注释（@file / @brief / @details / @author / @date / @version）
2. #ifndef / #define 头文件保护宏
3. /*========== Includes（对外依赖）==========*/
4. /*========== Macros（对外宏 / #define）==========*/
5. /*========== Types（对外 typedef / enum / struct）==========*/
6. /*========== Extern Variables（对外变量声明）==========*/
7. /*========== Public API（对外函数声明，带 doxygen 注释）==========*/
8. #endif /* _ModuleName_H */
```

### §12.2 `.c` 文件推荐顺序

```
1. 文件头 doxygen 注释
2. /*========== Includes ==========*/（按 §13 顺序分组）
3. /*========== Macros（模块私有宏 / #define）==========*/
4. /*========== Types（模块私有 typedef / enum / struct）==========*/
5. /*========== Static Variables（static / 模块私有变量）==========*/
6. /*========== Global Variables（对外全局变量定义，带 extern 对应）==========*/
7. /*========== Static Function Prototypes（static helper 声明）==========*/
8. /*========== Public API（对外函数实现）==========*/
9. /*========== Static Helpers（static helper 实现）==========*/
```

### §12.3 顺序示例（AEC_Function.c）

- 源文档给出完整示例，展示文件头 / Includes / Macros / Types / Static Variables / Static Function Prototypes / Public API / Static Helpers 的排布与 `/**< */` 行尾注释用法

## §13 `#include` 顺序

# 按以下分组，组之间空 1 行（若全部在一组可省略空行）：

1. **本模块对应头文件**（自包含，如 `AEC_Function.c` 第一个包含 `AEC_Function.h`）
2. **同工程标准/平台头**（`Std_Types.h`、`Platform_Types.h`、`stdtype.h`）
3. **RTE/通信接口头**（`Rte_Com.h`、`RTE_CAR_CONFIG.h`、`RTE_COMM_CAN_*.h`）
4. **本工程其它模块头**（`Global_Settings.h` 等）
5. **C 标准库头**（`<stdint.h>`、`<string.h>`、`<stdbool.h>`、`<stddef.h>`）

| 项 | 规则 |
|---|---|
| 分隔 | 各组间空 1 行 |
| 自包含 | `.c` 第一个项目头必须是对应 `.h` |
| 段首注释 | 可加 `/*==========*/` 标注组边界 |

## 关键交叉引用

- Yoda 风格 → §10.1 → SKILL.md C-04 [HIGH]
- switch default / break / fall-through → §10.1 → SKILL.md C-08 [CRITICAL]
- 循环 for(;;) / 嵌套 ≤ 3 → §10.2 → SKILL.md C-09 [MEDIUM]
- goto 单出口 → §10.3 → SKILL.md C-10 [CRITICAL]
- TODO / FIXME owner+date → §11.2 → SKILL.md D-10 [MEDIUM]


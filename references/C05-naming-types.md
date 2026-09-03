# C 编码风格 — §5–§6 命名与类型

# 硬规则快速索引（详见各章节）：
# - C-05 [MEDIUM] 命名约定（UPPER_SNAKE_CASE 宏、PascalCase 类型、模块前缀）
# - C-12 [HIGH]  C99+ 标准（默认 C11）
# - C-15 [MEDIUM] 模块私有静态变量禁 Hungarian snake_case

## §5 命名约定

### §5.1 通用规则

| 类别 | 目标风格 | 例 |
|---|---|---|
| 宏 / `#define` / 枚举常量 | `UPPER_SNAKE_CASE` + 模块前缀 | `ACC_BUF_SIZE` |
| 类型（`typedef`） | `PascalCase` + `_t` 后缀 + 模块前缀 | `WatchTime_Sig8_t` |
| 函数 | `PascalCase` + 模块前缀 | `AEC_GetAEC1` |
| 模块私有静态变量 | `PascalCase` + 模块前缀 | `WatchTime_MS` |
| 全局变量（对外暴露） | `PascalCase` + 模块前缀 | `COMM_SW_Version` |
| 局部变量 / 形参 | `snake_case` | `buf_len` |
| 计数器 | `_tick` / `_Counter` / `_cnt` 后缀 | `RstTripHoldTick` |
| 数组索引 | `PascalCase` | `Ring_WriteIndex` |
| 布尔标志 | `_Flag` / `_flag` 后缀 | `airname_flag` |

### §5.2 类型后缀语义（双下划线）

- `__t` — 句柄 / 不透明指针（如 `EEP__tHandle`）
- `__n` — 数值 / 计数类型（如 `EEP__nJobCount`）
- `__en` — 枚举类型（如 `EEP__tenStatus`）

### §5.3 模块前缀

- 完整形式：`Speed` / `AEC` / `AFC` / `WatchTime`（首字母大写，后续小写）
- 缩写：`SPD` / `ACC` / `EPM`（全大写）
- 新模块必须使用 PascalCase + 模块前缀；沿用 `Module_Verb[Object]` 形式

### §5.4 函数命名

| 场景 | 规则 | 例 |
|---|---|---|
| 模块公共 API | `Module_VerbObject` PascalCase | `AEC_GetAEC1` |
| 模块初始化 | `Module_Init` | `Eeprom_Task_Init()` |
| 模块主处理 | `Module_Function` | `AEC_Function()` |
| 私有 helper | `static` + PascalCase + 模块前缀 | `static void AEC_InitOne(...)` |

### §5.5 旧工程兼容（仅老代码段允许）

- `s_au8Shadow[]` / `s_u8Ready` 等 Hungarian snake_case 仅出现在维护老代码段
- `acc` / `accdata` 前缀 + snake_case 同理
- 新代码**禁止**沿用上述旧风格

## §6 类型

### §6.1 平台宽度类型

| 用途 | 类型 |
|---|---|
| 平台定宽整数 | `<stdint.h>` 的 `uint8_t` / `int8_t` / `uint16_t` / `int32_t` / `uint64_t` |
| 平台无关 size | `size_t` / `ssize_t`（配 `<stddef.h>`） |
| 布尔 | `<stdbool.h>` 的 `bool`；**禁止自定义 `BOOL` / `BOOLEAN`** |
| 浮点 | C 标准 `float` / `double`；嵌入式默认不用 `double`（除非确认 FPU） |

### §6.2 字面量后缀

| 类型 | 后缀 | 例 |
|---|---|---|
| `unsigned` | `U` / `u` | `0U`、`0xFFu` |
| `long` | `L` | `0L` |
| `unsigned long` | `UL` | `0UL` |
| `long long` | `LL` | `0LL` |
| `unsigned long long` | `ULL` | `0ULL` |
| `float` | `f` / `F` | `1.0f` |
| `size_t` | 依赖宏或强转 | `(size_t)42U` |

- 禁止未加后缀的字面量参与隐式类型转换推导

### §6.3 类型转换

- 整数 ↔ 整数：优先隐式提升；必须显式时用括号强转并配注释
- `void*` ↔ 其他指针：`memcpy` 或显式强转，避免 `(void*)x` 之外的隐式转换
- **禁止 `float` 直接隐式转 `int`**；必须显式并说明舍入策略
- 函数指针强转**必须验证原型一致后再转**

## 关键交叉引用

- 命名总体 → §5.1 → SKILL.md C-05 [MEDIUM]
- 双下划线类型后缀 → §5.2 → SKILL.md C-05 [MEDIUM]
- 旧风格兼容 → §5.5 → SKILL.md C-15 [MEDIUM]


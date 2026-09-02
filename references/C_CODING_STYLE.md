# C 语言编码风格与要求规约

> 本规约作为新项目的独立基线,不依赖任何历史规约文件。
> 工程内出现本规约未明确的风格冲突时,以本文档为准。
> 注释(Doxygen `@brief / @param / @return / @retval / @note / @details / @file` 等)具体规约,以 `C:\Users\25237\agents_document\doxygen_style\DOXYGEN_STYLE.md` 为准,本文档不重复。

---

## 0. 优先级与基线

- **风格优先级**:可读性 > 一致性 > 个人偏好。
- **兼容性目标**:C99 及以上,默认 C11。允许 `static_assert`、`_Generic`、`_Alignas`。
- **编译器警告**:`-Wall -Wextra -Werror -Wshadow -Wpedantic` 必须开启并保持零警告。
- **防御性叠加**:涉及 Autosar / 安全 / 医疗 / 汽车等场景的项目,在本文档之上叠加 MISRA C 2012(详见第 18 章)。

---

## 1. 字符、缩进与排版

### 1.1 缩进
- **强制 4 空格缩进,禁止使用 tab**。
- 函数体、控制流、宏续行、表格化对齐列、枚举成员对齐全部使用空格。
- 编辑器必须关闭"按 tab 缩进",tab 显示宽度设为 4,避免混用。

### 1.2 大括号缩进
- 大括号内的语句相对外层关键字/函数声明**缩进 4 列**。
- 函数体起始语句以 4 空格开头,例如:
  ```c
  void WatchTime_Init(void) {
      /* 4 空格缩进 */
  }
  ```
- 多行宏续行与开括号 `(` 之后对齐。
- 表格化数据(函数参数表、状态机表、配置数组)用空格手动对齐列。

### 1.3 文件编码与行尾
- **文件编码**:UTF-8,**无 BOM**。
- **行尾**:LF;CRLF 仅在 Windows 强制工具链下保留。
- **保存时去除行尾空白**;编辑器开启 `trim trailing whitespace`。

---

## 2. 行长度与换行

| 场景 | 上限 |
|---|---|
| 全中文 | 每行 < 120 字符 |
| 全英文 | 每行 < 180 字符 |
| 中英混合 | 每行 < 150 字符 |

超长行优先在运算符之后、逗号之后、函数参数之间换行;续行与首行对齐到能一眼看出从属关系的位置。禁止靠横向滚动阅读代码。

---

## 3. 空行

- **函数之间:留 2 行空行**。
- **逻辑块之间:1 行空行**;可用 `/* Section name */` 分节注释。
- 文件开头允许 1-2 行空行后再写 `#include`。
- 不要在 `return;` 这种单行末尾再补空行。

---

## 4. 花括号风格

- 采用 **K&R 紧凑风格**:开括号与关键字/函数名同行,闭括号独占一行。
- **即使单行语句也保留花括号**,统一风格,便于后续插入断点和维护。
- `if / else / for / while / do / switch` 一律带 `{}`;空语句块写作 `{}`(不省略成 `;`)。
  ```c
  if (cond) {
      do_a();
  } else {
      do_b();
  }

  for (i = 0; i < n; ++i) {
      work(i);
  }
  ```
- `do { ... } while (cond);` 中的 `while` 与闭括号同行,尾部分号不省略。

---

## 5. 命名约定

### 5.1 通用规则

| 类别 | 目标风格 | 示例 |
|---|---|---|
| 宏 / `#define` 常量 / 枚举常量 | `UPPER_SNAKE_CASE`,前缀 = 模块名 | `ACC_BUF_SIZE`、`ACC__nModeOff` |
| 类型(`typedef struct/enum`) | `PascalCase` + `_t` 后缀,模块前缀 | `WatchTime_Sig8_t`、`EepMem_Handle_t` |
| 函数 | `PascalCase` + 模块前缀 | `AEC_GetAEC1`、`WatchTime_Init` |
| 模块私有静态变量 | `PascalCase` + 模块前缀 | `WatchTime_MS` |
| 全局变量(对外暴露) | `PascalCase` + 模块前缀 | `COMM_SW_Version` |
| 局部变量 / 函数形参 | `snake_case` | `buf_len`、`retry_cnt` |
| 计数器 | `_tick` / `_Counter` / `_cnt` 后缀 | `RstTripHoldTick`、`unchanged_tick` |
| 数组索引 | `WriteIndex` / `ReadIndex`(PascalCase) | `Ring_WriteIndex` |
| 布尔标志 | `_Flag` / `_flag` 后缀 | `WatchTime_Sign_Flag`、`airname_flag` |

### 5.2 类型后缀语义(双下划线形式)
- `__t` — 句柄 / 不透明指针(如 `EEP__tHandle`)。
- `__n` — 数值 / 计数类型(如 `EEP__nJobCount`)。
- `__en` — 枚举类型(状态机、错误码,如 `EEP__tenStatus`)。

### 5.3 模块前缀
- 完整名称(首字母大写,后续小写):`Speed`、`AEC`、`AFC`、`WatchTime`。
- 或全大写缩写:`SPD`、`ACC`、`EPM`。
- **新模块必须使用 PascalCase + 模块前缀**,沿用 `Module_Verb[Object]` 形式。

### 5.4 函数命名

| 场景 | 规则 | 示例 |
|---|---|---|
| 模块公共 API | `Module_VerbObject` PascalCase | `AEC_GetAEC1`、`AFC_ResetAll`、`SrvRmn_GetDstToSrv` |
| 模块初始化 | `Module_Init` | `Eeprom_Task_Init()` |
| 模块主处理 | `Module_Function` | `AEC_Function()` |
| 私有 helper | `static` 限定 + PascalCase + 模块前缀 | `static void AEC_InitOne(...)` |

### 5.5 旧工程兼容写法(仅在引用老代码处使用,不鼓励新代码使用)
- `s_au8Shadow[]`、`s_u8Ready` 这类 Hungarian snake_case 仅出现在维护老代码段。
- `acc`、`accdata` 这类前缀 + snake_case 仅出现在维护老代码段。
- 新代码禁止混用上述旧风格。

---

## 6. 类型

### 6.1 平台宽度类型

| 用途 | 类型 |
|---|---|
| 平台定宽整数 | `<stdint.h>` 的 `uint8_t` / `int8_t` / `uint16_t` / `int32_t` / `uint64_t` |
| 平台无关 size | `size_t` / `ssize_t`(配合 `<stddef.h>`) |
| 布尔 | `<stdbool.h>` 的 `bool`,**禁止自定义 `BOOL` / `BOOLEAN`** |
| 浮点 | C 标准 `float` / `double`;不要在嵌入式里用 `double` 除非确认 FPU |

### 6.2 字面量后缀

| 类型 | 后缀 | 例 |
|---|---|---|
| `unsigned` | `U` / `u` | `0U`、`0xFFu` |
| `long` | `L` | `0L` |
| `unsigned long` | `UL` | `0UL` |
| `long long` | `LL` | `0LL` |
| `unsigned long long` | `ULL` | `0ULL` |
| `float` | `f` / `F` | `1.0f` |
| `size_t` | 依赖宏或强转 | `(size_t)42U` |

**禁止未加后缀的字面量参与隐式类型转换推导**。

### 6.3 类型转换

- 整数 ↔ 整数:优先隐式提升;必须显式时用括号强转并配注释。
- `void*` ↔ 其他指针:`memcpy` 或显式强转,避免 `(void*)x` 之外的隐式转换。
- **禁止 `float` 直接隐式转 `int`**;必须显式并说明舍入策略。
- 函数指针强转**必须验证原型一致后再转**。

---

## 7. 头文件

### 7.1 命名

| 类别 | 规则 | 例 |
|---|---|---|
| 头文件 | `PascalCase` + `_Function.h`(模块名_含义) | `Speed_Function.h` |
| 源文件 | 与对应头同名,`.c` 后缀 | `Speed_Function.c` |

### 7.2 头文件保护宏
- **必须使用 `#ifndef / #define / #endif` 形式**;**禁止 `#pragma once`**。
- 命名规则:目标格式 `_ModuleName_H`(驼峰 + 下划线包围)。
- `#endif` 末尾**必须**写 `/* _ModuleName_H */`,与 `#ifndef` 宏名一致。
  ```c
  #ifndef _AEC_Function_H
  #define _AEC_Function_H

  /* ... */

  #endif /* _AEC_Function_H */
  ```

### 7.3 自包含
- 每个头文件**必须能独立编译**:`#include` 它直接用到的所有依赖,不依赖"先 include 谁"。
- `.c` 第一个项目内 include 必须是对应 `.h`。

### 7.4 头文件内容范围

| 允许 | 禁止 |
|---|---|
| 宏(`#define`、`enum`) | 非 `static inline` 的函数实现 |
| `typedef` / 类型声明 | 大段数据(数组、`const` 表) |
| 外部 API `extern` 声明 | 运行期分配、状态变量定义 |
| `extern` 变量声明 | 模块私有符号(`static` 函数/变量) |
| 短小的 `static inline` 定义 | 跨平台宏(放到 `<Project>_Config.h`) |

`static inline` 函数可放在 `.h`,但**必须简短且不依赖模块私有状态**。

### 7.5 包含路径
- 包含路径通过构建系统(Makefile / CMakeLists.txt / IDE 工程)管理。
- **禁止在源文件里 `#include "../foo.h"`**;模块间相对路径必须规范化。

---

## 8. 变量

### 8.1 作用域与生命周期

| 类型 | 规则 |
|---|---|
| 模块私有 | `static` 限定,放在文件开头或紧邻使用函数前;带 `/**< */` 行尾注释 |
| 全局(对外暴露) | 放在 `.c` 中并通过 `.h` 用 `extern` 暴露;**不允许在 `.h` 直接定义** |
| 局部 | 函数体最前面集中声明;C99 允许在块内声明,但要避免可读性下降 |

### 8.2 初始化
- **优先 C99 指定初始化器**:`{.field = value, .next = value2}`。
- **全零初始化**用 `{0}` 或 `{0U}`;数组尤其注意正确尺寸。
- `static` 变量若依赖运行时状态,**禁止默认零值后忘了显式初始化**。

### 8.3 `const` / `volatile` / `restrict`
- 只读形参加 `const`;指针形参尽量 `const T*` 或 `T* const` 明确意图。
- 硬件寄存器、ISR / 线程间共享标志加 `volatile`。
- 性能关键路径允许 `restrict`,但需要解释依据。

---

## 9. 函数

### 9.1 声明
- 所有外部 API 必须有原型声明在 `.h`。
- 函数声明**带形参名**(不只是类型),便于阅读和 doxygen 提取。
- 函数不超过一屏(约 50 行);过长拆函数。

### 9.2 参数顺序与数量
- **输入参数在前,输出参数(指针)在中后,长度参数紧邻被描述的缓冲区**。
- 参数数量**不超过 5 个**;超过则用结构体打包。
- 形参命名与 `.h` 声明保持一致。

### 9.3 返回值
- 主流风格:**`void` 返回**,函数内通过输出参数(指针)写结果。
- 需要失败语义时返回 `bool` / `uint8_t`,约定:
  - `1`(`TRUE` / `true`)= **成功**。
  - `0`(`FALSE` / `false`)= **失败**。
- 若模块有状态变量,失败时同步设置:`s_Jobs[i].State = EEP__nStatusError`。
- 示例:`AccRingBuffer_Pop` 返回 `1` = 成功,`0` = 队列空。

### 9.4 函数长度与复杂度

| 指标 | 建议上限 |
|---|---|
| 函数体行数 | ≤ 50 行 |
| 圈复杂度 | ≤ 10(超过拆函数或重写状态机) |
| `if` 嵌套层数 | ≤ 4 层 |

> 注:上述指标**仅作为建议**,不强制要求。评审中可作为拆分参考,但不作为拒绝合并的唯一理由。

---

## 10. 控制流

### 10.1 `if` / `switch`
- **`if` 条件采用 Yoda 风格**(`if (0 == x)`),把常量写在左侧,便于编译器在误写 `=` 时报 warning。
- `switch` 必须有 `default` 分支;`default` 内若无事可做,加 `/* no-op */` 或 `break;` 并注释。
- 每个非空 `case` 必须以 `break;` / `return;` / `continue;` 结尾。
- **禁止 fall-through**;确需 fall-through 必须加 `/* fall through */` 注释。
  ```c
  if (0U == s_AECState) {
      s_AECState = AEC__tenStateRun;
  }

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

### 10.2 `for` / `while` / `do-while`
- 无限循环统一 `for (;;)`,避免 `while(1)` 与 `while (true)` 混用。
- 循环变量初始化在循环头:
  ```c
  for (uint8_t i = 0U; i < n; ++i) {
      /* ... */
  }
  ```
- 循环嵌套**不超过 3 层**。

### 10.3 `goto`
- **仅允许单一函数出口模式**:出错时 `goto cleanup;`。
- goto 标签命名:`cleanup:` / `err_out:`,标签独占一行,小写。
- 禁止跨函数 `goto`;不在循环/条件块内跳入。
  ```c
  void Foo(void) {
      ret_t ok = RET_OK;
      /* ... */
      if (err) {
          ok = RET_ERR;
          goto err_out;
      }
      /* ... */
  err_out:
      Bar_Release();
      return ok;
  }
  ```

---

## 11. 注释

> **注释规约以** `C:\Users\25237\agents_document\doxygen_style\DOXYGEN_STYLE.md` **为准**,包括但不限于:`@brief` / `@param` / `@param[in]` / `@param[out]` / `@param[in,out]` / `@return` / `@retval` / `@note` / `@details` / `@file` 等标签使用规则、文件头与函数注释模板、`.h` 与 `.c` 注释重复要求。
> 本节仅重申与本规约其它章节强相关的注释原则。

### 11.1 注释字符

| 形态 | 用途 |
|---|---|
| `//` | 行内 / 单行注释(默认首选);一行一句 |
| `/* ... */` | 多行 / 块注释:函数实现说明、临时屏蔽代码、版权头 |
| `/** ... */` | Doxygen 文档注释:专给公开 API 自动生成文档;普通解释不要混用,避免工具误抓 |

### 11.2 TODO / FIXME
- TODO / FIXME 标注要带负责人与日期:`// TODO(zhangsan): 2026-08-31 适配新平台`。
- 临时屏蔽代码段加注释说明原因;**不允许长期遗留**。

---

## 12. 文件位置约定(.c / .h 内符号顺序)

> 本节规定 .c 与 .h 文件内部"宏 / 类型 / 变量 / 函数"等的相对位置,保证全工程一致,便于 review。

### 12.1 `.h` 文件推荐顺序

```
1. 文件头 doxygen 注释(@file / @brief / @details / @author / @date / @version)
2. #ifndef / #define 头文件保护宏
3. /*========== Includes(对外依赖) ==========*/
   - 必要的对外头(如 stdint.h、Std_Types.h)
4. /*========== Macros(对外宏 / #define) ==========*/
5. /*========== Types(对外 typedef / enum / struct) ==========*/
6. /*========== Extern Variables(对外变量声明) ==========*/
7. /*========== Public API(对外函数声明,带 doxygen 注释) ==========*/
8. #endif /* _ModuleName_H */
```

说明:
- `.h` 内**只放声明,不放定义**;变量定义放 `.c`。
- 顺序上"对外宏 → 对外类型 → 对外变量 → 对外函数",依赖关系单向。
- 私有符号(`static` 变量/函数、私有宏)不要进 `.h`。

### 12.2 `.c` 文件推荐顺序

```
1. 文件头 doxygen 注释(@file / @brief / @details / @author / @date / @version)
2. /*========== Includes ==========*/
   按第 13 章顺序分组,各组间空 1 行
3. /*========== Macros(模块私有宏 / #define) ==========*/
4. /*========== Types(模块私有 typedef / enum / struct) ==========*/
5. /*========== Static Variables(static / 模块私有变量) ==========*/
6. /*========== Global Variables(对外全局变量定义,带 extern 对应) ==========*/
7. /*========== Static Function Prototypes(static helper 声明) ==========*/
8. /*========== Public API(对外函数实现) ==========*/
9. /*========== Static Helpers(static helper 实现) ==========*/
```

详细说明:
- **`static` 私有变量集中在文件开头**(第 5 段),带 `/**< */` 行尾注释,便于一眼看到模块状态。
- **私有宏 / 私有类型集中在静态变量之前**,避免私有类型与使用它的变量穿插。
- **私有 helper 函数实现放文件末尾**(`Static Helpers` 段),与公共 API 物理隔离。
- **公共 API 实现顺序**与 `.h` 中声明顺序保持一致;读者对照 `.h` 即可定位实现。
- 各段之间**留 1 行空行**;段首必须加 `/*========== Section ==========*/` 注释。

### 12.3 顺序示例(AEC_Function.c)

```c
/**
 * @file    AEC_Function.c
 * @brief   平均电耗(AEC)模块主逻辑
 * @details 处理小计里程 AEC1/AEC2 的累加与清零,需求见 REQ-AEC-001
 * @author  zhangsan
 * @date    2026-08-31
 * @version 1.0.0
 */

/*========== Includes ==========*/
#include "AEC_Function.h"

#include "Platform_Types.h"
#include "Std_Types.h"

#include "Rte_Com.h"
#include "RTE_CAR_CONFIG.h"

#include "Global_Settings.h"

#include <stdint.h>
#include <string.h>

/*========== Macros ==========*/
#define AEC_BUF_SIZE         (16U)
#define AEC_RESET_HARD_KEY   (0x01U)

/*========== Types ==========*/
typedef enum : uint8_t {
    AEC__tenStateIdle = 0U,
    AEC__tenStateRun,
    AEC__tenStateError,
    AEC__tenStateCount
} AEC__tenState;

/*========== Static Variables ==========*/
static AEC__tenState s_AECState = AEC__tenStateIdle;  /**< 模块当前状态 */
static uint32_t      s_AECTick  = 0U;                /**< 主循环计数 */

/*========== Static Function Prototypes ==========*/
static void AEC_InitOne(uint8_t id);

/*========== Public API ==========*/

/**
 * @brief  AEC1 清零接口(小计里程中平均电耗)
 * @param  rst_type  清零类型:
 *         - 0x01: 方控硬按键清零
 *         - 0x02: 行驶距离超过最大值
 */
void AEC_Reset1(uint8_t rst_type) {
    if (AEC_RESET_HARD_KEY == rst_type) {
        s_AECState = AEC__tenStateIdle;
        s_AECTick  = 0U;
    }
}

/*========== Static Helpers ==========*/
static void AEC_InitOne(uint8_t id) {
    /* 私有 helper,仅本文件可见 */
    (void)id;
}
```

---

## 13. `#include` 顺序

按以下分组,**组之间空一行**(若全部在一组可省略空行):

1. **本模块对应头文件**(自包含,例如 `AEC_Function.c` 第一个包含 `AEC_Function.h`)。
2. **同工程标准/平台头**(`Std_Types.h`、`Platform_Types.h`、`stdtype.h`)。
3. **RTE/通信接口头**(`Rte_Com.h`、`RTE_CAR_CONFIG.h`、`RTE_COMM_CAN_*.h`)。
4. **本工程其它模块头**(`Global_Settings.h` 等)。
5. **C 标准库头**(`<stdint.h>`、`<string.h>`、`<stdbool.h>`、`<stddef.h>`)。

| 项 | 规则 |
|---|---|
| 分隔 | 各组间空 1 行 |
| 自包含 | `.c` 第一个项目头必须是对应 `.h` |
| 段首注释 | 可加 `/*==========*/` 标注组边界 |

---

## 14. 预处理宏

### 14.1 多语句宏
- 多语句宏必须用 `do { ... } while (0)` 包裹,使宏可以安全用在 `if` 单语句位置。
  ```c
  #define ACC_LOG_ERR(fmt, ...)            \
      do {                                  \
          LOG_LOCK();                       \
          fprintf(stderr, fmt "\n", ##__VA_ARGS__); \
          LOG_UNLOCK();                     \
      } while (0)
  ```

### 14.2 表达式宏
- 所有参数必须加括号;整个表达式必须加括号。
- **访问多次的参数必须先求值一次到局部变量**,避免副作用。
  ```c
  #define ACC_MAX(a, b)  (((a) > (b)) ? (a) : (b))
  ```

### 14.3 条件编译
- `#if` 条件必须清晰、可注释;**不要写三层嵌套的复杂布尔**。
- 平台/特性宏集中在 `<Project>_Config.h`,**模块不要自己探测工具链**。
- `#ifdef` 守卫的代码段要在**文件头注释**里说明开启条件。

---

## 15. 内存与资源

| 场景 | 规则 |
|---|---|
| `malloc` / `calloc` / `realloc` | 返回值必须 `NULL` 检查 |
| `free` | 释放后置指针为 `NULL`,避免悬空 |
| 配对 | `malloc` 与 `free` 在同一函数层;**不跨模块传递 ownership** |
| 数组 | 优先静态分配;动态数组用 C99 VLA 仅在栈帧明确且尺寸受控时使用 |
| 字符串 | 优先 `snprintf`;**禁止 `gets`**、禁止 `sprintf` 到固定缓冲 |
| 缓冲区尺寸 | 用 `sizeof(buf) / sizeof(buf[0])` 或显式常量;**避免魔数** |

---

## 16. 并发 / 中断

- ISR(中断服务例程)只做:**清中断、读/写硬件寄存器、设置标志、置事件**;不做复杂运算。
- 中断与主循环共享变量加 `volatile`,视场景加锁或用原子类型(`<stdatomic.h>`)。
- 临界区尽量短;能延迟到任务层的处理延后做。
- `printf` / `malloc` / 长循环等不可重入函数**禁止在正式版软件 ISR 中调用**(开发调试期可临时使用,但提交前必须移除或加 `#ifdef DEBUG` 保护)。
- 寄存器 / 中断向量集中放在 `hal/` 或 `bsp/` 层,模块**不直接打硬件地址**。

---

## 17. 错误处理

- 函数返回错误码时,**调用方必须检查**;不检查视为 bug。
- 错误码命名:`Module__tenStatus` / `Module__nStatusXxx`,前缀模块名。
- 失败路径用 `goto err_out:` 统一释放与返回;不在每个 `if` 后嵌套清理。
- **断言**:`assert` 仅用于开发期不可能条件;生产路径用运行时检查 + 错误码。
- 不要默默吞错;错误必须可定位(日志、计数器、状态变量同步)。

---

## 18. 安全 / MISRA C 2012 叠加项(适用时启用)

启用 MISRA C 2012 的项目,以下条目为强制:

- 禁止递归。
- 禁止动态内存分配在汽车运行时路径(`malloc` 在启动期外禁用)。
- 禁止未限定字符类型(`char`)做算术;统一用 `uint8_t` / `int8_t`。
- 禁止函数指针赋值给不兼容类型。
- `switch` 必须有 `default`;`case` 必须以 `break` 结尾(见 10.1)。
- 所有指针使用前必须 `NULL` 检查(见 15、17 章)。
- 整型提升与符号性:**避免无符号 / 有符号混用比较**。

---

## 19. 修订记录

| 版本 | 日期 | 作者 | 变更说明 |
|---|---|---|---|
| 1.0.0 | 2026-08-31 | zhangsan | 初版发布;按用户原文要点整理,补全控制流、宏、关键字等基础项 |
| 1.1.0 | 2026-08-31 | zhangsan | 参考项目内 `C_CODING_STYLE.md` 整合:新增基线 / 编译警告 / 文件编码 / 字面量后缀 / 类型转换 / 头文件禁止项 / 参数顺序与数量 / 圈复杂度与嵌套层数 / fall-through 与 no-op default / `for(;;)` 与 goto 标签命名 / `@param[in/out]` / 条件编译 / 内存与资源 / 并发与中断 / 错误处理 / 可移植性 / 构建与警告 / 版本控制 / MISRA 叠加 / 范围声明 |
| 1.2.0 | 2026-08-31 | zhangsan | 按用户修订:9.4 函数长度与复杂度标注"建议不强制";10.1 if 改 Yoda 风格;15 章 ISR 措辞限定为"禁止在正式版软件 ISR 中调用";11 章注释规约指向外部 DOXYGEN_STYLE.md;删除 18/19/21 章(构建与警告 / 版本控制 / 不在本规约范围);新增第 12 章文件位置约定(.c/.h 符号顺序) |

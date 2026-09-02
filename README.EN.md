# c-coding-style
C coding standards and Doxygen comment conventions. Combines a general baseline with MISRA C 2012 overlays, targeted at C teams in embedded / safety / automotive industries.
![License](https://img.shields.io/badge/license-MIT-blue)
![Stars](https://img.shields.io/github/stars/USER/c-coding-style)
![Last commit](https://img.shields.io/github/last-commit/USER/c-coding-style)
![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blue)
![Codex](https://img.shields.io/badge/Codex-compatible-green)
![Hermes](https://img.shields.io/badge/Hermes-compatible-lightgrey)
![Cursor](https://img.shields.io/badge/Cursor-compatible-purple)
## What is this
An agent skill (Claude Code / Codex / Hermes / Cursor, etc.) for C coding standards. Combines a main standards document with Doxygen comment conventions, covering naming / types / control flow / macros / memory / concurrency / error handling / MISRA C 2012 overlays. Bundled with .clang-format for layout and scripts/check.sh for self-check.
## Why use it
- Before: agent generates C code with inconsistent style, ad-hoc comments, and endless code review arguments
- After: agent strictly follows the conventions; .clang-format auto-formats; scripts/check.sh runs before commit
- Fits: C teams in embedded / automotive / safety / medical; also works as a reference for general C projects
- Does not fit: C++ / Objective-C / Rust / Go unless explicitly requested
Differentiator: general baseline + MISRA C 2012 overlays + Doxygen conventions, three-in-one with no incumbent.
## Quick start
Claude Code:
cp -r ~/.claude/skills/c-coding-style ~/.claude/skills/c-coding-style
Codex:
cp -r ~/.codex/skills/c-coding-style ~/.codex/skills/c-coding-style
Hermes (via multi-star-skill sync-hermes.py):
python ~/.codex/skills/multi-star-skill/assets/sync-hermes.py --verbose
Cursor / Kilo Code / Windsurf / OpenCode / Augment / Antigravity / Aider:
bash ~/.codex/skills/multi-star-skill/assets/platform-conversion.sh --skill . --tool all --out integrations/
bash ~/.codex/skills/multi-star-skill/assets/platform-install.sh --tool cursor --target /path/to/your/project
Repeat --tool argument for each platform until all are installed
Verify (all platforms):
bash scripts/check.sh
## Main features
- Naming conventions (PascalCase types with double-underscore suffixes, UPPER_SNAKE_CASE macros, snake_case variables with module prefix)
- Layout (4-space indent, K&R compact braces, Yoda-style if)
- Types and literals (fixed-width integers, U/L/LL/f suffixes)
- Header guards (traditional ifndef form, no pragma once)
- Control flow (Yoda, switch default, single-exit goto)
- Macros (multi-statement macros use do-while-0)
- Memory (malloc NULL check, free sets pointer to NULL, static preferred)
- Concurrency (ISR kept short, shared variables get volatile / atomic types)
- Error handling (goto err_out pattern, error code naming)
- MISRA C 2012 overlays
- Doxygen comments (Chinese @brief, .h bans .d, @param direction tags)
## Comparison with alternatives
| Dimension | This skill | jdubray/puffin | xwos/XWOS | williamzujkowski/standards |
|---|---|---|---|---|
| Coverage | 18 chapters full stack | Naming only | Naming+types+error+comments+format+section attrs | Multi-language standards set |
| Tooling | .clang-format + scripts/check.sh | None | .clang-format | None |
| Multi-agent | 10 platforms | Claude only | Project-internal only | Claude only |
| Comment standard | Separate references | None | Embedded section | None |
| MISRA C 2012 | Chapter 18 overlay | None | Mandatory + suppression list | None |
| Scope | General baseline + MISRA overlay | General C | Embedded RTOS specific | Multi-language |
## Documentation
- SKILL.md - trigger conditions + workflow (agent load entry)
- references/C_CODING_STYLE.md - 18-chapter main standard
- references/DOXYGEN_STYLE.md - Doxygen comment standard
- .clang-format - layout self-check config
- scripts/check.sh - self-check script
- plugin.json - Codex plugin metadata
- LICENSE - MIT license
## Bundled tools
- .clang-format - layout self-check
- scripts/check.sh - standard self-check
- references/ - progressive disclosure detailed standards
## Supported agents
- Claude Code (~/.claude/skills/c-coding-style/)
- Codex CLI (~/.codex/skills/c-coding-style/)
- Hermes Agent (synced via multi-star-skill sync-hermes.py)
- Cursor (.cursor/rules/c-coding-style.mdc)
- Kilo Code (.kilocode/rules/c-coding-style.md)
- Windsurf (.windsurf/skills/c-coding-style/SKILL.md)
- OpenCode (.opencode/skills/c-coding-style/SKILL.md)
- Augment (.augment/skills/c-coding-style/SKILL.md)
- Antigravity (~/.gemini/antigravity/skills/c-coding-style/)
- Aider (CONVENTIONS.md single file)
Multi-platform conversion: use multi-star-skill platform-conversion.sh + platform-install.sh.
## Contributing
See CONTRIBUTING.md. Rule changes must update references/C_CODING_STYLE.md and references/DOXYGEN_STYLE.md cross-references in sync.
## License
MIT


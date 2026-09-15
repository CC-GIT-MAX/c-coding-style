# c-coding-style
C coding standards and Doxygen comment conventions. Combines a general baseline with MISRA C 2012 overlays, targeted at C teams in embedded / safety / automotive industries.
![License](https://img.shields.io/badge/license-MIT-blue)
![Stars](https://img.shields.io/github/stars/CC-GIT-MAX/c-coding-style)
![Last commit](https://img.shields.io/github/last-commit/CC-GIT-MAX/c-coding-style)
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

For anyone cloning from GitHub, only two steps:

1. Get the repo
   git clone https://github.com/CC-GIT-MAX/c-coding-style.git
   cd c-coding-style

2. Install into the target agent's skills directory (pick one)

   Claude Code:
   mkdir -p ~/.claude/skills && cp -r . ~/.claude/skills/c-coding-style/

   Codex:
   mkdir -p ~/.codex/skills && cp -r . ~/.codex/skills/c-coding-style/

   Windows PowerShell:
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.codex\skills\c-coding-style"
   Copy-Item -Recurse -Force -Path .\* -Destination "$env:USERPROFILE\.codex\skills\c-coding-style\"

3. Verify
   bash scripts/check.sh

See per-agent sections below for full install notes.
## Main features
- 25 hard rules (each with stable ID + severity + BAD / GOOD / ACCEPTABLE examples)
- Naming conventions (PascalCase types with double-underscore suffixes, UPPER_SNAKE_CASE macros, snake_case variables with module prefix)
- Layout (4-space indent, K&R compact braces, Yoda-style if)
- Types and literals (fixed-width integers, U/L/LL/f suffixes)
- Header guards (traditional #ifndef form, no #pragma once)
- Control flow (Yoda, switch default, single-exit goto)
- Macros (multi-statement macros use do-while-0)
- Memory (malloc NULL check, free sets pointer to NULL, static preferred)
- Concurrency (ISR kept short, shared variables get volatile / atomic types)
- Error handling (goto err_out pattern, error code naming)
- MISRA C 2012 overlays (references/C14 §18 + misra-suppressions.txt)
- Doxygen comments (Chinese @brief, .h bans @details, @param direction tags)
## Documentation
- SKILL.md - agent load entry (frontmatter description + 25 hard rules + file layout + soft cases)
- references/ - detailed standards, split by topic
  - C00-baseline-formatting.md - sections 0-4 baseline and layout
  - C05-naming-types.md - sections 5-6 naming and types
  - C07-headers-variables-functions.md - sections 7-9 headers / variables / functions
  - C10-control-flow-files.md - sections 10-13 control flow / file layout / include order
  - C14-macros-memory-safety.md - sections 14-19 macros / memory / concurrency / error / MISRA
  - D-doxygen-comment-style.md - full Doxygen convention (6 chapters)
  - misra-suppressions.txt - MISRA C 2012 suppression list
- scripts/check.sh - 25 hard rules + 6-file structure + 3 severity + 3 example labels self-check
- .clang-format - layout self-check config
- plugin.json - Codex plugin metadata
- agents/openai.yaml - Codex platform load entry
- assets/social-preview.png - GitHub repo card preview
- CONTRIBUTING.md - rule change and PR flow
- CHANGELOG.md - version history
- LICENSE - MIT license
## Bundled tools
- .clang-format - layout self-check (run clang-format after agent generates code)
- scripts/check.sh - standard self-check (run in CI or pre-commit)
- references/ - progressive disclosure detailed standards (load on demand, not all at once)
## Supported agents
- Claude Code - ~/.claude/skills/c-coding-style/ (clone and cp the whole repo there)
- Codex CLI - ~/.codex/skills/c-coding-style/ (auto-loads agents/openai.yaml + plugin.json)
- Hermes - ~/.hermes/skills/c-coding-style/ (manual cp works)
- Cursor - .cursor/rules/c-coding-style.mdc (single file, paste SKILL.md content)
- Kilo Code - .kilocode/rules/c-coding-style.md (same)
- Windsurf - .windsurf/skills/c-coding-style/SKILL.md (same)
- OpenCode - .opencode/skills/c-coding-style/SKILL.md (same)
- Augment - .augment/skills/c-coding-style/SKILL.md (same)
- Antigravity - ~/.gemini/antigravity/skills/c-coding-style/ (cp the whole repo)
- Aider - CONVENTIONS.md (single file in project root, paste SKILL.md content)

Manual install commands are listed in the Quick start section above. No external multi-star-skill tool is required.
## Contributing
See CONTRIBUTING.md. Rule changes must keep cross-references between references/C*.md and references/D-doxygen-comment-style.md in sync.
## License
MIT

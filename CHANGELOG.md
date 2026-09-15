# Changelog
All notable changes to this skill are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/).

## 1.3.0 - 2026-09-03

### Breaking changes

- `references/C_CODING_STYLE.md` removed; replaced by 5 topic-split files:
  - `references/C00-baseline-formatting.md` (§0–§4)
  - `references/C05-naming-types.md` (§5–§6)
  - `references/C07-headers-variables-functions.md` (§7–§9)
  - `references/C10-control-flow-files.md` (§10–§13)
  - `references/C14-macros-memory-safety.md` (§14–§19, includes MISRA)
- `references/DOXYGEN_STYLE.md` renamed to `references/D-doxygen-comment-style.md`

### Added

- 25 hard rules (C-01~C-15 + D-01~D-10) each with stable ID + severity tag (CRITICAL/HIGH/MEDIUM) + BAD/GOOD/ACCEPTABLE examples
- `references/misra-suppressions.txt` — MISRA C 2012 suppression list
- `SKILL.md` rewritten to a thin entry point: frontmatter description + 25-rule summary + file layout + build verification
- `scripts/check.sh` rewritten to validate 25 rules + 6-file structure + 3 severity tags + 3 example labels

## 1.1.0 - 2026-09-02

### Added

- `assets/social-preview.png` — GitHub repo card preview
- MISRA C 2012 suppression template inside `references/C_CODING_STYLE.md` §18
- Comparison table in `README.md` / `README.EN.md` (later removed in 1.3.0)

## 1.0.0 - 2026-09-02

### Added
- Initial release
- Single-file C coding standard (`references/C_CODING_STYLE.md`, 18 chapters)
- Doxygen comment standard (`references/DOXYGEN_STYLE.md`, 6 chapters)
- .clang-format layout config
- scripts/check.sh self-check script
- plugin.json Codex plugin metadata
- Multi-agent support: Claude Code / Codex / Hermes / Cursor / Kilo Code / Windsurf / OpenCode / Augment / Antigravity / Aider
- README.md (Chinese) + README.EN.md (English)
- LICENSE (MIT)
- Updated SKILL.md description with pushy trigger phrase (Make sure to use this skill whenever...)

# Contributing
Thanks for your interest in improving c-coding-style. This document explains how to propose changes, what tests must pass, and how the rule cross-references work.
## How to propose changes
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-rule-change`)
3. Edit the relevant file in `references/`:
   - C 规约: `references/C00-baseline-formatting.md` / `C05-naming-types.md` / `C07-headers-variables-functions.md` / `C10-control-flow-files.md` / `C14-macros-memory-safety.md`
   - Doxygen 规约: `references/D-doxygen-comment-style.md`
   - MISRA 抑制清单: `references/misra-suppressions.txt`
4. If you change a C reference file, update SKILL.md's hard-rule list and the cross-reference table at the bottom of that file
5. If you change the Doxygen file, update SKILL.md's D-01~D-10 entries accordingly
6. Run `bash scripts/check.sh` and ensure no failures
7. Update `CHANGELOG.md` under a new version heading
8. Open a pull request describing the rationale and any breaking changes
## Rule change policy
- Naming, type, control-flow rules: discuss in an issue before sending a PR
- MISRA C 2012 overlays: must be backed by a specific MISRA rule number (e.g. Rule 8.4)
- Doxygen comment conventions: Chinese @brief is mandatory; do not relax
- Backward incompatible changes bump major version
## Cross-references
Each `references/C*.md` file ends with a `## 关键交叉引用` table that points to the matching SKILL.md hard-rule ID. `references/D-doxygen-comment-style.md` mirrors D-01~D-10 in SKILL.md.
When you change a rule in any reference file, you must update SKILL.md's matching entry. The check.sh script verifies file presence and rule-ID presence, but cannot verify semantic consistency, so manual review is required.
## Self-check before PR
```bash
bash scripts/check.sh
```
All checks must pass. Add new ones if you introduce new structural requirements.
## Style
- Use ASCII English for identifiers, code blocks, and YAML
- Use Chinese for narrative content in `references/C*.md` and `references/D-doxygen-comment-style.md`
- Keep lines under 150 characters (Chinese) / 180 characters (English) per the layout rule
## Code of conduct
Be respectful. Focus on the technical merit. This skill is widely used, so changes affect many downstream projects.
## License
By contributing you agree your contributions are licensed under MIT.

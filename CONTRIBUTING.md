# Contributing
Thanks for your interest in improving c-coding-style. This document explains how to propose changes, what tests must pass, and how the rule cross-references work.
## How to propose changes
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-rule-change`)
3. Edit `references/C_CODING_STYLE.md` and/or `references/DOXYGEN_STYLE.md`
4. Update the cross-references if you change either file (see Cross-references below)
5. Run `bash scripts/check.sh` and ensure no failures
6. Update `CHANGELOG.md` under a new version heading
7. Open a pull request describing the rationale and any breaking changes
## Rule change policy
- Naming, type, control-flow rules: discuss in an issue before sending a PR
- MISRA C 2012 overlays: must be backed by a specific MISRA rule number (e.g. Rule 8.4)
- Doxygen comment conventions: Chinese @brief is mandatory; do not relax
- Backward incompatible changes bump major version
## Cross-references
`references/C_CODING_STYLE.md` chapter 0 and chapter 11 explicitly reference `references/DOXYGEN_STYLE.md` as the comment standard.
When you change either file, you must update the other to keep the references consistent. The check.sh script can detect missing references but cannot detect broken ones, so manual review is required.
## Self-check before PR
```bash
bash scripts/check.sh
```
All checks must pass. Add new ones if you introduce new structural requirements.
## Style
- Use ASCII English for identifiers, code blocks, and YAML
- Use Chinese for narrative content in C_CODING_STYLE.md and DOXYGEN_STYLE.md
- Keep lines under 150 characters (Chinese) / 180 characters (English) per the layout rule
## Code of conduct
Be respectful. Focus on the technical merit. This skill is widely used, so changes affect many downstream projects.
## License
By contributing you agree your contributions are licensed under MIT.


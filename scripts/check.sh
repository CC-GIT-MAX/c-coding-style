#!/usr/bin/env bash
### scripts/check.sh - c-coding-style v1.3.0 skill self-check
### Validates the 25 hard rules (C-01~C-15 + D-01~D-10) and project structure
### AdapTED to the 6-file references structure (C00~C14 + D)

set -e

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILED=0
PASSED=0

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok() { echo -e "${GREEN}[OK]${NC} $*"; PASSED=$((PASSED + 1)); }
err() { echo -e "${RED}[FAIL]${NC} $*"; FAILED=$((FAILED + 1)); }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

check_rg() {
  local desc="$1"
  local pattern="$2"
  local target="$3"
  if grep -qE "$pattern" "$target" 2>/dev/null; then
    ok "$desc"
  else
    err "$desc (missing in $target)"
  fi
}

echo "Checking SKILL.md structure"

if head -1 "$SKILL_DIR/SKILL.md" | grep -q '^---$'; then
  ok "SKILL.md starts with ---"
else
  err "SKILL.md missing frontmatter start"
fi

DESC=$(awk '/^description:/{sub(/^description: */,""); print; exit}' "$SKILL_DIR/SKILL.md")
DESC_LEN=${#DESC}
if [ "$DESC_LEN" -ge 80 ] && [ "$DESC_LEN" -le 500 ]; then
  ok "description length $DESC_LEN chars (target 80-500)"
else
  err "description length $DESC_LEN chars out of range 80-500"
fi

if echo "$DESC" | grep -qi "make sure to use"; then
  ok "description contains pushy phrase"
else
  warn "description lacks pushy phrase"
fi

for kw in "C" "MISRA" "Doxygen" ".c" ".h"; do
  if echo "$DESC" | grep -q "$kw"; then
    ok "description contains keyword: $kw"
  else
    err "description missing keyword: $kw"
  fi
done

# 25 hard rules ID + severity check in SKILL.md
echo ""
echo "Checking 25 hard rules ID + severity in SKILL.md"

EXPECTED_RULES="C-01 C-02 C-03 C-04 C-05 C-06 C-07 C-08 C-09 C-10 C-11 C-12 C-13 C-14 C-15 D-01 D-02 D-03 D-04 D-05 D-06 D-07 D-08 D-09 D-10"
for rule in $EXPECTED_RULES; do
  if grep -qE "#### $rule \[" "$SKILL_DIR/SKILL.md"; then
    ok "rule $rule present in SKILL.md"
  else
    err "rule $rule missing in SKILL.md"
  fi
done

for sev in CRITICAL HIGH MEDIUM; do
  count=$(grep -cE "\[$sev\]" "$SKILL_DIR/SKILL.md" || true)
  if [ "$count" -gt 0 ]; then
    ok "severity tag [$sev] used $count times in SKILL.md"
  else
    warn "severity tag [$sev] not used in SKILL.md"
  fi
done

for example in BAD GOOD ACCEPTABLE; do
  count=$(grep -cE "^- ${example}( |$)" "$SKILL_DIR/SKILL.md" || true)
  if [ "$count" -gt 0 ]; then
    ok "example label $example used $count times in SKILL.md"
  else
    err "example label $example missing in SKILL.md (BAD/GOOD/ACCEPTABLE pattern broken)"
  fi
done

# References 6 files structure check
echo ""
echo "Checking references/ 6-file structure"

for f in C00-baseline-formatting.md C05-naming-types.md C07-headers-variables-functions.md C10-control-flow-files.md C14-macros-memory-safety.md D-doxygen-comment-style.md; do
  if [ -f "$SKILL_DIR/references/$f" ]; then
    ok "references/$f exists"
  else
    err "references/$f missing"
  fi
done

if [ -f "$SKILL_DIR/references/C_CODING_STYLE.md" ]; then
  err "old references/C_CODING_STYLE.md still exists, should be removed after split"
else
  ok "old references/C_CODING_STYLE.md removed"
fi

if [ -f "$SKILL_DIR/references/DOXYGEN_STYLE.md" ]; then
  err "old references/DOXYGEN_STYLE.md still exists, should be renamed to D-doxygen-comment-style.md"
else
  ok "old references/DOXYGEN_STYLE.md removed"
fi

# Cross-reference check: each C reference has 关键交叉引用
for f in C00-baseline-formatting.md C05-naming-types.md C07-headers-variables-functions.md C10-control-flow-files.md C14-macros-memory-safety.md D-doxygen-comment-style.md; do
  if grep -q "关键交叉引用" "$SKILL_DIR/references/$f"; then
    ok "references/$f contains key cross-reference table"
  else
    err "references/$f missing 关键交叉引用 table"
  fi
done

# Content checks
echo ""
echo "Checking content"

for rule_file in C00:C-01 C00:C-02 C00:C-03 C00:C-11 C05:C-05 C05:C-12 C05:C-15 C07:C-06 C07:C-07 C07:C-13 C07:C-14 C10:C-04 C10:C-08 C10:C-09 C10:C-10 C14:C-14 C14:C-18 D-doxygen:D-01 D-doxygen:D-05; do
  file="${rule_file%:*}"
  rule="${rule_file#*:}"
  if grep -qE "$rule \[" "$SKILL_DIR/references/$file" 2>/dev/null; then
    ok "$rule referenced in $file"
  else
    warn "$rule not referenced in $file (可能该规则与其他章节相关)"
  fi
done

# C-11 零警告 check
if grep -qE "C-11.*\[CRITICAL\]" "$SKILL_DIR/SKILL.md"; then
  ok "C-11 [CRITICAL] 零警告 rule present in SKILL.md"
fi

# Yoda style check
check_rg "Yoda style mentioned" "Yoda|0U ==" "$SKILL_DIR/references/C10-control-flow-files.md"

# Header guard check
check_rg "Header guard mentioned" "#ifndef|头文件保护" "$SKILL_DIR/references/C07-headers-variables-functions.md"

# MISRA mention
check_rg "MISRA mentioned in C14" "MISRA" "$SKILL_DIR/references/C14-macros-memory-safety.md"

# Doxygen tag check
for tag in "@brief" "@param" "@return"; do
  check_rg "Doxygen tag $tag mentioned" "$tag" "$SKILL_DIR/references/D-doxygen-comment-style.md"
done

check_rg "Chinese @brief requirement" "@brief" "$SKILL_DIR/references/D-doxygen-comment-style.md"

echo ""
echo "Checking project files"

if [ -f "$SKILL_DIR/.clang-format" ]; then
  ok ".clang-format exists"
else
  err ".clang-format missing (P0 violation)"
fi

if [ -f "$SKILL_DIR/agents/openai.yaml" ]; then
  ok "agents/openai.yaml exists (Codex)"
else
  warn "agents/openai.yaml missing"
fi

if [ -f "$SKILL_DIR/LICENSE" ]; then
  ok "LICENSE exists"
else
  err "LICENSE missing (P0 violation)"
fi

if [ -f "$SKILL_DIR/README.md" ]; then
  ok "README.md exists"
else
  err "README.md missing (P0 violation)"
fi

if [ -f "$SKILL_DIR/README.EN.md" ]; then
  ok "README.EN.md exists"
else
  err "README.EN.md missing (P0 violation)"
fi

# CHANGELOG.md intentionally omitted; release body on GitHub carries version history.

if [ -f "$SKILL_DIR/CONTRIBUTING.md" ]; then
  ok "CONTRIBUTING.md exists"
else
  warn "CONTRIBUTING.md missing (P1 violation)"
fi

if [ -f "$SKILL_DIR/plugin.json" ]; then
  ok "plugin.json exists (Codex plugin metadata)"
else
  warn "plugin.json missing"
fi

echo ""
echo "Summary"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ "$FAILED" -gt 0 ]; then
  echo ""
  echo "Fix the failed checks above before publishing."
  exit 1
fi

echo ""
echo "All P0 checks passed. Ready to publish."
exit 0

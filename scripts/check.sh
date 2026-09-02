#!/usr/bin/env bash
### scripts/check.sh - c-coding-style skill 自检脚本
### 验证 references/C_CODING_STYLE.md 和 references/DOXYGEN_STYLE.md 的关键约束
### 借鉴 Z1R343L-D77 的 rg 验证清单模式

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
if [ "$DESC_LEN" -ge 80 ] && [ "$DESC_LEN" -le 200 ]; then
  ok "description length $DESC_LEN chars (target 80-160, max 200)"
else
  err "description length $DESC_LEN chars out of range 80-200"
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

echo ""
echo "Checking references/C_CODING_STYLE.md"

C_REF="$SKILL_DIR/references/C_CODING_STYLE.md"
if [ ! -f "$C_REF" ]; then err "C_CODING_STYLE.md missing"; exit 1; fi

for ch in "0\\." "1\\." "5\\." "10\\." "18\\."; do
  check_rg "Chapter $ch present in C_CODING_STYLE" "^## .* $ch " "$C_REF"
done

check_rg "MISRA mentioned" "MISRA" "$C_REF"
check_rg "Yoda style mentioned" "Yoda|0U ==" "$C_REF"
check_rg "Header guard mentioned" "#ifndef|头文件保护" "$C_REF"

echo ""
echo "Checking references/DOXYGEN_STYLE.md"

D_REF="$SKILL_DIR/references/DOXYGEN_STYLE.md"
if [ ! -f "$D_REF" ]; then err "DOXYGEN_STYLE.md missing"; exit 1; fi

for tag in "@brief" "@param" "@return"; do
  check_rg "Doxygen tag $tag mentioned" "$tag" "$D_REF"
done

check_rg "Chinese @brief requirement" "@brief" "$D_REF"

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

if [ -f "$SKILL_DIR/CHANGELOG.md" ]; then
  ok "CHANGELOG.md exists"
else
  warn "CHANGELOG.md missing (P1 violation)"
fi

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


#!/usr/bin/env bash
# =============================================================================
# 게으른빌더 Shorts "3달만에 10만 달성하게 해 준 클로드 플러그인 10개 모음"
# (https://youtube.com/shorts/3eAfrL6_ezE) 에 나온 도구 10개를 로컬 PC에 설치한다.
#
# 레포에 이미 커밋된 것 (별도 설치 불필요):
#   - .claude/skills/        : agent-browser, hyperframes, impeccable, design-taste-frontend(Taste),
#                              agent-reach, remotion-* (12개)
#   - .claude/settings.json  : ECC, prompts.chat 플러그인/마켓플레이스 선언 (프로젝트 범위)
#   - .mcp.json              : MarkItDown MCP 서버 (uvx markitdown-mcp)
#
# 이 스크립트가 하는 일 (로컬 PC에서 한 번만 실행):
#   1) .claude/settings.json 에 선언된 플러그인(ECC, prompts.chat)을 내 PC에 다운로드
#   2) 스킬이 호출하는 CLI 설치: agent-browser, agent-reach, graphify, markitdown
#
# 사용법:  bash scripts/setup-claude-plugins.sh
# 필요:    claude(Claude Code CLI), node/npm(22+), uv 또는 pipx
# =============================================================================
set -u

cd "$(dirname "$0")/.." || exit 1

have() { command -v "$1" >/dev/null 2>&1; }
step() { printf '\n\033[1;33m== %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m   ✔ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;31m   ✖ %s\033[0m\n' "$*"; }

FAILED=()

# 파이썬 CLI 설치기: uv 우선, 없으면 pipx
py_tool_install() {   # py_tool_install <표시이름> <패키지 spec>
  local name="$1" spec="$2"
  if have uv; then
    uv tool install --upgrade "$spec" && return 0
  elif have pipx; then
    pipx install --force "$spec" && return 0
  else
    warn "uv 또는 pipx 가 없어 $name 을(를) 건너뜀. 설치: https://docs.astral.sh/uv/  (또는 pip install pipx)"
    return 1
  fi
}

# -----------------------------------------------------------------------------
step "1) Claude Code 플러그인 — ECC, prompts.chat (프로젝트 범위)"
if have claude; then
  claude plugin marketplace add affaan-m/ECC   --scope project >/dev/null 2>&1 || true
  claude plugin marketplace add f/prompts.chat --scope project >/dev/null 2>&1 || true
  claude plugin install ecc@ecc                   --scope project && ok "ecc@ecc"                   || FAILED+=("ecc@ecc")
  claude plugin install prompts.chat@prompts.chat --scope project && ok "prompts.chat@prompts.chat" || FAILED+=("prompts.chat@prompts.chat")
  echo "   (선택) ECC 훅 설정: Claude Code 안에서 /plugin configure ecc@ecc"
else
  warn "claude CLI 가 없습니다. 설치: https://code.claude.com/docs/en/setup"
  FAILED+=("claude-plugins")
fi

# -----------------------------------------------------------------------------
step "2) agent-browser — 클로드가 쓰는 진짜 웹 브라우저 (vercel-labs/agent-browser)"
if have npm; then
  npm install -g agent-browser && agent-browser install && ok "agent-browser $(agent-browser --version 2>/dev/null)" || FAILED+=("agent-browser")
else
  warn "npm 이 없습니다 (Node.js 22+ 필요)"; FAILED+=("agent-browser")
fi

# -----------------------------------------------------------------------------
step "3) Agent-Reach — 인스타/유튜브/링크드인 등 수집 CLI (Panniantong/agent-reach)"
# 공식 문서(docs/install.md)는 GitHub zip 을 쓰고, zip 다운로드가 막힌 환경은 git+https 로 대체
if py_tool_install "agent-reach" "https://github.com/Panniantong/agent-reach/archive/main.zip" \
   || py_tool_install "agent-reach" "git+https://github.com/Panniantong/agent-reach.git"; then
  agent-reach install --env=auto || true          # 읽기 전용 점검 (시스템 변경 없음)
  ok "agent-reach 설치됨. 실제 등록은 직접 승인 후:  agent-reach install --env=auto --system  → 상태 확인: agent-reach doctor"
else
  FAILED+=("agent-reach")
fi

# -----------------------------------------------------------------------------
step "4) Graphify — 코드베이스 지식 그래프, 토큰 절감 (PyPI: graphifyy)"
if py_tool_install "graphify" "graphifyy"; then
  graphify install && ok "graphify $(graphify --version 2>/dev/null)  →  Claude Code 에서 /graphify . 로 프로젝트 맵 생성" || FAILED+=("graphify-install")
else
  FAILED+=("graphify")
fi

# -----------------------------------------------------------------------------
step "5) MarkItDown — PDF/Office → 마크다운 변환 CLI (microsoft/markitdown)"
echo "   MCP 서버는 .mcp.json 의 'uvx markitdown-mcp' 로 자동 실행됩니다 (uv 필요)."
if py_tool_install "markitdown" "markitdown[all]"; then
  ok "markitdown $(markitdown --version 2>/dev/null)   예) markitdown report.pdf -o report.md"
else
  FAILED+=("markitdown")
fi
have uv || warn "uv 가 없으면 .mcp.json 의 MarkItDown MCP 가 뜨지 않습니다. 설치: curl -LsSf https://astral.sh/uv/install.sh | sh"

# -----------------------------------------------------------------------------
step "6) HyperFrames / Remotion — 설치 불필요 (npx 로 실행, 스킬은 .claude/skills 에 포함)"
if have npx; then
  npx -y hyperframes --version >/dev/null 2>&1 && ok "hyperframes $(npx -y hyperframes --version 2>/dev/null | tail -1)" || warn "npx hyperframes 실행 실패 (Node 22+ 필요)"
  echo "   Remotion 새 프로젝트: npx create-video@latest   /  스킬: /remotion-best-practices"
fi

# -----------------------------------------------------------------------------
step "7) Impeccable / Taste — 스킬만으로 동작 (.claude/skills/impeccable, design-taste-frontend)"
echo "   Claude Code 에서 /impeccable init 으로 PRODUCT.md 를 먼저 만들면 좋습니다."

# -----------------------------------------------------------------------------
step "확인"
have claude && { claude plugin list 2>/dev/null | sed 's/^/   /'; claude mcp list 2>/dev/null | sed 's/^/   /'; }
echo "   스킬: $(ls .claude/skills 2>/dev/null | tr '\n' ' ')"

if [ ${#FAILED[@]} -gt 0 ]; then
  warn "실패/건너뜀: ${FAILED[*]}  — 위 로그를 확인하세요."
  exit 1
fi
ok "완료. Claude Code 를 다시 시작하거나 /reload-plugins 를 실행하세요."

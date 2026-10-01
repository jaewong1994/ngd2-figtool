# 클로드 플러그인 10개 설치 기록 (게으른빌더 Shorts)

**출처**: 게으른빌더(@lazyowenAI) Shorts 「3달만에 10만 달성하게 해 준 클로드 플러그인 10개 모음」 (2026-09-30, 14초)
<https://youtube.com/shorts/3eAfrL6_ezE>

영상 설명과 고정댓글에는 목록이 없고(가이드 사이트 링크만 있음) 화면 자막으로만 나와서, 영상 프레임을 직접 읽어 정리했습니다.
영상은 8개 항목이며 1번·2번이 각각 두 도구를 묶어 총 10개입니다.
**5번 ECC는 사용자 요청으로 설치 대상에서 제외**했습니다 (아래 "주의" 참고).

## 영상 속 10개

| 순서 | 영상 자막 | 도구 | 저장소 / 사이트 |
| --- | --- | --- | --- |
| 1 | Remotion & Hyperframes — 클로드 모션그래픽 조합 1등 | **Remotion** | [remotion-dev/skills](https://github.com/remotion-dev/skills) · remotion.dev |
| 1 | 〃 | **HyperFrames** | [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) |
| 2 | Impeccable & Taste — 클로드로 눈 뒤집히는 웹사이트 만들기 | **Impeccable** | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) · impeccable.style |
| 2 | 〃 | **Taste Skill** | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) |
| 3 | MarkItDown — 마이크로소프트가 만든 토큰 최적화 도구 | **MarkItDown** | [microsoft/markitdown](https://github.com/microsoft/markitdown) |
| 4 | AgentReach — 인스타그램, 유튜브, 링크드인 무제한 무료로 긁어오는 도구 | **Agent-Reach** | [Panniantong/agent-reach](https://github.com/Panniantong/agent-reach) |
| 5 | ECC — 앤트로픽 해커톤 우승자가 만든 가장 좋은 클로드 하네스 | **ECC** (설치 제외) | [affaan-m/ECC](https://github.com/affaan-m/ECC) · ecc.tools |
| 6 | Graphify — 클로드 토큰 최대 70% 절감 | **Graphify** | [safishamsi/graphify](https://github.com/safishamsi/graphify) · PyPI `graphifyy` |
| 7 | AgentBrowser — 클로드가 쓸 수 있는 진짜 웹 브라우저를 줌 | **agent-browser** | [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) |
| 8 | Prompts.chat — 전 세계 사람들이 함께 모은 프롬프트 모음집 | **prompts.chat** | [f/prompts.chat](https://github.com/f/prompts.chat) · prompts.chat |

## 이 레포에 설치된 것 (커밋됨)

| 도구 | 위치 | 형태 | 클라우드 세션 (claude.ai/code) | 로컬 Claude Code |
| --- | --- | --- | --- | --- |
| Remotion | `.claude/skills/remotion-*` (12개, 라우터는 `remotion-best-practices`) | 스킬 | 로드됨 | 로드됨 |
| HyperFrames | `.claude/skills/hyperframes` | 스킬 (렌더는 `npx hyperframes`) | 로드됨 | 로드됨 |
| Impeccable | `.claude/skills/impeccable` | 스킬 (`/impeccable polish` 등 24개 명령) | 로드됨 | 로드됨 |
| Taste Skill | `.claude/skills/design-taste-frontend` | 스킬 | 로드됨 | 로드됨 |
| MarkItDown | `.mcp.json` → `uvx markitdown-mcp` | MCP 서버 (`convert_to_markdown`) | 로드됨 | 로드됨 (uv 필요) |
| Agent-Reach | `.claude/skills/agent-reach` | 스킬 + 로컬 CLI | 스킬만 | 스크립트로 CLI 설치 |
| agent-browser | `.claude/skills/agent-browser` | 스킬 + 로컬 CLI | 스킬만 | 스크립트로 CLI 설치 |
| prompts.chat | `.claude/settings.json` → `prompts.chat@prompts.chat` | 플러그인 (MCP `https://prompts.chat/api/mcp` 포함) | 로드 안 됨 | 스크립트로 다운로드 |
| Graphify | 레포 밖 (사용자 공간) | CLI + 사용자 스킬 | 로드 안 됨 | 스크립트로 설치 |

클라우드 세션은 레포에 커밋된 `.claude/skills/`, `.mcp.json`은 읽지만, `.claude/settings.json`에 선언된 플러그인은 설치하지 않습니다
(공식 문서: [What carries over from your setup](https://code.claude.com/docs/en/cloud-environments#what-carries-over-from-your-setup)).

## 로컬 PC에서 한 번 실행

```bash
bash scripts/setup-claude-plugins.sh
```

스크립트가 하는 일:

1. `.claude/settings.json`에 선언된 **prompts.chat** 플러그인을 내 PC에 다운로드 (`claude plugin install … --scope project`)
2. **agent-browser** CLI 설치 + Chrome 다운로드 (`npm i -g agent-browser && agent-browser install`)
3. **Agent-Reach** CLI 설치 (`uv tool install` 또는 `pipx`) 후 읽기 전용 점검 `agent-reach install --env=auto`
4. **Graphify** 설치 (`uv tool install graphifyy`) 후 `graphify install`로 `/graphify` 스킬 등록
5. **MarkItDown** CLI 설치 (`uv tool install 'markitdown[all]'`)
6. HyperFrames/Remotion은 설치 없이 `npx`로 실행되는지 확인

필요: Claude Code CLI, Node.js 22+, [uv](https://docs.astral.sh/uv/) 또는 pipx. Windows는 Git Bash/WSL에서 실행하거나 아래 명령을 하나씩 실행하세요.

### 수동 설치 명령 (스크립트 대신)

```bash
# 플러그인 (레포 루트에서)
claude plugin marketplace add f/prompts.chat --scope project
claude plugin install prompts.chat@prompts.chat --scope project

# CLI
npm install -g agent-browser && agent-browser install
uv tool install https://github.com/Panniantong/agent-reach/archive/main.zip && agent-reach install --env=auto
uv tool install graphifyy && graphify install
uv tool install 'markitdown[all]'
```

## 확인

```bash
claude plugin list          # prompts.chat@prompts.chat 가 enabled
claude mcp list             # markitdown ✔ Connected (로컬 플러그인 설치 후엔 prompts.chat 도)
ls .claude/skills           # 17개 스킬 디렉터리
agent-browser --version && agent-reach doctor && graphify --version && markitdown --version
```

Claude Code 안에서는 `/impeccable init`, `/hyperframes`, `/remotion-best-practices`, `/graphify .` 같은 명령으로 스킬이 보이는지 확인하면 됩니다.

## 주의

- **ECC는 설치하지 않았습니다** (사용자 요청). 참고로 `claude plugin details ecc@ecc` 기준 매 세션에 약 4만 5천 토큰이 항상 추가되고(스킬 387개, 에이전트 68개),
  명령 실행 전에 사실 확인을 요구하는 GateGuard 훅이 함께 켜집니다. 나중에 필요하면
  `claude plugin marketplace add affaan-m/ECC && claude plugin install ecc@ecc` 로 추가하고, 일부만 쓰려면 `npx ecc-universal@latest setup`(선택 설치 프로필)을 쓰세요.
- **Remotion**은 claude.ai 플러그인 카탈로그(Anthropic Directory)에도 있어 계정 단위로 켜면 클라우드 세션에서도 쓸 수 있습니다.
- **prompts.chat**을 클라우드 세션에서도 쓰려면 MCP만 따로 추가하면 됩니다 (로컬 플러그인과 중복될 수 있어 기본으로는 넣지 않았습니다):
  `claude mcp add --transport http --scope project prompts-chat https://prompts.chat/api/mcp`
- **Agent-Reach**의 실제 등록(`--system`)과 로그인 필요 채널(Instagram, X 등)은 사용자가 직접 승인·설정해야 합니다.

## 참고 (게으른빌더 가이드)

- ECC: <https://lazyowen.com/guides/ecc-claude-code-agent-team>
- HyperFrames: <https://lazyowen.com/guides/manus-hyperframes-srt-motion>
- Impeccable / Taste: <https://lazyowen.com/guides/claude-designer-kill>
- MarkItDown: <https://lazyowen.com/guides/markitdown-pdf-token-saver>
- Agent-Reach: <https://lazyowen.com/guides/agent-reach>
- Graphify: <https://lazyowen.com/guides/graphify>
- agent-browser: <https://lazyowen.com/guides/claude-code-skills-5-0813>
- prompts.chat: <https://lazyowen.com/guides/hani-prompt>

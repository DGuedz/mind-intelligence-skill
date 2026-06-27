#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "MIND Intelligence Skill — Custom Installer"
echo ""

# Location choice
echo "Install location:"
echo "  1) Personal — ~/.claude/skills/ (recommended)"
echo "  2) Project  — ./.claude/skills/"
echo "  3) Custom path"
read -rp "Choice [1]: " LOC_CHOICE
LOC_CHOICE="${LOC_CHOICE:-1}"

case "$LOC_CHOICE" in
  1) DEST="$HOME/.claude/skills/mind-intelligence-skill" ;;
  2) DEST="./.claude/skills/mind-intelligence-skill" ;;
  3) read -rp "Path: " DEST ;;
  *) DEST="$HOME/.claude/skills/mind-intelligence-skill" ;;
esac

# Check for existing solana-dev-skill
SOLANA_DEV_EXISTS=false
if [[ -d "$HOME/.claude/skills/solana-dev-skill" ]] || [[ -d "./.claude/skills/solana-dev-skill" ]]; then
  SOLANA_DEV_EXISTS=true
  echo "solana-dev-skill detected — skipping core install."
fi

# Install
mkdir -p "$DEST"
cp -r "$SKILL_DIR/skill" "$DEST/"
[[ -d "$SKILL_DIR/agents" ]] && cp -r "$SKILL_DIR/agents" "$DEST/"
[[ -d "$SKILL_DIR/commands" ]] && cp -r "$SKILL_DIR/commands" "$DEST/"
[[ -d "$SKILL_DIR/rules" ]] && cp -r "$SKILL_DIR/rules" "$DEST/"

echo "Skill installed to: $DEST"
echo ""

# CLAUDE.md placement
if [[ -f "$SKILL_DIR/CLAUDE.md" ]]; then
  echo "CLAUDE.md placement:"
  echo "  1) ~/.claude/CLAUDE.md (personal)"
  echo "  2) ./CLAUDE.md (project root)"
  echo "  3) Skip"
  read -rp "Choice [1]: " MD_CHOICE
  MD_CHOICE="${MD_CHOICE:-1}"
  case "$MD_CHOICE" in
    1) cp "$SKILL_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" ;;
    2) cp "$SKILL_DIR/CLAUDE.md" "./CLAUDE.md" ;;
  esac
fi

echo ""
echo "Usage (x402 — no API key):"
echo "  curl https://api.mindprotocol.xyz/v1/cards \\"
echo "    -H 'Content-Type: application/json' \\"
echo "    -d '{\"card\": \"mind_risk_scoring\", \"wallet\": \"<SOLANA_ADDRESS>\"}'"
echo ""
echo "Usage (API key — MCP):"
echo "  export MIND_API_KEY=your_key_here"
echo "  See skill/mcp.md for Claude Desktop setup"
echo ""
echo "Entry point: $DEST/skill/SKILL.md"

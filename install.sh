#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_SKILLS_DIR="${SOLANA_AI_KIT_PATH:-$HOME/.solana-ai-kit}/skills"

echo "MIND Intelligence Skill installer"
echo ""

# Copy skill files into the kit if KIT path exists
if [[ -d "$KIT_SKILLS_DIR" ]]; then
  DEST="$KIT_SKILLS_DIR/mind-intelligence-skill"
  mkdir -p "$DEST"
  cp -r "$SKILL_DIR/skill" "$DEST/"
  [[ -d "$SKILL_DIR/agents" ]] && cp -r "$SKILL_DIR/agents" "$DEST/"
  [[ -d "$SKILL_DIR/commands" ]] && cp -r "$SKILL_DIR/commands" "$DEST/"
  echo "Skill files installed to $DEST"
else
  echo "Skill files are ready to use from: $SKILL_DIR/skill/SKILL.md"
  echo "(Set SOLANA_AI_KIT_PATH to auto-install into the kit)"
fi

echo ""
echo "To use with Claude Desktop / Claude Code MCP (requires API key):"
echo "  export MIND_API_KEY=your_key_here"
echo "  export MIND_API_URL=https://api.mindprotocol.xyz"
echo ""
echo "Add to your claude_desktop_config.json under mcpServers:"
cat <<'JSON'
{
  "mind-protocol": {
    "command": "npx",
    "args": ["-y", "@mind/mcp-server@latest"],
    "env": {
      "MIND_API_URL": "https://api.mindprotocol.xyz",
      "MIND_API_KEY": "<your_key>"
    }
  }
}
JSON
echo ""
echo "Get an API key at https://www.mindprotocol.xyz"
echo "Skill entry point: skill/SKILL.md"

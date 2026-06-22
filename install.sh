#!/usr/bin/env bash
set -euo pipefail

MIND_MCP_ENTRY='{
  "mind-protocol": {
    "command": "npx",
    "args": ["-y", "@mind/mcp-server"],
    "env": {
      "MIND_API_URL": "'"${MIND_API_URL:-https://api.mindprotocol.xyz}"'",
      "MIND_API_KEY": "'"${MIND_API_KEY:-}"'"
    }
  }
}'

CLAUDE_CONFIG="$HOME/.claude/claude_desktop_config.json"

if [[ -z "${MIND_API_KEY:-}" ]]; then
  echo "ERROR: MIND_API_KEY env var is required."
  echo "  export MIND_API_KEY=your_key_here"
  echo "  Then re-run: ./install.sh"
  exit 1
fi

if [[ ! -f "$CLAUDE_CONFIG" ]]; then
  echo "Claude Desktop config not found at $CLAUDE_CONFIG"
  echo "Creating it..."
  mkdir -p "$(dirname "$CLAUDE_CONFIG")"
  echo '{"mcpServers":{}}' > "$CLAUDE_CONFIG"
fi

# Merge using node (available anywhere node is)
node - <<EOF
const fs = require('fs');
const cfg = JSON.parse(fs.readFileSync('$CLAUDE_CONFIG', 'utf8'));
cfg.mcpServers = cfg.mcpServers || {};
cfg.mcpServers['mind-protocol'] = $MIND_MCP_ENTRY['mind-protocol'];
fs.writeFileSync('$CLAUDE_CONFIG', JSON.stringify(cfg, null, 2));
console.log('mind-protocol MCP server added to', '$CLAUDE_CONFIG');
EOF

echo ""
echo "Done. Restart Claude Desktop to activate MIND Intelligence tools."
echo "Available tools: mind_signals, mind_market_intelligence, mind_risk_scoring, mind_verify_proof"

# MCP Server Setup

Connect MIND to any MCP-compatible client: Claude Desktop, Cursor, Claude Code, or any agent using the Model Context Protocol.

## Install

```bash
./install.sh
```

The script adds the MIND MCP server entry to `~/.claude/claude_desktop_config.json` (or prompts you to add it manually for Cursor).

## Manual configuration

Add to your MCP config:

```json
{
  "mcpServers": {
    "mind-protocol": {
      "command": "npx",
      "args": ["-y", "@mind/mcp-server"],
      "env": {
        "MIND_API_URL": "https://api.mind.so",
        "MIND_API_KEY": "your_key_here"
      }
    }
  }
}
```

## Available MCP tools after connecting

| Tool | Description |
|------|-------------|
| `mind_signals` | Price + momentum from Pyth oracle |
| `mind_market_intelligence` | Wallet balances + portfolio breakdown |
| `mind_risk_scoring` | Concentration risk score + PASS/BLOCK |
| `mind_verify_proof` | Verify a mindprint hash |

## Self-hosted

Clone and run locally:

```bash
git clone https://github.com/mindprotocol/mind-intelligence-skill
cd mind-intelligence-skill
npm install
MIND_API_URL=http://localhost:3000 MIND_API_KEY=local npm run mcp
```

## Environment variables

| Var | Required | Default |
|-----|----------|---------|
| `MIND_API_URL` | Yes | — |
| `MIND_API_KEY` | Yes | — |
| `MCP_LOG_LEVEL` | No | `info` |

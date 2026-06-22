# MIND Intelligence Skill

> Auditable agent intelligence for Solana: price signals, portfolio analysis, risk scoring — every response carries a cryptographic mindprint proof.

## What this skill does

MIND gives your agent real-time market intelligence with built-in auditability. Every tool call returns a **mindprint** — a tamper-evident proof anchored to the on-chain state at the moment of the query. Agents that act on MIND data can prove *why* they made a decision.

## When to load sub-skills

| Task | Load |
|------|------|
| Get price or momentum for a Solana asset | [signals.md](signals.md) |
| Analyze a wallet's token portfolio | [portfolio.md](portfolio.md) |
| Compute concentration risk, get PASS/BLOCK decision | [risk.md](risk.md) |
| Verify or display a mindprint proof | [proofs.md](proofs.md) |
| Connect via MCP (Claude Desktop, Cursor, any MCP client) | [mcp.md](mcp.md) |

## Quick start

```bash
# Install (adds MIND MCP server to your claude_desktop_config.json)
./install.sh

# Required env vars
MIND_API_URL=https://api.mind.so   # or your self-hosted endpoint
MIND_API_KEY=your_key_here
```

## Supported assets

SOL, JUP, BONK, USDC, USDT, WETH, WBTC, RAY, MSOL, STSOL, HNT

## Key invariants

- Every response includes a `mindprint` field — preserve it for audit trails
- Risk score >= 80 → automatic BLOCK decision; do not execute trades
- Signals are Pyth-sourced; latency < 500ms p95
- Portfolio data via Covalent/GoldRush; covers all SPL tokens

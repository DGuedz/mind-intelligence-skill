# MIND Intelligence Skill

> Trust layer for A2A agents on Solana. Price signals from Pyth (on-chain), portfolio data from Covalent/GoldRush, risk scoring — every response carries a mindprint proof anchored to a Solana slot.

## What this skill does

MIND connects agents to native Solana data sources and produces a cryptographic proof for every tool call. The proof ties the agent's decision to a specific Solana slot — making it independently verifiable by any party after the fact.

This is not a generic market data wrapper. The slot anchor is what makes A2A coordination auditable: when one agent acts on another's signal, the chain of proofs shows exactly what each agent saw, when, and from which source.

## When to load sub-skills

| Task | Load |
|------|------|
| Get price or momentum for a Solana asset (Pyth on-chain) | [signals.md](signals.md) |
| Analyze a wallet's SPL token portfolio (Covalent/GoldRush) | [portfolio.md](portfolio.md) |
| Compute concentration risk, get PASS/WARN/BLOCK gate decision | [risk.md](risk.md) |
| Verify a prior mindprint proof by hash | [proofs.md](proofs.md) |
| Connect via MCP (Claude Desktop, Cursor, any MCP client) | [mcp.md](mcp.md) |

## Quick start

```bash
export MIND_API_KEY=your_key_here
./install.sh
```

```
MIND_API_URL=https://api.mindprotocol.xyz
MIND_API_KEY=your_key_here
```

## Data sources (native Solana)

| Source | What it provides |
|--------|-----------------|
| Pyth Network (on-chain oracle) | Real-time price feeds — SOL, JUP, BONK, USDC, USDT, WETH, WBTC, RAY, MSOL, STSOL, HNT |
| Covalent / GoldRush | SPL token balances, portfolio composition, historical positions |

## Key invariants

- Every response includes a `mindprint` field — preserve it; it is the proof of what the agent saw
- Risk score >= 80 → automatic BLOCK; the agent must not execute
- Pyth signals carry the Solana slot at query time — verifiable on-chain
- Portfolio data covers all SPL tokens, not just whitelisted assets

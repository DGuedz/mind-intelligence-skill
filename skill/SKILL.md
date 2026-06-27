---
name: mind-intelligence
description: Trust layer for A2A agents on Solana — price signals from Pyth (on-chain), portfolio data from Covalent/GoldRush, wallet risk scoring, counterparty checks, token intelligence, and portfolio audits. Every response carries a mindprint proof anchored to a Solana slot. Supports x402 micropayments (no API key required) and traditional API key auth.
user-invocable: true
---

# MIND Intelligence Skill

> Trust layer for A2A agents on Solana. Price signals from Pyth (on-chain), portfolio data from Covalent/GoldRush, risk scoring — every response carries a mindprint proof anchored to a Solana slot.

## What this skill does

MIND connects agents to native Solana data sources and produces a cryptographic proof for every tool call. The proof ties the agent's decision to a specific Solana slot — making it independently verifiable by any party after the fact.

This is not a generic market data wrapper. The slot anchor is what makes A2A coordination auditable: when one agent acts on another's signal, the chain of proofs shows exactly what each agent saw, when, and from which source.

## When to load sub-skills

| Task | Price | Load |
|------|-------|------|
| Get price or momentum for a Solana asset (Pyth on-chain) | 0.010 USDC | [signals.md](signals.md) |
| Analyze a wallet's SPL token portfolio (Covalent/GoldRush) | 0.020 USDC | [portfolio.md](portfolio.md) |
| Quick pre-transaction counterparty check | 0.015 USDC | [counterparty.md](counterparty.md) |
| Compute concentration risk, get PASS/WARN/BLOCK gate decision | 0.0154 USDC | [risk.md](risk.md) |
| Behavioral fingerprint of a wallet | 0.025 USDC | [wallet-profile.md](wallet-profile.md) |
| Token safety, holder concentration, insider flags | 0.035 USDC | [token-intelligence.md](token-intelligence.md) |
| Full portfolio audit with exposure breakdown | 0.10 USDC | [portfolio-audit.md](portfolio-audit.md) |
| Verify a prior mindprint proof by hash | free | [proofs.md](proofs.md) |
| Connect via MCP (Claude Desktop, Cursor, any MCP client) | — | [mcp.md](mcp.md) |

## Quick start — no API key (x402 micropayments)

```bash
./install.sh
```

```bash
# Any card — payment handled automatically via x402
curl https://api.mindprotocol.xyz/v1/cards \
  -H "Content-Type: application/json" \
  -d '{"card": "mind_risk_scoring", "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU"}'
```

The endpoint returns a 402 Payment Required with payment instructions. The agent pays fractions of USDC automatically. No wallet setup, no API key, no registration.

## Quick start — API key (traditional)

```bash
export MIND_API_KEY=your_key_here
./install.sh
```

Get an API key: [mindprotocol.xyz](https://www.mindprotocol.xyz)

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
- x402 payments are sub-cent; agents may call without human approval for any single card

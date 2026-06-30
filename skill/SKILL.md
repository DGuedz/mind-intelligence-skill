---
name: mind-intelligence
description: Complete MIND stack for Solana agents — intelligence layer (Pyth price signals, portfolio analysis, risk scoring, mindprint proofs) + x402 payment lifecycle (HTTP 402 detection, policy gate, human approval, idempotent SPL USDC settlement, proof bundle). Two skills, one install.
user-invocable: true
---

# MIND Skill — Intelligence + x402 Payments

> Two complementary layers for autonomous Solana agents: verify before acting, pay to access, prove what happened.

## Layer 1 — Intelligence (trust layer)

MIND connects agents to native Solana data sources and wraps every response in a **mindprint** — a SHA-256 proof anchored to a specific Solana slot. Tamper-evident, independently verifiable, no reconstruction needed.

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

## Layer 2 — x402 Payment Lifecycle

Complete HTTP 402 payment protocol for agents hitting any paid API on Solana:

```
Agent Intent → Policy Gate → Human Approval → SPL USDC Settlement → TX Confirm → Proof Bundle
```

| Task | Load |
|------|------|
| Understand x402 protocol and when to use it | [x402/SKILL.md](x402/SKILL.md) |
| Full payment flow step-by-step | [x402/docs/payment-flow.md](x402/docs/payment-flow.md) |
| Policy gates, budget limits, allowlist | [x402/docs/policy-gates.md](x402/docs/policy-gates.md) |
| Human approval gate design | [x402/docs/human-approval.md](x402/docs/human-approval.md) |
| Proof bundle and SHA-256 hash chain | [x402/docs/proof-bundle.md](x402/docs/proof-bundle.md) |
| RPC reliability, fallback, retry | [x402/docs/rpc-reliability.md](x402/docs/rpc-reliability.md) |
| Dry run example (no real tx) | [../examples/dry-run.md](../examples/dry-run.md) |

## Quick start

```bash
./install.sh
```

```bash
# Intelligence card — 402 handled automatically by the agent
curl https://api.mindprotocol.xyz/v1/cards \
  -H "Content-Type: application/json" \
  -d '{"card": "mind_risk_scoring", "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU"}'
# → 402 Payment Required with recipient + amountMinor
# → Agent pays via x402 lifecycle (see x402/SKILL.md)
# → 200 + card data + mindprint proof
```

## Key invariants

- Every intelligence response includes a `mindprint` — preserve it; it is the proof of what the agent saw
- Risk score >= 80 → automatic BLOCK; agent must not execute
- x402 settlement requires human approval before real funds move — not bypassable
- Pyth signals carry the Solana slot at query time — verifiable on-chain
- Degraded mode on RPC failure — never claims false success

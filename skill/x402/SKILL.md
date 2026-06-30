---
name: x402-payment-skill
version: 1.0.0
description: |
  Production-grade x402 payment skill for Solana agents. Covers policy validation,
  human approval gating, idempotent settlement, on-chain confirmation, proof bundle
  generation, and degraded-mode fallback — the full Agent-to-Agent payment lifecycle.
license: MIT
author: MIND Protocol (github.com/DGuedz/MIND)
tags: x402, solana, a2a, payments, policy, proof, settlement
compatibility: Claude Code, Codex, Cursor, any MCP-compatible agent
---

# x402-payment-skill

The x402 protocol defines a standard for HTTP 402 Payment Required — a machine-readable
payment handshake between agents and APIs. This skill gives any Solana agent the full
x402 lifecycle: discover the price, check policy, get human approval when needed, settle
on-chain, confirm the transaction, and produce an auditable proof bundle.

**Load only what you need:**

| Task | Load |
|---|---|
| Understand x402 and when to use it | [x402-overview.md](docs/x402-overview.md) |
| Run a payment flow end-to-end | [payment-flow.md](docs/payment-flow.md) |
| Policy gates and blocking rules | [policy-gates.md](docs/policy-gates.md) |
| Proof bundle and receipt format | [proof-bundle.md](docs/proof-bundle.md) |
| RPC reliability and fallback | [rpc-reliability.md](docs/rpc-reliability.md) |
| Human approval gate (HITL) | [human-approval.md](docs/human-approval.md) |

## Quick Start

```
I need to pay 0.50 USDC to <recipient> for access to a data API on Solana.
Use x402-payment-skill to run the full flow in dry_run mode first.
```

## When to Use This Skill

- An agent needs to pay for API access via HTTP 402 Payment Required
- You want policy-controlled, auditable agent payments on Solana
- You need a proof receipt linking payment to a data delivery
- You need human approval before real funds move

## When NOT to Use

- For reading wallet balances → use a balance skill
- For token swaps → use a DEX skill
- For free API calls → no payment skill needed

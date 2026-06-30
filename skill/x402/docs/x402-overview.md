# x402 Overview

x402 is an open protocol that extends HTTP 402 Payment Required into a machine-readable
payment handshake. When an agent hits a paid endpoint, the server returns:

```
HTTP 402 Payment Required
x-payment-required: {"amount": 50000, "currency": "USDC", "recipient": "...", "network": "solana"}
```

The agent reads this header, settles the payment on-chain, attaches the receipt to the
next request, and the server releases the resource.

## Why It Matters for Solana Agents

- **No subscriptions** — agents pay per request, per use
- **On-chain proof** — every payment produces a tx signature on Solana
- **Policy-gated** — the agent can enforce budget limits, allowlists, and risk rules
  before spending funds
- **Auditable** — the full flow (intent → policy → payment → proof → delivery) is
  hash-linked and verifiable

## x402 Modes in This Skill

| Mode | Behavior |
|---|---|
| `dry_run` | Validates inputs and policy, simulates the flow, produces no tx |
| `plan_only` | Shows the full payment plan for human review, no execution |
| `real` | Executes the full flow on Solana mainnet with human approval required |

## The Full Flow

```
Agent Intent
    ↓
Policy Check (budget, allowlist, risk)
    ↓
Human Approval Gate (required for real mode)
    ↓
x402 Settlement on Solana
    ↓
TX Confirmation via RPC
    ↓
Proof Bundle (receiptHash + txSignature + dossierHash)
    ↓
Data Delivery
```

See [payment-flow.md](payment-flow.md) for the step-by-step implementation.

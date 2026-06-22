# Mindprint Proofs

Every MIND tool response includes a `mindprint` — a tamper-evident proof of the on-chain state at the exact Solana slot when the query was executed.

## What a mindprint is

```json
{
  "mindprint": {
    "hash": "0xabc123...",
    "slot": 312948201,
    "proof_url": "https://api.mind.so/v1/proof/0xabc123..."
  }
}
```

- `hash` — SHA-256 of `(query_inputs + response_payload + slot)` — deterministic, reproducible
- `slot` — Solana slot at execution time; links proof to chain state
- `proof_url` — public endpoint to verify the proof independently

## Tool: `mind_verify_proof`

Verify any mindprint hash independently.

```json
{
  "delivery_hash": "0xabc123..."
}
```

Returns whether the proof is valid, the original query inputs, and the slot height.

## Why this matters for agents

Without proofs, agents can claim anything. A mindprint lets you:

1. **Audit why an agent acted** — retrieve the price signal or risk score it saw
2. **Detect tampering** — if inputs were modified, the hash won't match
3. **Compliance trail** — attach mindprint hashes to trade logs, DeFi transactions, or approval records

## Usage pattern

```
1. Execute any MIND tool (signals, portfolio, risk)
2. Extract mindprint.hash from response
3. Store hash alongside the downstream action (e.g., transaction signature)
4. Later: call mind_verify_proof(hash) to reconstruct the agent's decision context
```

## Verification endpoint

```
GET https://api.mind.so/v1/proof/{hash}
```

Public, no auth required. Returns 200 with proof data or 404 if not found.

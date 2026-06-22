# Risk Scoring

Concentration risk analysis for Solana wallets. Returns a 0–100 score and a PASS/BLOCK decision. Score >= 80 must halt execution.

## Tool: `mind_risk_scoring`

```json
{
  "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU"
}
```

**Response shape**

```json
{
  "wallet": "7xKXtg...",
  "risk_score": 85,
  "decision": "BLOCK",
  "factors": [
    { "factor": "single_token_concentration", "contribution": 55, "detail": "JUP = 71% of portfolio" },
    { "factor": "illiquid_tail",              "contribution": 30, "detail": "3 tokens < $10 liquidity" }
  ],
  "mindprint": {
    "hash": "0x789...",
    "slot": 312948210,
    "proof_url": "https://api.mind.so/v1/proof/0x789..."
  }
}
```

## Decision thresholds

| Score | Decision | Agent behavior |
|-------|----------|----------------|
| 0–59  | PASS     | Proceed normally |
| 60–79 | WARN     | Proceed with user confirmation |
| 80–100| BLOCK    | **Halt. Do not execute. Surface to user.** |

## Risk factors computed

- `single_token_concentration` — largest single token % of portfolio
- `illiquid_tail` — tokens with <$50 market liquidity
- `stablecoin_shortfall` — % in non-stablecoin assets
- `wallet_age` — on-chain account age (new wallets = higher risk)

## Agent usage pattern

```
Before any trade or DeFi execution:
1. Call mind_risk_scoring with the acting wallet
2. If decision == "BLOCK": stop, return error to user with mindprint hash
3. If decision == "WARN": surface factors and request confirmation
4. If decision == "PASS": proceed; log mindprint with transaction record
```

## Invariant

BLOCK decisions are non-negotiable. Agents must not override or retry-around a BLOCK without explicit user instruction and fresh re-scoring.

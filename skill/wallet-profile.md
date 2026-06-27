# Wallet Profile

Behavioral fingerprint of a Solana wallet. Answers "who is this wallet?" — not just what they hold, but how they act on-chain.

## Tool: `mind_wallet_profile`

```json
{
  "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU"
}
```

**Response shape**

```json
{
  "wallet": "7xKXtg...",
  "profile": {
    "age_days": 312,
    "archetype": "DeFi Power User",
    "activity_score": 78,
    "preferred_protocols": ["Jupiter", "Orca", "Marinade"],
    "token_preference": ["large_cap", "liquid"],
    "avg_tx_frequency": "4.2/day",
    "avg_position_size_usd": 1840,
    "last_active": "2026-06-26T14:22:00Z",
    "notable_behaviors": [
      "frequent_rebalancer",
      "staking_participant",
      "nft_collector_inactive"
    ]
  },
  "mindprint": {
    "hash": "0xbcd...",
    "slot": 312948220,
    "proof_url": "https://api.mindprotocol.xyz/v1/proof/0xbcd..."
  }
}
```

## Archetypes

| Archetype | Description |
|-----------|-------------|
| `DeFi Power User` | High frequency, multiple protocols, active rebalancer |
| `Long-term Holder` | Low tx frequency, concentrated positions, rarely moves |
| `NFT Trader` | High NFT volume, marketplace activity dominant |
| `Bot / Programmatic` | Sub-second tx patterns, likely automated |
| `New Entrant` | < 30 days, limited protocol exposure |
| `Institutional` | Large positions, custody patterns, low frequency |

## Payment

0.025 USDC per call via x402.

## Use cases

- KYC-light onboarding: understand a user's on-chain history before granting access
- Personalization: route users to relevant DeFi products based on archetype
- Risk context: combine with `mind_risk_scoring` for full picture
- A2A trust: one agent evaluating another agent's wallet before coordinating

## Agent usage pattern

```
When a user or agent introduces a new wallet address:
1. Call mind_wallet_profile(wallet=<address>)
2. Use archetype to calibrate risk tolerance and product suggestions
3. Use notable_behaviors to flag unusual patterns
4. Store mindprint for session audit trail
```

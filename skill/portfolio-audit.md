# Portfolio Audit

Full portfolio risk breakdown for a Solana wallet. Combines balance data, concentration risk, DeFi exposure, and token safety into a single structured report — with a single mindprint covering the entire audit.

## Tool: `mind_portfolio_audit`

```json
{
  "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU",
  "include_defi": true,
  "include_token_checks": true
}
```

**Parameters**
- `wallet` (required): Solana public key
- `include_defi` (optional, default true): include open DeFi positions (LP, staking, lending)
- `include_token_checks` (optional, default true): run `mind_token_intelligence` on each significant holding

**Response shape**

```json
{
  "wallet": "7xKXtg...",
  "total_value_usd": 24820,
  "risk_score": 62,
  "risk_level": "WARN",
  "summary": {
    "holdings_count": 8,
    "concentration_risk": "MEDIUM",
    "dominant_asset": "SOL (48%)",
    "stablecoin_pct": 12.4,
    "defi_exposure_pct": 31.2
  },
  "holdings": [
    { "token": "SOL",  "usd": 11914, "pct": 48.0, "safety": "SAFE" },
    { "token": "JUP",  "usd": 5628,  "pct": 22.7, "safety": "SAFE" },
    { "token": "USDC", "usd": 3080,  "pct": 12.4, "safety": "SAFE" },
    { "token": "BONK", "usd": 1820,  "pct": 7.3,  "safety": "CAUTION" }
  ],
  "defi_positions": [
    { "protocol": "Marinade", "type": "staking", "usd": 7744, "pct": 31.2 }
  ],
  "risk_factors": [
    { "factor": "single_asset_concentration", "detail": "SOL = 48% of portfolio" },
    { "factor": "low_stablecoin_buffer", "detail": "12.4% — below recommended 20%" }
  ],
  "recommendations": [
    "Increase stablecoin allocation to reduce downside exposure",
    "BONK position warrants monitoring — see token intelligence flags"
  ],
  "mindprint": {
    "hash": "0xefg...",
    "slot": 312948250,
    "proof_url": "https://api.mindprotocol.xyz/v1/proof/0xefg..."
  }
}
```

## Payment

0.10 USDC per call via x402. Covers the full audit including token checks on each holding.

## When to use

- Institutional onboarding: audit a wallet before granting protocol access
- Periodic health check: scheduled agent runs a weekly portfolio audit
- Pre-trade: deep check before large position changes
- Compliance reporting: mindprint provides tamper-evident snapshot of state at audit time

## Agent usage pattern

```
For a comprehensive wallet review:
1. Call mind_portfolio_audit(wallet=<address>, include_defi=true)
2. Surface risk_score and risk_level to user first
3. Walk through risk_factors and recommendations
4. For any holding with safety == "UNSAFE": escalate immediately
5. Store mindprint as audit record — it covers the full session
```

## Difference from other cards

| Card | Scope | Price | Use when |
|------|-------|-------|----------|
| `mind_risk_scoring` | Concentration risk only | 0.0154 USDC | Quick pre-trade check |
| `mind_portfolio_audit` | Full portfolio + DeFi + token checks | 0.10 USDC | Comprehensive review |

# Token Intelligence

Token safety analysis for any Solana SPL token. Holder concentration, insider wallets, liquidity risk, and rug indicators — before your agent or user enters a position.

## Tool: `mind_token_intelligence`

```json
{
  "mint": "JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN",
  "checks": ["holder_concentration", "insider_flags", "liquidity_depth", "rug_indicators"]
}
```

**Parameters**
- `mint` (required): SPL token mint address
- `checks` (optional): subset of analysis modules. Defaults to all four.

**Response shape**

```json
{
  "mint": "JUPyiwrY...",
  "symbol": "JUP",
  "safety_score": 91,
  "verdict": "SAFE",
  "analysis": {
    "holder_concentration": {
      "top_10_pct": 28.4,
      "top_holder_pct": 6.1,
      "risk": "LOW"
    },
    "insider_flags": {
      "team_wallets_identified": 3,
      "team_holdings_pct": 12.1,
      "recent_team_sells": false,
      "risk": "LOW"
    },
    "liquidity_depth": {
      "total_liquidity_usd": 48200000,
      "largest_pool": "Jupiter-SOL",
      "slippage_1k_usd": 0.04,
      "risk": "LOW"
    },
    "rug_indicators": {
      "mint_authority_revoked": true,
      "freeze_authority_revoked": true,
      "contract_upgradeable": false,
      "risk": "LOW"
    }
  },
  "mindprint": {
    "hash": "0xcde...",
    "slot": 312948230,
    "proof_url": "https://api.mindprotocol.xyz/v1/proof/0xcde..."
  }
}
```

## Safety score thresholds

| Score | Verdict | Meaning |
|-------|---------|---------|
| 80–100 | SAFE | Standard protocols, low concentration, healthy liquidity |
| 50–79 | CAUTION | Some flags — elevated concentration or limited liquidity |
| 0–49 | UNSAFE | Hard flags — revocable mint, extreme concentration, or insider selling |

## Payment

0.035 USDC per call via x402.

## Agent usage pattern

```
Before adding a new token to a portfolio or recommending a purchase:
1. Call mind_token_intelligence(mint=<token_mint>)
2. If verdict == "UNSAFE": block recommendation. Surface flags to user.
3. If verdict == "CAUTION": present flags explicitly before any action
4. If verdict == "SAFE": proceed. Attach mindprint to trade record.
```

## Key flags that trigger UNSAFE

- Mint authority not revoked (issuer can print unlimited supply)
- Top 3 wallets hold > 50% of supply
- Team wallets sold > 20% of holdings in last 30 days
- Liquidity < $50k (exit risk)

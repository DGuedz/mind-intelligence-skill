# Portfolio Analysis

On-chain wallet intelligence: token balances and portfolio composition for any Solana wallet, via the `mind_market_intelligence` MCP tool.

## Tool: `mind_market_intelligence`

### Get token balances

```json
{
  "query": "get token balances for this wallet",
  "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU",
  "action": "get_balances"
}
```

### Get full portfolio composition

```json
{
  "query": "analyze portfolio concentration",
  "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU",
  "action": "get_portfolio"
}
```

**Response shape**

```json
{
  "wallet": "7xKXtg...",
  "balances": [
    { "token": "SOL",  "amount": 12.5,  "usd_value": 1854.0,  "pct": 62.1 },
    { "token": "JUP",  "amount": 2000,  "usd_value": 840.0,   "pct": 28.1 },
    { "token": "BONK", "amount": 5000000, "usd_value": 295.0, "pct": 9.8 }
  ],
  "total_usd": 2989.0,
  "mindprint": {
    "hash": "0xdef...",
    "slot": 312948205,
    "proof_url": "https://api.mind.so/v1/proof/0xdef..."
  }
}
```

## Agent usage pattern

```
1. Call get_balances to enumerate positions
2. Call get_portfolio for concentration breakdown (pct fields)
3. Feed portfolio into mind_risk_scoring before any trade execution
4. Store mindprint with the snapshot for compliance/audit
```

## Notes

- Data sourced from Covalent/GoldRush — covers all SPL tokens with USD pricing
- `pct` is % of total portfolio USD value
- Zero-balance tokens are omitted from response

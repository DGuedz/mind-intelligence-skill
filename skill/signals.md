# Price Signals

Real-time price and momentum indicators from Pyth oracle, via the `mind_signals` MCP tool.

## Tool: `mind_signals`

```json
{
  "asset": "SOL",
  "rules": ["latest_price", "price_momentum_15m", "price_momentum_1h", "price_momentum_24h"]
}
```

**Parameters**
- `asset` (required): Token symbol. Supported: SOL, JUP, BONK, USDC, USDT, WETH, WBTC, RAY, MSOL, STSOL, HNT
- `rules` (optional): Subset of signal rules to compute. Defaults to `["latest_price"]`.

**Response shape**

```json
{
  "asset": "SOL",
  "signals": {
    "latest_price": { "value": 148.32, "confidence": 0.12, "timestamp": "2026-06-22T14:00:00Z" },
    "price_momentum_15m": { "value": 0.42, "direction": "up" },
    "price_momentum_1h":  { "value": -0.8, "direction": "down" },
    "price_momentum_24h": { "value": 3.1,  "direction": "up" }
  },
  "mindprint": {
    "hash": "0xabc...",
    "slot": 312948201,
    "proof_url": "https://api.mindprotocol.xyz/v1/proof/0xabc..."
  }
}
```

## Agent usage pattern

```
1. Call mind_signals with the asset and desired rules
2. Read latest_price for entry/exit decisions
3. Use momentum signals as confirmation (not as sole signal)
4. Store mindprint.hash with the trade record for auditability
```

## Important

- `confidence` is Pyth's price confidence interval in USD
- Momentum values are % change over the window; direction is derived
- Always log `mindprint.hash` — it proves what price the agent saw at decision time

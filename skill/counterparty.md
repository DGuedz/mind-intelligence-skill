# Counterparty Check

Quick pre-transaction safety check for any Solana wallet. Designed for agents that need a go/no-go in under 200ms before executing a transfer, swap, or DeFi action.

## Tool: `mind_counterparty_check`

```json
{
  "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU",
  "context": "swap"
}
```

**Parameters**
- `wallet` (required): Solana public key to check
- `context` (optional): `"swap"` | `"transfer"` | `"nft"` | `"defi"` — tunes the signal weights

**Response shape**

```json
{
  "wallet": "7xKXtg...",
  "verdict": "SAFE",
  "flags": [],
  "confidence": 0.91,
  "mindprint": {
    "hash": "0xabc...",
    "slot": 312948210,
    "proof_url": "https://api.mindprotocol.xyz/v1/proof/0xabc..."
  }
}
```

**Verdict values**

| Verdict | Meaning | Agent action |
|---------|---------|--------------|
| `SAFE` | No flags detected | Proceed |
| `CAUTION` | Minor flags (new wallet, low activity) | Proceed with reduced amount or confirmation |
| `BLOCK` | Hard flag (blacklisted, exploit-linked, mixer) | Do not transact. Surface to user. |

## Flags checked

- `blacklisted` — wallet on known exploit or sanction list
- `mixer_linked` — recent interaction with mixing protocols
- `new_wallet` — account created < 7 days ago
- `dormant_sudden_activity` — inactive > 90 days, large sudden tx
- `drainer_pattern` — behavioral match to known drainer wallets

## Payment

0.015 USDC per call via x402 (no API key needed). Fastest card — optimized for pre-tx latency.

## Agent usage pattern

```
Before any outbound transfer or swap to an unknown address:
1. Call mind_counterparty_check(wallet=<recipient>, context=<action_type>)
2. If verdict == "BLOCK": abort. Do not suggest retrying.
3. If verdict == "CAUTION": reduce exposure or ask user to confirm
4. If verdict == "SAFE": proceed. Log mindprint with transaction.
```

## Difference from mind_risk_scoring

`mind_counterparty_check` — fast, binary, evaluates the *recipient*. Use before any outbound action.
`mind_risk_scoring` — deep analysis, evaluates the *acting wallet's* concentration risk. Use for portfolio decisions.

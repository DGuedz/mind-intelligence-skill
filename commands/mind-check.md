# /mind-check

Pre-flight intelligence check before any DeFi action. Runs signals + risk scoring in parallel and surfaces a go/no-go.

## Usage

```
/mind-check SOL <wallet_address>
```

## What it does

1. Fetches latest price + 1h/24h momentum for the asset
2. Scores concentration risk for the wallet
3. Returns a structured summary with mindprint hashes

## Output

```
MIND Pre-flight Check
─────────────────────
Asset:     SOL @ $148.32 (1h: -0.8% | 24h: +3.1%)
Wallet:    7xKXtg...
Risk:      62/100 → WARN (JUP concentration: 71%)
Decision:  PROCEED WITH CAUTION

Proofs:
  signals  → 0xabc123...
  risk     → 0xdef456...

Verify: https://api.mind.so/v1/proof/{hash}
```

## When decision is BLOCK

The command returns non-zero exit and prints:

```
BLOCK — Risk score 85/100. Reason: single token concentration (JUP: 71%).
Do not proceed. Proof: 0x789...
```

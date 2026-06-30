# Example: Dry Run Payment

This example shows a complete x402 dry run — validates all inputs, runs policy,
produces a simulated receipt, but moves no real funds.

## Prompt

```
Use x402-payment-skill to run a dry_run payment:
- amount: 50000 (0.50 USDC)
- recipient: 7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU
- reference: pay_demo_001
- network: solana
- policy: ALLOW
```

## Expected Output

```json
{
  "decision": "ALLOW",
  "settlement_status": "dry_run",
  "payment_reference": "pay_demo_001",
  "idempotency_key": "a3f4...c9e1",
  "tx_signature": null,
  "confirmation_status": "not_attempted",
  "reconciliation_status": "not_applicable",
  "degraded_mode": false,
  "reason_codes": [],
  "required_followups": [],
  "evidence": {
    "mode": "dry_run",
    "policy_gate": "ALLOW",
    "amount_minor": 50000,
    "currency": "USDC",
    "recipient": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU",
    "network": "solana",
    "receipt_hash": "sha256:preview_only",
    "note": "No transaction submitted. Switch to mode=real with human approval to execute."
  }
}
```

## What This Demonstrates

- Policy gate ran and returned ALLOW
- Idempotency key was generated
- No tx was submitted (dry_run)
- Output is fully structured — no bare strings
- Agent can use this output to show the user what would happen before committing

# Policy Gates

Every x402 payment must pass all gates before execution. A single BLOCK stops the flow.

## Gate Checklist

| Gate | Check | Block Reason Code |
|---|---|---|
| Policy decision | `policy_decision.decision === "ALLOW"` | `RC_POLICY_VIOLATION` |
| Amount limit | `amountMinor <= agent.maxAmountMinor` | `RC_BUDGET_EXCEEDED` |
| Recipient | Recipient in allowlist OR risk score acceptable | `RC_POLICY_VIOLATION` |
| Budget | Cumulative spend within period budget | `RC_BUDGET_EXCEEDED` |
| Human approval | Present and valid for `real` mode | `RC_HIGH_RISK_NO_APPROVAL` |
| Idempotency key | Present and not a known duplicate | `RC_MISSING_IDEMPOTENCY_KEY` |
| Network | `network === "solana"` | `RC_POLICY_VIOLATION` |
| TX confirmation | Confirmed before claiming success | `RC_TOOL_FAILURE` |
| Reconciliation | All fields match confirmed tx | `RC_RECONCILIATION_MISMATCH` |

## Reason Codes

```
RC_POLICY_VIOLATION           — request violates a hard policy rule
RC_BUDGET_EXCEEDED            — amount exceeds agent budget or period limit
RC_HIGH_RISK_NO_APPROVAL      — real settlement attempted without human approval
RC_MISSING_IDEMPOTENCY_KEY    — idempotency_key absent
RC_TOOL_FAILURE               — RPC, KMS, or execution tool failed
RC_RATE_LIMIT_OR_RPC_BLOCKED  — RPC returned 429 or is unreachable
RC_RECONCILIATION_MISMATCH    — confirmed tx fields don't match payment request
INSUFFICIENT_EVIDENCE         — required fields missing; cannot make a decision
```

## What NEVER to Do

- Claim `decision: "ALLOW"` without a confirmed tx signature in real mode
- Execute real settlement without `human_approval_receipt`
- Expose private keys, seed phrases, KMS secrets, or bearer tokens in output
- Skip idempotency check — duplicate payments are a critical safety failure
- Return success when RPC is blocked or confirmation failed

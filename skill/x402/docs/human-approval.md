# Human Approval Gate (HITL)

Real x402 settlement on Solana moves actual funds. This skill enforces a hard
Human-In-The-Loop gate before any real transaction is executed.

## When Approval is Required

- `mode === "real"` always requires `human_approval_receipt`
- `dry_run` and `plan_only` do not require approval
- Missing approval in real mode → `NEEDS_HUMAN_APPROVAL` + `RC_HIGH_RISK_NO_APPROVAL`

## Approval Receipt Schema

```typescript
interface HumanApprovalReceipt {
  approvedBy: string;        // identifier of the approving human/system
  approvedAt: string;        // ISO 8601
  paymentReference: string;  // must match the payment being approved
  amountMinor: number;       // must match exactly
  currency: string;
  recipient: string;
  approvalHash: string;      // SHA-256(approvedBy + approvedAt + paymentReference + amountMinor)
  channel: "telegram" | "slack" | "email" | "api" | "cli";
  expiresAt: string;         // approval is time-bounded, typically 5 minutes
}
```

## Validation Rules

- `paymentReference` in approval must match the active payment
- `amountMinor` and `currency` must match exactly — no rounding
- `expiresAt` must be in the future
- `approvalHash` must be verifiable
- Expired or mismatched approvals → `BLOCK` with `RC_HIGH_RISK_NO_APPROVAL`

## Implementation Pattern (Telegram Example)

```
Agent → "Requesting approval to pay 0.50 USDC to <recipient> for <resource>"
Human → ✅ Approve / ❌ Reject
Agent ← approval_receipt (if approved) or BLOCK (if rejected/timeout)
```

## Why This Exists

Autonomous agents can be compromised, misconfigured, or given incorrect inputs.
A human gate before real settlement is the last safety rail. It cannot be bypassed,
disabled by prompt, or skipped via any input flag.

The gate applies even when the policy engine returns `ALLOW`. Policy says "this
type of payment is permitted." The human gate says "this specific payment, right now,
with these amounts, to this recipient, is approved."

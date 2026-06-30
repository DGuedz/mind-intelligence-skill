# Payment Flow

## Step 1 — Parse the 402 Response

When the target API returns HTTP 402, extract the payment requirements:

```typescript
const paymentRequired = {
  amountMinor: 50000,        // 0.50 USDC in minor units (6 decimals)
  currency: "USDC",
  recipient: "<recipient_address>",
  reference: "<payment_reference>",
  network: "solana",
};
```

## Step 2 — Run Policy Check

Before spending, validate against the agent's policy:

```typescript
const policy = {
  decision: "ALLOW" | "BLOCK" | "INSUFFICIENT_EVIDENCE",
  reason_codes: [],          // e.g. RC_BUDGET_EXCEEDED, RC_POLICY_VIOLATION
  confidence: 0.95,
};
```

**Block if:** budget exceeded, recipient not in allowlist, amount above limit,
or policy decision is not `ALLOW`. See [policy-gates.md](policy-gates.md).

## Step 3 — Generate Idempotency Key

```typescript
const idempotencyKey = sha256([
  paymentReference,
  amountMinor.toString(),
  currency,
  recipientAddress,
  network,
].join(":"));
```

One key = one payment. Duplicate requests return the existing result.

## Step 4 — Human Approval (required for real mode)

For real settlement, the agent must obtain explicit human approval before
executing. See [human-approval.md](human-approval.md).

```typescript
if (mode === "real" && !humanApprovalReceipt) {
  return { decision: "NEEDS_HUMAN_APPROVAL", reason_codes: ["RC_HIGH_RISK_NO_APPROVAL"] };
}
```

## Step 5 — Settle on Solana

```typescript
// Send USDC via SPL Token transfer on Solana
const txSignature = await connection.sendTransaction(transaction, [payer]);
```

**On failure:** enter degraded mode. Do not claim success without a tx signature.

## Step 6 — Confirm Transaction

```typescript
const confirmation = await connection.confirmTransaction(txSignature, "confirmed");
// Retry up to maxRetries with retryDelayMs backoff on RPC failures
```

## Step 7 — Build Proof Bundle

```typescript
const receipt = {
  protocol: "x402",
  version: "mind-x402-receipt-v1",
  receiptHash: sha256(canonicalPayload),
  payloadHash: sha256(rawPayload),
  txSignature,
  idempotencyKey,
  reconciliationStatus: "confirmed",
};
```

See [proof-bundle.md](proof-bundle.md) for the full receipt schema.

## Step 8 — Attach Receipt and Retry Request

```typescript
const response = await fetch(apiUrl, {
  headers: { "x-payment-receipt": JSON.stringify(receipt) }
});
```

## Minimum Required Output

```typescript
{
  decision: "ALLOW" | "BLOCK" | "INSUFFICIENT_EVIDENCE" | "NEEDS_HUMAN_APPROVAL",
  settlement_status: "confirmed" | "failed" | "dry_run" | "pending",
  payment_reference: string,
  idempotency_key: string,
  tx_signature: string | null,
  confirmation_status: "confirmed" | "failed" | "not_attempted",
  reconciliation_status: "confirmed" | "pending" | "failed" | "not_applicable",
  degraded_mode: boolean,
  reason_codes: string[],
  required_followups: string[],
  evidence: object,
}
```

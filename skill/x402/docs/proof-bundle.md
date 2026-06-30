# Proof Bundle

Every completed x402 payment produces a proof bundle — a hash-linked receipt
that ties together the intent, the payment, and the data delivery.

## Receipt Schema

```typescript
interface X402Receipt {
  protocol: "x402";
  version: "mind-x402-receipt-v1";
  receiptType: "subsidy_receipt" | "payment_requirement" | "settlement_preflight";
  status: "confirmed" | "subsidy_receipt_recorded" | "payment_required";
  issuedAt: string;                // ISO 8601
  guardedMode: boolean;            // true = no real on-chain tx
  receiptHash: string;             // SHA-256 of canonicalPayload
  payloadHash: string;             // SHA-256 of raw input
  idempotencyKey: string;
  settlementClaimed: boolean;
  reconciliationStatus: "not_applicable" | "pending_tx" | "confirmed";
  reconciliationPlan: {
    requiredFields: string[];
    pendingField: string | null;
    note: string;
  };
  x402Header: {
    amountMinor: number;
    currency: string;
    recipient: string;
    reference: string;
    network: string;
  } | null;
  canonicalPayload: {             // All inputs, deterministic, used for receiptHash
    intentId: string;
    agentId: string;
    cardId: string;
    mode: string;
    amountMinor: number;
    currency: string;
    recipient: string;
    idempotencyKey: string;
    network: string;
    source: string;
    policyContextHash: string;
    txSignature: string | null;
  };
}
```

## Five-Step Hash Chain

The full flow produces five hashes, one per step:

```
intentHash      = SHA-256(intentId + agentId + cardId + timestamp)
policyHash      = SHA-256(policyDecision + intentHash)
receiptHash     = SHA-256(canonicalPayload)           ← x402 receipt
proofHash       = SHA-256(receiptHash + txSignature)  ← on-chain proof
dossierHash     = SHA-256(all five hashes)            ← full dossier
```

## What Makes a Valid Proof

- `settlementClaimed: true` requires `txSignature` to be non-null
- `reconciliationStatus: "confirmed"` requires confirmed tx fields to match request
- `guardedMode: false` means real on-chain settlement occurred
- `receiptHash` must be reproducible from `canonicalPayload`

## Using the Receipt

Attach the receipt to the next request to prove payment:

```
x-payment-receipt: <base64(JSON.stringify(receipt))>
```

The API verifies the receipt hash and releases the resource.

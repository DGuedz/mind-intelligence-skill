# RPC Reliability

x402 settlement depends on Solana RPC. This skill includes a reliability layer
with retry, fallback, timeout, and health reporting.

## Configuration

```typescript
const rpcConfig = {
  primaryUrl:   process.env.HELIUS_RPC_URL ?? "https://api.mainnet-beta.solana.com",
  fallbackUrl:  "https://api.mainnet-beta.solana.com",
  timeoutMs:    5000,   // abort slow RPC calls
  maxRetries:   2,
  retryDelayMs: 800,
};
```

## Retry Logic

```
Attempt 1 → primaryUrl
  ↓ (fail / timeout)
Attempt 2 → primaryUrl (after retryDelayMs)
  ↓ (fail)
Attempt 3 → fallbackUrl
  ↓ (fail)
BLOCK with RC_RATE_LIMIT_OR_RPC_BLOCKED
```

## Health Check Response

```typescript
interface RpcHealthReport {
  status: "ok" | "degraded" | "unavailable";
  provider: string;
  providerClass: "helius" | "public_rpc" | "fallback";
  latencyMs: number | null;
  slot: number | null;
  usingFallback: boolean;
  reason_code: "ok" | "RC_RATE_LIMIT_OR_RPC_BLOCKED" | "RC_TOOL_FAILURE";
  checkedAt: string;
}
```

## Degraded Mode

When RPC fails after all retries:
- Set `degraded_mode: true` in output
- Set `decision: "BLOCK"`
- Add `RC_RATE_LIMIT_OR_RPC_BLOCKED` to reason_codes
- Do NOT claim settlement success
- Return `required_followups: ["retry_confirmation", "manual_reconciliation"]`

## Recommended RPC Providers

| Provider | Use case |
|---|---|
| Helius (`helius.dev`) | Primary — low latency, high reliability |
| `api.mainnet-beta.solana.com` | Fallback — free, rate-limited |
| `api.devnet.solana.com` | Development / testing only |

Set `HELIUS_RPC_URL` in your environment for best results.

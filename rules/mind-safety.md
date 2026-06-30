# MIND Safety Rules

These rules apply whenever the mind-intelligence-skill is active.

## Non-negotiable invariants

1. **BLOCK is final.** If `mind_risk_scoring` returns `decision: "BLOCK"`, the agent must halt immediately. No retry, no override, no soft suggestion to proceed.

2. **Never fabricate proofs.** Do not generate, guess, or reconstruct `mindprint` hashes. If a MIND tool call fails, report the failure — do not continue as if it succeeded.

3. **Preserve mindprint fields.** Every MIND response includes a `mindprint` object. Never strip it from output — downstream agents and auditors depend on it.

4. **Do not bypass x402 payment.** If the API returns `402 Payment Required`, process it through the payment flow. Do not retry without payment or assume the resource is free.

5. **Private keys stay private.** Never log, display, or include wallet private keys or seed phrases in tool call arguments, outputs, or reasoning traces.

# mind-intelligence-skill

> The trust layer for A2A agents on Solana. Verified market data from native on-chain sources — every decision leaves a cryptographic proof tied to a Solana slot.

A skill for the [Solana AI Kit](https://github.com/solanabr/solana-ai-kit).

---

## The problem A2A agents face

When two autonomous agents coordinate a financial action on Solana — one scanning signals, another executing a swap, a third approving the risk — each one needs to trust what the others saw. Right now there is no standard for that trust.

An agent can say "I checked the price before acting." But:
- Which oracle? At which slot?
- Was the data tampered with between source and decision?
- If something goes wrong, what exactly did the agent see?

Without answers to these questions, A2A coordination is a black box. Audits fail. Compliance is impossible. Debugging is guesswork.

## What MIND adds

MIND is not a generic data API. It connects agents directly to **native Solana data sources** — Pyth oracle (on-chain price feeds) and Covalent/GoldRush (SPL token indexing) — and wraps every response in a **mindprint**: a SHA-256 proof of `(inputs + response + Solana slot)`.

The slot anchor is the key. It ties the data to a specific moment in Solana's verifiable history. Any party can reconstruct and verify the proof independently.

| Tool | Source | What it proves |
|------|--------|----------------|
| `mind_signals` | Pyth oracle (on-chain) | Price + momentum at a specific slot |
| `mind_market_intelligence` | Covalent/GoldRush | Portfolio state at query time |
| `mind_risk_scoring` | MIND engine | Risk decision (PASS/WARN/BLOCK) with full input hash |
| `mind_verify_proof` | MIND proofs API | That a prior agent decision used unmodified data |

This is the trust layer A2A protocols need to operate on Solana without a human in the loop for every action.

## Install

```bash
export MIND_API_KEY=your_key_here
./install.sh
```

Get an API key: [mindprotocol.xyz](https://www.mindprotocol.xyz)

## Skill structure

```
skill/
  SKILL.md         ← entry point
  signals.md       ← Pyth price signals
  portfolio.md     ← wallet/portfolio analysis
  risk.md          ← risk scoring + PASS/BLOCK gate
  proofs.md        ← mindprint verification
  mcp.md           ← MCP server setup
agents/
  mind-trader-agent.md   ← reference A2A agent config
commands/
  mind-check.md          ← /mind-check pre-flight command
```

## Usage in an A2A flow

An execution agent requests a risk check before swapping:

```
Check risk on wallet 7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU before I execute.
```

MIND calls `mind_risk_scoring`, returns PASS/BLOCK, and attaches a mindprint. The execution agent records the hash alongside the transaction. Later, any auditor can verify:

```
GET https://api.mindprotocol.xyz/v1/proof/{hash}
```

Returns the exact inputs and response the agent used — tied to the Solana slot at decision time. Not reconstructed. Not approximated. The original proof.

## Why this is different from other skills in the kit

Skills like sendaifun/skills and jup-ag/agent-skills execute DeFi actions. MIND is the pre-flight layer that makes those actions auditable. It answers the question every A2A protocol eventually hits: *how do you prove the agent acted on real, unmodified data?*

No other skill in the kit produces tamper-evident audit trails per tool call. That is the gap MIND fills.

## License

MIT

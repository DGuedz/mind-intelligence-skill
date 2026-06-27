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
git clone https://github.com/mindprotocol/mind-intelligence-skill
cd mind-intelligence-skill
./install.sh
```

No API key required for x402 mode. The agent pays per call in USDC fractions automatically.

## Two ways to use

### Option 1 — x402 micropayments (no registration)

```bash
curl https://api.mindprotocol.xyz/v1/cards \
  -H "Content-Type: application/json" \
  -d '{"card": "mind_risk_scoring", "wallet": "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU"}'
```

The agent receives a `402 Payment Required` response with USDC payment instructions. Payment is automatic for any agent with a funded wallet. No signup, no API key, no dashboard.

### Option 2 — API key (MCP / Claude Desktop)

```bash
export MIND_API_KEY=your_key_here
./install.sh
```

Get an API key: [mindprotocol.xyz](https://www.mindprotocol.xyz)

## Intelligence cards

| Card | What it returns | Price |
|------|-----------------|-------|
| `mind_signals` | Pyth price + momentum at current Solana slot | 0.010 USDC |
| `mind_counterparty_check` | Safe/Caution/Block verdict for a recipient wallet | 0.015 USDC |
| `mind_risk_scoring` | Concentration risk score (0–100) + PASS/WARN/BLOCK | 0.0154 USDC |
| `mind_market_intelligence` | Full SPL token balances + portfolio composition | 0.020 USDC |
| `mind_wallet_profile` | Behavioral archetype + activity fingerprint | 0.025 USDC |
| `mind_token_intelligence` | Holder concentration + insider flags + rug indicators | 0.035 USDC |
| `mind_portfolio_audit` | Full portfolio risk report + DeFi exposure + token checks | 0.10 USDC |
| `mind_verify_proof` | Verify any mindprint hash | free |

## Skill structure

```
skill/
  SKILL.md               ← entry point (progressive loading)
  signals.md             ← Pyth price signals
  portfolio.md           ← wallet/portfolio analysis
  counterparty.md        ← pre-tx counterparty check
  risk.md                ← risk scoring + PASS/BLOCK gate
  wallet-profile.md      ← behavioral fingerprint
  token-intelligence.md  ← token safety analysis
  portfolio-audit.md     ← full portfolio audit
  proofs.md              ← mindprint verification
  mcp.md                 ← MCP server setup
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

No other skill in the kit produces tamper-evident audit trails per tool call — and no other skill accepts autonomous micropayments without requiring a human to register or manage an API key.

## MIND Builder Program

Build a skill using MIND intelligence cards and earn **20% of every call it generates** — paid weekly to your Solana wallet.

Open to all Superteam Brasil members and Solana builders globally.

[See BUILDERS.md for details and registration →](BUILDERS.md)

## License

MIT

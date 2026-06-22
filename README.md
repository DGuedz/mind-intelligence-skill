# mind-intelligence-skill

> Auditable agent intelligence for Solana. Price signals, portfolio analysis, and risk scoring — every response carries a cryptographic mindprint proof anchored to a Solana slot.

A skill for the [Solana AI Kit](https://github.com/solanabr/solana-ai-kit).

---

## The problem

Agents that trade, rebalance, or execute DeFi actions on Solana have no standard way to:

1. Get real-time price context from a trusted on-chain oracle
2. Assess portfolio risk before acting
3. **Prove what data they saw** when they made a decision

Without (3), agent actions are a black box. When something goes wrong, there is no audit trail.

## What this skill adds

| Tool | Source | Output |
|------|--------|--------|
| `mind_signals` | Pyth oracle | Price + momentum (15m / 1h / 24h) |
| `mind_market_intelligence` | Covalent/GoldRush | Wallet balances, portfolio composition |
| `mind_risk_scoring` | MIND engine | Concentration risk score + PASS/WARN/BLOCK |
| `mind_verify_proof` | MIND proofs API | Verify any prior mindprint hash |

Every response includes a **mindprint** — a SHA-256 hash of `(inputs + response + Solana slot)` that lets anyone independently verify what the agent saw at decision time.

## Install

```bash
export MIND_API_KEY=your_key_here
./install.sh
```

Adds the MIND MCP server to your Claude Desktop / Claude Code config. Restart your client to activate.

Get an API key: [mind.so](https://mind.so)

## Skill structure

```
skill/
  SKILL.md         ← entry point (load this first)
  signals.md       ← price signals
  portfolio.md     ← wallet/portfolio analysis
  risk.md          ← risk scoring + PASS/BLOCK
  proofs.md        ← mindprint verification
  mcp.md           ← MCP server setup
agents/
  mind-trader-agent.md   ← reference agent config
commands/
  mind-check.md          ← /mind-check pre-flight command
install.sh
```

## Usage example

In Claude Desktop after installing:

```
Check the risk on wallet 7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU before I swap.
```

Claude will call `mind_risk_scoring`, return a score and decision, and give you a mindprint hash you can verify independently.

## Why mindprints matter

Attach the hash to your transaction record. Later:

```
GET https://api.mind.so/v1/proof/{hash}
```

Returns the exact inputs and response the agent used. Useful for:
- Post-trade audits
- Compliance reporting
- Debugging agent decisions
- Detecting if inputs were tampered with

## License

MIT

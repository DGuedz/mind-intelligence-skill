# MIND Builder Program

**Build a skill on MIND Protocol. Earn 20% of every call it generates. Forever.**

---

## How it works

1. You build a skill that uses MIND intelligence cards as its data layer
2. You submit the skill to this repo (or any Solana AI Kit compatible repo)
3. MIND attributes calls to your skill via `mindprint` — tamper-evident, on-chain
4. Every week, 20% of revenue from calls on your skill goes to your Solana wallet — automatically

No invoices. No payroll. No middleman. The protocol pays you.

---

## Who this is for

- Builders in Superteam Brasil and the broader Solana ecosystem
- Developers building AI agent tools on top of Solana data
- Anyone who wants to ship something useful and earn from it while they sleep

---

## What counts as a "skill on MIND"

Any Claude Code / Solana AI Kit skill that:
- Uses at least one MIND intelligence card (`mind_risk_scoring`, `mind_signals`, `mind_counterparty_check`, etc.)
- Is publicly available (open source, MIT or Apache 2.0)
- Passes a basic quality review (working install, clear SKILL.md, real use case)

Your skill does not need to be merged into the core kit to qualify — a public repo with a PR is enough.

---

## Revenue split

| Party | % per call |
|-------|-----------|
| Builder | 20% |
| MIND Protocol | 80% |

Payments settled weekly to your Solana wallet (`wallet_address` from registration).
Minimum payout threshold: 1.00 USDC.

---

## Register

**[Register as a MIND Builder →](https://api.mindprotocol.xyz/v1/builders/register)**

```bash
curl -X POST https://api.mindprotocol.xyz/v1/builders/register \
  -H "Content-Type: application/json" \
  -d '{
    "github_handle": "your-github",
    "email": "you@email.com",
    "wallet_address": "YOUR_SOLANA_PUBKEY",
    "skill_name": "my-awesome-skill",
    "skill_repo_url": "https://github.com/you/my-awesome-skill",
    "superteam_member": true,
    "country": "Brazil"
  }'
```

Response:

```json
{
  "builder_id": "...",
  "status": "pending",
  "revenue_split_pct": 20,
  "message": "Registration received. You will be notified at your email when approved.",
  "program_info": {
    "split": "20% of revenue from every call on your skill",
    "settlement": "weekly, directly to your Solana wallet",
    "docs": "https://mindprotocol.xyz/builders"
  }
}
```

---

## Check your status

```bash
curl https://api.mindprotocol.xyz/v1/builders/your-github-handle
```

---

## Intelligence cards available to build with

| Card | What it provides | Price/call |
|------|-----------------|------------|
| `mind_risk_scoring` | Wallet concentration risk (PASS/WARN/BLOCK) | 0.0154 USDC |
| `mind_signals` | Pyth price + momentum at current Solana slot | 0.010 USDC |
| `mind_counterparty_check` | Pre-transaction safety verdict | 0.015 USDC |
| `mind_market_intelligence` | Full SPL token portfolio | 0.020 USDC |
| `mind_wallet_profile` | Behavioral fingerprint | 0.025 USDC |
| `mind_token_intelligence` | Token safety + holder analysis | 0.035 USDC |
| `mind_portfolio_audit` | Full portfolio audit + DeFi exposure | 0.10 USDC |

All cards return a `mindprint` — a SHA-256 proof tied to a Solana slot. Your skills inherit this auditability automatically.

---

## Resources

- [MIND Protocol](https://mindprotocol.xyz)
- [Solana AI Kit](https://github.com/solanabr/solana-ai-kit)
- [Superteam Brasil](https://superteam.fun)
- [Reference skill](https://github.com/solanabr/solana-game-skill)
- Questions: [@dg_doublegreen](https://x.com/dg_doublegreen)

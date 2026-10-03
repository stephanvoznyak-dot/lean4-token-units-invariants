# Lean 4 Formalization of Token Units, System and Application Invariants

This repository contains a complete Lean 4 formalization derived from public claims made on X (Twitter) by financial agents (primarily @HarmonicAgents) that use Lean 4 for monetary safety rules.

## Structure

| File | Content |
|------|--------|
| `System.lean` | Formal description of the **system** (autonomous financial agent on Robinhood Chain) and its high-level safety predicates extracted from X posts. |
| `Application.lean` | Formal description of the **application** (on-chain agent that only accepts Lean-checked transitions) together with the concrete theorems that implement the claimed guarantees. |
| `TokenUnits.lean` | Core definitions of token units, wallets, state, transfer and the base proofs of supply preservation and unit precision. |

## Key Claims Taken from X and Formalized

From @HarmonicAgents posts:
- “No reachable state raises total supply.”
- “Redeeming index shares can never lower holdings per share for whoever stays.”
- Monetary rules are adopted only after they type-check in Lean 4.
- The Lean prover is the external arbiter of correctness.

## Build

```bash
git clone https://github.com/stephanvoznyak-dot/lean4-token-units-invariants.git
cd lean4-token-units-invariants
lake exe cache get
lake build
```

Requires Lean 4 (see `lean-toolchain`) and Mathlib.

## License

MIT

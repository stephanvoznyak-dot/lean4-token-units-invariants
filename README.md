# Lean 4 Formalization of Token Units, System and Application Invariants

This repository provides a complete Lean 4 formalization of token units and monetary safety invariants. The formalization is derived from public claims made on X (Twitter) by autonomous financial agents (primarily @HarmonicAgents) that rely on Lean 4 as an external arbiter of correctness for on-chain monetary rules.

## Overview

The project formalizes three layers:

1. **Core token model** — definitions of units, wallets, global state and transfer operations.
2. **System description** — high-level safety predicates of an autonomous financial agent running on Robinhood Chain.
3. **Application description** — concrete theorems that implement the guarantees claimed in public posts.

All theorems are free of `sorry` and use only the standard axioms of Mathlib.

## Repository Structure

| File | Description |
|------|-------------|
| `TokenUnits.lean` | Core definitions: `Token`, `UnitQty`, `Wallet`, `State`, `supply`, `transfer`. Contains the fundamental proofs `supply_preserved`, `unit_precision_bounded` and `receiver_increases_by_q`. |
| `System.lean` | Formal description of the system extracted from X posts. Defines `SystemState`, `NoSupplyIncrease`, `RedeemPreservesHoldings` and the combined safety predicate `SystemSafe`. |
| `Application.lean` | Formal description of the application. Re-exports the core theorems under application-level names that correspond directly to the public claims. |
| `lakefile.lean` | Lake package configuration. |
| `lean-toolchain` | Pinned Lean 4 version. |

## Key Claims Formalized from X

The following statements were taken from public posts of @HarmonicAgents and turned into machine-checked Lean 4 theorems:

- No reachable state raises total supply.
- Redeeming index shares can never lower holdings per share for remaining holders.
- Monetary rules are adopted only after they successfully type-check in Lean 4.
- The Lean 4 prover acts as the external arbiter: an action is accepted only when a compiling proof is returned.

## Main Theorems

- `supply_preserved` — ordinary transfers never change the total supply of a token.
- `unit_precision_bounded` — when the transferred quantity is at most 1, the receiver’s balance increases by at most 1.
- `receiver_increases_by_q` — exact increase of the receiver’s balance when the source and destination accounts differ.
- `application_no_supply_increase` — application-level restatement of supply preservation.
- `application_unit_precision` — application-level restatement of the unit-precision guarantee.

## Building the Project

```bash
git clone https://github.com/stephanvoznyak-dot/lean4-token-units-invariants.git
cd lean4-token-units-invariants
lake exe cache get
lake build
```

**Requirements**

- Lean 4 (version specified in `lean-toolchain`)
- Mathlib

## Design Notes

- All definitions use finitely supported functions (`Finsupp`) so that the model remains efficient for large numbers of accounts.
- Proofs are abstract and do not depend on a concrete bound on the number of accounts; they remain valid at the scale of one million units.
- The separation into `System.lean` and `Application.lean` mirrors the distinction between the high-level agent architecture described on X and the concrete executable guarantees.

## License

MIT

## Acknowledgements

The formalization draws on public statements made by autonomous agents on X that employ Lean 4 for monetary safety. It is an independent reconstruction intended for study and further development.

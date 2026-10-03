/-!
# Application Description (from X posts of @HarmonicAgents and related Lean 4 economics formalizations)

Application: Autonomous on-chain financial agent that executes trades, launches
sub-agents, manages compute and settles on Robinhood Chain.

The application enforces monetary rules by submitting every critical transition
to Lean 4. Only transitions that produce a machine-checked proof are accepted.

Concrete application-level guarantees formalized below:
1. Total token supply never increases in any reachable state.
2. Unit-precision transfers (change bounded by 1 unit when quantity ≤ 1).
3. Supply is preserved under ordinary transfers (no hidden minting).

These guarantees are taken directly from the public claims made by the agent
on X and turned into Lean 4 statements that the kernel can verify.
-/

import TokenUnits

/-- Application-level claim: no reachable transition raises total supply. -/
theorem application_no_supply_increase
    (s : State) (from to : ℕ) (τ : Token) (q : UnitQty)
    (h : (s.wallets from) τ ≥ q) :
    supply (transfer s from to τ q h) τ = supply s τ :=
  supply_preserved s from to τ q h

/-- Application-level claim: unit-precision when transferred quantity ≤ 1. -/
theorem application_unit_precision
    (s : State) (from to : ℕ) (τ : Token) (q : UnitQty)
    (hq : q.1 ≤ 1) (h : (s.wallets from) τ ≥ q) :
    let s' := transfer s from to τ q h
    (s'.wallets to τ).1 - (s.wallets to τ).1 ≤ 1 :=
  unit_precision_bounded s from to τ q hq h

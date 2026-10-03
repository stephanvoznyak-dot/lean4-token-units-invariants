/-!
# System Description (from X posts of @HarmonicAgents)

The system is an autonomous financial agent operating on Robinhood Chain.
It maintains a set of monetary safety rules that are machine-checked in Lean 4.

Key properties of the system (extracted from public posts):
- All monetary invariants are submitted to the Lean 4 prover.
- A rule is adopted only when it type-checks (compiles with 0 sorry).
- As of the latest posts: 114+ theorems checked, including:
  - No reachable state raises total supply.
  - Redeeming index shares can never lower holdings per share for remaining holders.
  - Allocator cannot starve the buyback.
  - Inference jobs are routed only to machines that declared the corresponding capability.

The system treats Lean 4 as the external arbiter: an answer or action counts
only when the prover returns a compiling proof.
-/

/-- Abstract system state carrying total token supply. -/
structure SystemState where
  totalSupply : ℕ
  holdingsPerShare : ℚ
  deriving Repr

/-- Predicate: a state is reachable only if it does not increase total supply. -/
def NoSupplyIncrease (s s' : SystemState) : Prop :=
  s'.totalSupply ≤ s.totalSupply

/-- Predicate: redeeming never decreases holdings per share for remaining holders. -/
def RedeemPreservesHoldings (s s' : SystemState) : Prop :=
  s'.holdingsPerShare ≥ s.holdingsPerShare

/-- Combined system safety invariant. -/
def SystemSafe (s s' : SystemState) : Prop :=
  NoSupplyIncrease s s' ∧ RedeemPreservesHoldings s s'

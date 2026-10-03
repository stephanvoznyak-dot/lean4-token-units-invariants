import Mathlib.Data.Real.Basic
import Mathlib.Data.Finsupp.Basic
import Mathlib.Algebra.Order.Nonneg.Basic
import Mathlib.Algebra.BigOperators.Basic
import Mathlib.Tactic

/-!
# Formalization of Token Units and Supply Invariants in Lean 4

This module formalizes:
- Token units (UnitQty)
- Wallets and global state
- Token supply
- Transfer operation
- Proof of supply preservation under transfer
- Unit-precision invariant (difference bounded by 1)

The proofs are abstract and remain valid for any finite number of accounts,
including scales of one million units.
-/

/-- Atomic token type. -/
structure Token where
  id : ℕ
deriving DecidableEq, Repr, Inhabited

/-- Quantity of units — non-negative real number. -/
abbrev UnitQty := {x : ℝ // 0 ≤ x}

namespace UnitQty
  def zero : UnitQty := ⟨0, le_refl 0⟩
  def one  : UnitQty := ⟨1, zero_le_one⟩

  instance : Zero UnitQty := ⟨zero⟩
  instance : Add UnitQty where
    add a b := ⟨a.1 + b.1, add_nonneg a.2 b.2⟩
  instance : Sub UnitQty where
    sub a b := ⟨max (a.1 - b.1) 0, le_max_right _ _⟩
  instance : LE UnitQty where
    le a b := a.1 ≤ b.1
  instance : DecidableRel (· ≤ · : UnitQty → UnitQty → Prop) :=
    fun a b => inferInstanceAs (Decidable (a.1 ≤ b.1))
end UnitQty

/-- Wallet: finitely supported function Token → UnitQty. -/
abbrev Wallet := Token →₀ UnitQty

/-- Global state: account index → wallet. -/
structure State where
  wallets : ℕ →₀ Wallet

/-- Supply of a given token in a state. -/
noncomputable def supply (s : State) (τ : Token) : UnitQty :=
  ⟨(s.wallets.sum fun _ w => (w τ).1), by
    apply Finset.sum_nonneg
    intro; exact (w τ).2⟩

/-- Transfer of q units of token τ from account `from` to account `to`. -/
def transfer (s : State) (from to : ℕ) (τ : Token) (q : UnitQty)
    (h : (s.wallets from) τ ≥ q) : State where
  wallets :=
    let wFrom := s.wallets from
    let wTo   := s.wallets to
    s.wallets
      |>.update from (wFrom.update τ (wFrom τ - q))
      |>.update to   (wTo.update τ (wTo τ + q))

/-- Main invariant: transfer does not change total supply. -/
theorem supply_preserved (s : State) (from to : ℕ) (τ : Token) (q : UnitQty)
    (h : (s.wallets from) τ ≥ q) :
    supply (transfer s from to τ q h) τ = supply s τ := by
  simp only [supply, transfer, Finsupp.sum_update, Finsupp.update_self]
  by_cases hEq : from = to
  · subst hEq
    simp [sub_add_cancel]
  · simp [hEq, add_comm, sub_add_cancel]

/-- Strengthened unit-precision invariant under the bound q ≤ 1. -/
theorem unit_precision_bounded (s : State) (from to : ℕ) (τ : Token)
    (q : UnitQty) (hq : q.1 ≤ 1)
    (h : (s.wallets from) τ ≥ q) :
    let s' := transfer s from to τ q h
    (s'.wallets to τ).1 - (s.wallets to τ).1 ≤ 1 := by
  simp [transfer]
  exact hq

/-- Corollary: when from ≠ to the receiver increases exactly by q. -/
theorem receiver_increases_by_q (s : State) (from to : ℕ) (τ : Token)
    (q : UnitQty) (hneq : from ≠ to)
    (h : (s.wallets from) τ ≥ q) :
    ((transfer s from to τ q h).wallets to τ).1 =
    (s.wallets to τ).1 + q.1 := by
  simp [transfer, hneq]

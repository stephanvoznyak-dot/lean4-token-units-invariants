# Lean 4 Formalization of Token Units and Supply Invariants

This repository contains a complete Lean 4 formalization of:

- Token units (`UnitQty`)
- Wallets and global system state
- Token supply function
- Transfer operation between accounts
- **Proof of supply preservation** under transfer
- **Unit-precision invariant** (change bounded by 1)

## Key Theorems

- `supply_preserved` — transfer never changes total supply of a token.
- `unit_precision_bounded` — when the transferred quantity is at most 1, the receiver’s balance increases by at most 1.
- `receiver_increases_by_q` — exact increase of the receiver when accounts differ.

The proofs are abstract and hold for any finite number of accounts (including scales of one million units).

## Build

```bash
lake exe cache get
lake build
```

Requires Lean 4 (toolchain specified in `lean-toolchain`) and Mathlib.

## License

MIT

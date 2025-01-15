# Technical Specification

## Overview

The Cross-Layer DEX Protocol implements an automated market maker (AMM) for cross-chain trading between Bitcoin and Stacks assets. This document provides detailed technical specifications of the protocol's implementation.

## Core Components

### Constants

- `PRECISION`: 1,000,000 (6 decimal places)
- Error codes for various failure conditions
- Contract owner designation

### Data Structures

#### Liquidity Pools

```clarity
{
    token-x: principal,
    token-y: principal,
    total-shares: uint,
    reserve-x: uint,
    reserve-y: uint,
    fee-rate: uint,
    last-block-height: uint
}
```

#### Liquidity Providers

```clarity
{
    shares: uint
}
```

### Core Functions

#### Pool Management

1. `create-pool`

   - Creates new liquidity pool
   - Parameters: token-x, token-y, fee-rate
   - Restrictions: Only contract owner

2. `add-liquidity`

   - Adds liquidity to existing pool
   - Parameters: pool-id, token-x, token-y, amount-x, amount-y, min-shares
   - Returns: Minted shares

3. `remove-liquidity`
   - Removes liquidity from pool
   - Parameters: pool-id, token-x, token-y, shares, min-amount-x, min-amount-y
   - Returns: Withdrawn amounts

#### Trading Functions

1. `swap-exact-x-for-y`
   - Performs token swap
   - Parameters: pool-id, token-x, token-y, amount-in, min-amount-out
   - Returns: Output amount

#### Administrative Functions

1. `update-fee-rate`
   - Updates pool fee rate
   - Parameters: pool-id, new-fee-rate
   - Restrictions: Only contract owner

## Mathematical Formulas

### Swap Calculation

The protocol uses the constant product formula:

```
x * y = k
```

Where:

- x: Reserve of token X
- y: Reserve of token Y
- k: Constant product

### Fee Calculation

```
fee_adjusted_input = input_amount * (1 - fee_rate)
```

### Share Calculation

For initial liquidity:

```
shares = amount_x
```

For subsequent deposits:

```
shares = min(
    (amount_x * total_shares) / reserve_x,
    (amount_y * total_shares) / reserve_y
)
```

## Security Considerations

### Slippage Protection

- Minimum output amount enforcement
- Minimum shares enforcement

### Atomic Execution

- All operations are atomic
- Reverts on any failure

### Access Control

- Owner-only administrative functions
- Pool-specific token validation

### Precision Handling

- 6 decimal places for calculations
- Rounding down for conservative estimates

## Error Handling

| Code | Description          |
| ---- | -------------------- |
| u100 | Not authorized       |
| u101 | Invalid amount       |
| u102 | Insufficient balance |
| u103 | Pool not found       |
| u104 | Slippage too high    |
| u105 | Zero liquidity       |
| u106 | Divide by zero       |
| u107 | Concurrent update    |

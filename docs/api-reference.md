# API Reference

## Core Functions

### Pool Management

#### create-pool

Creates a new liquidity pool for a token pair.

```clarity
(define-public (create-pool (token-x <ft-trait>) (token-y <ft-trait>) (fee-rate uint)))
```

**Parameters:**

- `token-x`: First token contract
- `token-y`: Second token contract
- `fee-rate`: Pool fee rate (in PRECISION units)

**Returns:**

- `(ok uint)`: Pool ID
- `(err uint)`: Error code

#### add-liquidity

Adds liquidity to an existing pool.

```clarity
(define-public (add-liquidity (pool-id uint) (token-x <ft-trait>) (token-y <ft-trait>) (amount-x uint) (amount-y uint) (min-shares uint)))
```

**Parameters:**

- `pool-id`: Pool identifier
- `token-x`: First token contract
- `token-y`: Second token contract
- `amount-x`: Amount of first token
- `amount-y`: Amount of second token
- `min-shares`: Minimum shares to receive

**Returns:**

- `(ok uint)`: Minted shares
- `(err uint)`: Error code

### Trading Functions

#### swap-exact-x-for-y

Swaps an exact amount of token X for token Y.

```clarity
(define-public (swap-exact-x-for-y (pool-id uint) (token-x <ft-trait>) (token-y <ft-trait>) (amount-in uint) (min-amount-out uint)))
```

**Parameters:**

- `pool-id`: Pool identifier
- `token-x`: Input token contract
- `token-y`: Output token contract
- `amount-in`: Input amount
- `min-amount-out`: Minimum output amount

**Returns:**

- `(ok uint)`: Output amount
- `(err uint)`: Error code

### Read-Only Functions

#### get-pool-details

Retrieves pool information.

```clarity
(define-read-only (get-pool-details (pool-id uint)))
```

**Parameters:**

- `pool-id`: Pool identifier

**Returns:**

- Pool data structure or error

#### get-provider-shares

Gets liquidity provider shares.

```clarity
(define-read-only (get-provider-shares (pool-id uint) (provider principal)))
```

**Parameters:**

- `pool-id`: Pool identifier
- `provider`: Provider address

**Returns:**

- Share information

## Error Codes

| Code | Constant                 | Description                |
| ---- | ------------------------ | -------------------------- |
| u100 | ERR-NOT-AUTHORIZED       | Unauthorized access        |
| u101 | ERR-INVALID-AMOUNT       | Invalid amount specified   |
| u102 | ERR-INSUFFICIENT-BALANCE | Insufficient balance       |
| u103 | ERR-POOL-NOT-FOUND       | Pool does not exist        |
| u104 | ERR-SLIPPAGE-TOO-HIGH    | Slippage exceeds limit     |
| u105 | ERR-ZERO-LIQUIDITY       | Zero liquidity condition   |
| u106 | ERR-DIVIDE-BY-ZERO       | Division by zero error     |
| u107 | ERR-CONCURRENT-UPDATE    | Concurrent update detected |

## Data Structures

### Liquidity Pool

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

### Liquidity Provider

```clarity
{
    shares: uint
}
```

## Constants

- `PRECISION`: 1,000,000 (6 decimal places)
- `CONTRACT-OWNER`: Contract deployer principal

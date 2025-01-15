;; Title: Cross-Layer DEX Protocol
;; Summary: A decentralized exchange protocol enabling atomic swaps between Bitcoin and Stacks assets
;; Description:
;; This contract implements an automated market maker (AMM) for cross-chain trading.
;; It supports liquidity provision, token swaps, and fee collection with precise calculations using 6 decimal places.
;; The protocol ensures atomic execution and includes safety checks for slippage protection.

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-AMOUNT (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-POOL-NOT-FOUND (err u103))
(define-constant ERR-SLIPPAGE-TOO-HIGH (err u104))
(define-constant ERR-ZERO-LIQUIDITY (err u105))
(define-constant ERR-DIVIDE-BY-ZERO (err u106))
(define-constant PRECISION u1000000) ;; 6 decimal places for price calculations

;; Data Variables
(define-data-var last-pool-id uint u0)

;; Data Maps
(define-map liquidity-pools
    { pool-id: uint }
    {
        token-x: principal,
        token-y: principal,
        total-shares: uint,
        reserve-x: uint,
        reserve-y: uint,
        fee-rate: uint,
        last-block-height: uint
    }
)

(define-map liquidity-providers
    { pool-id: uint, provider: principal }
    { shares: uint }
)

;; SIP-010 Interface
(define-trait ft-trait
    (
        (transfer (uint principal principal) (response bool uint))
        (get-balance (principal) (response uint uint))
        (get-decimals () (response uint uint))
    )
)

;; Private helper functions
(define-private (mul-down (a uint) (b uint))
    (/ (* a b) PRECISION)
)

(define-private (div-down (a uint) (b uint))
    (if (is-eq b u0)
        u0
        (/ (* a PRECISION) b)
    )
)

(define-private (min (a uint) (b uint))
    (if (<= a b) a b)
)

(define-private (transfer-token (token <ft-trait>) (amount uint) (sender principal) (recipient principal))
    (contract-call? token transfer amount sender recipient)
)

;; Read-only functions
(define-read-only (get-pool-details (pool-id uint))
    (match (map-get? liquidity-pools { pool-id: pool-id })
        pool-data (ok pool-data)
        (err ERR-POOL-NOT-FOUND))
)

(define-read-only (get-provider-shares (pool-id uint) (provider principal))
    (default-to
        { shares: u0 }
        (map-get? liquidity-providers { pool-id: pool-id, provider: provider }))
)

(define-read-only (calculate-swap-output (pool-id uint) (input-amount uint) (is-x-to-y bool))
    (match (map-get? liquidity-pools { pool-id: pool-id })
        pool-data 
            (let (
                (input-reserve (if is-x-to-y (get reserve-x pool-data) (get reserve-y pool-data)))
                (output-reserve (if is-x-to-y (get reserve-y pool-data) (get reserve-x pool-data)))
                (fee-adjusted-input (mul-down input-amount (- PRECISION (get fee-rate pool-data))))
            )
            (asserts! (> input-reserve u0) (err ERR-ZERO-LIQUIDITY))
            (asserts! (> output-reserve u0) (err ERR-ZERO-LIQUIDITY))
            (ok (div-down
                (mul-down fee-adjusted-input output-reserve)
                (+ input-reserve fee-adjusted-input))))
        (err ERR-POOL-NOT-FOUND))
)
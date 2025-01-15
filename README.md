# Cross-Layer DEX Protocol

A decentralized exchange protocol enabling atomic swaps between Bitcoin and Stacks assets with an automated market maker (AMM) implementation.

## Overview

The Cross-Layer DEX Protocol is a sophisticated automated market maker designed for secure and efficient cross-chain trading between Bitcoin and Stacks assets. It implements a robust liquidity pool system with precise calculations using 6 decimal places for accuracy.

### Key Features

- **Automated Market Making**: Implements constant product formula for efficient price discovery
- **Liquidity Provision**: Supports adding and removing liquidity with share-based tracking
- **Atomic Swaps**: Enables secure token exchanges with slippage protection
- **Fee Management**: Configurable fee rates with precision-based calculations
- **Safety Mechanisms**: Built-in protections against common DeFi vulnerabilities

## Quick Start

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Basic understanding of Clarity smart contracts
- Familiarity with AMM concepts

### Contract Deployment

1. Deploy the contract to your desired network
2. Initialize pools for your token pairs
3. Set initial fee rates

### Usage Examples

#### Creating a Liquidity Pool

```clarity
(contract-call? .dex-protocol create-pool token-x token-y fee-rate)
```

#### Adding Liquidity

```clarity
(contract-call? .dex-protocol add-liquidity
    pool-id token-x token-y amount-x amount-y min-shares)
```

#### Performing a Swap

```clarity
(contract-call? .dex-protocol swap-exact-x-for-y
    pool-id token-x token-y amount-in min-amount-out)
```

## Architecture

The protocol is built on several key components:

1. **Liquidity Pools**: Manages token pairs and their reserves
2. **Share Tracking**: Handles liquidity provider positions
3. **Swap Engine**: Implements the constant product formula
4. **Fee System**: Manages protocol fees and distributions

## Security

- Comprehensive error handling
- Slippage protection
- Atomic execution guarantees
- Concurrent update protection

## Testing

Run the test suite using Clarinet:

```bash
clarinet test
```

## Documentation

For detailed documentation, please refer to the [docs](./docs) directory.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

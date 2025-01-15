# Integration Guide

## Overview

This guide provides detailed instructions for integrating with the Cross-Layer DEX Protocol. Whether you're building a frontend application or integrating with another smart contract, this document will help you understand how to interact with the protocol.

## Getting Started

### Prerequisites

- Stacks wallet integration
- Understanding of SIP-010 token standard
- Familiarity with Clarity smart contracts

### Basic Integration Steps

1. Contract Deployment
2. Pool Creation
3. Initial Liquidity Provision
4. Integration Testing

## Contract Interaction

### Reading Pool Data

```typescript
async function getPoolDetails(poolId: number) {
  const response = await callReadOnlyFunction({
    contractAddress,
    contractName: "dex-protocol",
    functionName: "get-pool-details",
    functionArgs: [uintCV(poolId)],
  });
  return response;
}
```

### Adding Liquidity

```typescript
async function addLiquidity(
  poolId: number,
  tokenX: string,
  tokenY: string,
  amountX: number,
  amountY: number,
  minShares: number
) {
  const txOptions = {
    contractAddress,
    contractName: "dex-protocol",
    functionName: "add-liquidity",
    functionArgs: [
      uintCV(poolId),
      contractPrincipalCV(tokenX),
      contractPrincipalCV(tokenY),
      uintCV(amountX),
      uintCV(amountY),
      uintCV(minShares),
    ],
  };
  return await makeContractCall(txOptions);
}
```

### Performing Swaps

```typescript
async function swapExactXForY(
  poolId: number,
  tokenX: string,
  tokenY: string,
  amountIn: number,
  minAmountOut: number
) {
  const txOptions = {
    contractAddress,
    contractName: "dex-protocol",
    functionName: "swap-exact-x-for-y",
    functionArgs: [
      uintCV(poolId),
      contractPrincipalCV(tokenX),
      contractPrincipalCV(tokenY),
      uintCV(amountIn),
      uintCV(minAmountOut),
    ],
  };
  return await makeContractCall(txOptions);
}
```

## Best Practices

### Slippage Handling

Always include appropriate slippage tolerance:

```typescript
const slippageTolerance = 0.005; // 0.5%
const minAmountOut = calculateMinimumAmountOut(
  expectedAmount,
  slippageTolerance
);
```

### Error Handling

Implement comprehensive error handling:

```typescript
try {
  const result = await swapExactXForY(/* params */);
  if (result.success) {
    // Handle success
  } else {
    // Handle specific error cases
    switch (result.error) {
      case "u104":
        console.error("Slippage too high");
        break;
      // Handle other error cases
    }
  }
} catch (error) {
  // Handle unexpected errors
}
```

### Gas Estimation

Always estimate gas before transactions:

```typescript
const estimatedGas = await estimateContractCall(txOptions);
```

## Testing

### Integration Test Example

```typescript
describe("DEX Integration", () => {
  it("should add liquidity successfully", async () => {
    // Test implementation
  });

  it("should perform swap with correct slippage", async () => {
    // Test implementation
  });
});
```

## Security Considerations

1. Always validate input amounts
2. Implement proper slippage protection
3. Handle failed transactions gracefully
4. Validate pool existence before operations
5. Implement proper error handling

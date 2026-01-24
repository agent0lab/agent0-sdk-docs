---
title: "Client-side usage"
description: "Discover wallets in the browser and sign transactions via EIP-1193"
---

Use this when you want to run the TypeScript SDK in a browser and let the user’s wallet sign transactions.

## Key idea: reads vs writes

- **Reads** (view calls, event queries): use your configured `rpcUrl`
- **Writes** (transactions, signatures): use the user’s wallet (`walletProvider`, EIP-1193)

## Wallet discovery (ERC-6963)

Agent0 exposes small, framework-agnostic helpers to discover wallets that support ERC-6963:

```ts
import { SDK } from 'agent0-sdk';
import { discoverEip6963Providers, connectEip1193 } from 'agent0-sdk/eip6963';

async function connectSdk() {
  // Must run in a browser environment (window available).
  const providers = await discoverEip6963Providers({ timeoutMs: 800 });
  if (providers.length === 0) throw new Error('No wallet found (ERC-6963)');

  // Pick a provider (UI selection recommended).
  const { provider } = providers[0];

  // Ask the wallet to connect (EIP-1193).
  const walletProvider = await connectEip1193(provider);

  // SDK uses rpcUrl for reads and walletProvider for writes.
  const sdk = new SDK({
    chainId: 11155111,
    rpcUrl: import.meta.env.PUBLIC_RPC_URL,
    walletProvider,
  });

  return sdk;
}
```

## Example: sending a transaction

Any on-chain write requires a signer (a connected wallet in the browser):

```ts
const sdk = await connectSdk();

const agent = sdk.createAgent('My Agent', 'Browser-registered agent');
const tx = await agent.registerIPFS();
const { result: registrationFile } = await tx.waitConfirmed();
console.log(registrationFile.agentId);
```

## Notes

- If you only need **read-only** operations in the browser, you can omit `walletProvider` entirely.
- If you’re server-side, prefer `privateKey` instead of `walletProvider`.


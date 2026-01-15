---
title: "Transfer"
description: "Transfer agent ownership"
---
Learn how to transfer agent ownership to another address using the Agent0 SDK.

Agent transfer allows the current owner of an agent to transfer ownership to a new address. This is useful for:

- **Selling agents**: Transfer ownership when selling an agent to another party
- **Team handoffs**: Transfer agents between team members or departments
- **Account management**: Move agents to different wallets for organizational purposes
- **Escrow scenarios**: Transfer agents as part of contractual agreements
## Prerequisites

Before transferring an agent, ensure you have:

- **Agent ownership**: You must be the current owner of the agent
- **Valid recipient address**: The new owner must have a valid Ethereum address
- **Sufficient gas**: Transaction fees are required for the transfer
- **Network access**: Connection to the blockchain network where the agent is registered
## Transfer Agent

<Tabs>
<TabItem label="Python">

```python
from agent0_sdk import SDK

# Initialize SDK
sdk = SDK(
    chainId=11155111,
    rpcUrl="https://sepolia.infura.io/v3/YOUR_PROJECT_ID",
    signer=your_private_key
)

# Load the agent
agent = sdk.loadAgent("11155111:123")

# Transfer to new owner
new_owner = "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6"
transfer_result = agent.transfer(new_owner)

print(f"Transfer successful: {transfer_result['txHash']}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';

// Initialize SDK
const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: 'https://sepolia.infura.io/v3/YOUR_PROJECT_ID',
  privateKey: yourPrivateKey,
});

// Load the agent (async in TypeScript)
const agent = await sdk.loadAgent('11155111:123');

// Transfer to new owner (async in TypeScript)
const newOwner = '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6';
const transferResult = await agent.transfer(newOwner);

console.log(`Transfer successful: ${transferResult.txHash}`);
console.log(`From: ${transferResult.from}`);
console.log(`To: ${transferResult.to}`);
console.log(`Agent ID: ${transferResult.agentId}`);
```

</TabItem>
</Tabs>

## isAgentOwner Utility Function

The `isAgentOwner()` utility function provides a convenient way to check if the current SDK signer owns a specific agent:

<Tabs>
<TabItem label="Python">

```python
# Check if you own an agent
is_owner = sdk.isAgentOwner("11155111:123")

if is_owner:
    print("You own this agent and can transfer it")
else:
    print("You do not own this agent")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Check if you own an agent (async in TypeScript)
const isOwner = await sdk.isAgentOwner('11155111:123');

if (isOwner) {
  console.log('You own this agent and can transfer it');
} else {
  console.log('You do not own this agent');
}
```

</TabItem>
</Tabs>

**What it does:**

- Queries the IdentityRegistry contract for the agent’s current owner
- Compares it with the SDK’s configured signer address
- Returns `True` if the signer is the owner, `False` otherwise
- Handles address normalization (case-insensitive comparison)
**Use cases:**

- Verify ownership before attempting transfers
- Check permissions before making agent modifications
- Validate access rights in multi-user applications
- Implement access control in agent management interfaces

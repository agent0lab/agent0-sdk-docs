---
title: "Agent Update"
description: "Update agent configuration"
---
Update an existing agent’s configuration and re-register the changes.

<Tabs>
<TabItem label="Python">

```python
from agent0_sdk import SDK
import os

# Initialize SDK
sdk = SDK(
    chainId=11155111,  # Ethereum Sepolia testnet
    rpcUrl=os.getenv("RPC_URL"),
    signer=os.getenv("PRIVATE_KEY"),
    ipfs="pinata",
    pinataJwt=os.getenv("PINATA_JWT")
)

# Create + register a fresh agent (self-contained)
agent = sdk.createAgent(
    name="Update Example Agent",
    description="An agent created by the update example script.",
    image="https://example.com/agent-image.png",
)
agent.setMCP("https://api.example.com/mcp")
agent.setActive(True)

print("Registering a new agent (setup for this example)...")
registration = agent.registerIPFS()
agent_id = registration.agentId
print(f"Registered agentId: {agent_id}")

# Load it back (hydrates from chain/IPFS)
loaded = sdk.loadAgent(agent_id)
print(f"Loaded agent: {loaded.name}")
print(f"Current description: {loaded.description}")

# Update information
loaded.updateInfo(
    name="Updated Agent Name",
    description="Updated description with new skills and pricing",
)

# Update metadata
loaded.setMetadata({
    "version": "1.1.0",
    "tags": ["data_analyst", "finance", "coding"],
    "pricing": "0.015",
})

# Update endpoints if needed
loaded.setMCP("https://api.example.com/mcp-updated")

# Re-register (uploads new file, updates on-chain)
updated = loaded.registerIPFS()
print(f"✅ Updated and re-registered: {updated.agentId}")
print(f"New URI: {updated.agentURI}")

# Verify changes (via subgraph index)
retrieved = sdk.getAgent(updated.agentId)
print(f"Name: {retrieved.name}")
print(f"Description: {retrieved.description}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';

async function main() {
  const sdk = new SDK({
    chainId: 11155111, // Ethereum Sepolia
    rpcUrl: process.env.RPC_URL || 'https://sepolia.infura.io/v3/YOUR_PROJECT_ID',
    privateKey: process.env.PRIVATE_KEY ?? process.env.AGENT_PRIVATE_KEY, // Required for updates
    ipfs: 'pinata',
    pinataJwt: process.env.PINATA_JWT,
  });

  // 1) Create + register a fresh agent (self-contained)
  const agent = sdk.createAgent(
    'Update Example Agent',
    'An agent created by the update example script.',
    'https://example.com/agent-image.png'
  );
  await agent.setMCP('https://api.example.com/mcp');
  agent.setActive(true);

  console.log('Registering a new agent (setup for this example)...');
  const registration = await agent.registerIPFS();
  const agentId = registration.agentId!;

  // 2) Load it back
  const loaded = await sdk.loadAgent(agentId);

  // 3) Update agent information
  loaded.updateInfo('Updated AI Assistant', 'Updated description with new skills and pricing');
  loaded.setMetadata({
    version: '1.1.0',
    tags: ['data_analyst', 'finance', 'coding'],
    pricing: '0.015',
  });
  await loaded.setMCP('https://api.example.com/mcp-updated');

  // 4) Re-register with updated information
  console.log('Updating agent registration...');
  const updatedRegistrationFile = await loaded.registerIPFS();
  console.log(`Agent updated. New URI: ${updatedRegistrationFile.agentURI}`);
}

main().catch(console.error);
```

</TabItem>
</Tabs>

---
title: "Registration (IPFS)"
description: "Register agents with IPFS"
---
Register your agent on-chain with automatic IPFS storage for decentralized, censorship-resistant registration files.

## Overview

The IPFS registration flow handles everything automatically:

- Mint agent NFT (get agent ID)
- Upload registration file to IPFS
- Set IPFS URI on-chain
## Configuration

### Filecoin Pin

Protocol Labs offers free Filecoin pinning for ERC-8004 agents. [Learn more](https://t.me/ERC8004/1521)

<Tabs>
<TabItem label="Python">

```python
sdk = SDK(
    chainId=11155111,
    rpcUrl="https://sepolia.infura.io/v3/YOUR_PROJECT_ID",
    signer=private_key,
    ipfs="filecoinPin",
    filecoinPrivateKey="your-filecoin-private-key"
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: 'https://sepolia.infura.io/v3/YOUR_PROJECT_ID',
  privateKey: privateKey,
  ipfs: 'filecoinPin',
  filecoinPrivateKey: 'your-filecoin-private-key',
});
```

</TabItem>
</Tabs>

### Pinata

Pinata offers free pinning services for ERC-8004 agents. [Learn more](https://t.me/ERC8004/1629)

<Tabs>
<TabItem label="Python">

```python
sdk = SDK(
    chainId=11155111,
    rpcUrl="https://sepolia.infura.io/v3/YOUR_PROJECT_ID",
    signer=private_key,
    ipfs="pinata",
    pinataJwt="your-pinata-jwt-token"
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: 'https://sepolia.infura.io/v3/YOUR_PROJECT_ID',
  privateKey: privateKey,
  ipfs: 'pinata',
  pinataJwt: 'your-pinata-jwt-token',
});
```

</TabItem>
</Tabs>

### IPFS Node

<Tabs>
<TabItem label="Python">

```python
sdk = SDK(
    chainId=11155111,
    rpcUrl="...",
    signer=private_key,
    ipfs="node",
    ipfsNodeUrl="https://ipfs.infura.io:5001"
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: '...',
  privateKey: privateKey,
  ipfs: 'node',
  ipfsNodeUrl: 'https://ipfs.infura.io:5001',
});
```

</TabItem>
</Tabs>

## Register Agent

**Browser note:** you can run this flow client-side too—configure the SDK with `walletProvider` (EIP-1193) for writes. See [Browser wallets (ERC-6963)](/2-usage/2-8-browser-wallets/).

<Tabs>
<TabItem label="Python">

```python
# Configure your agent
agent = sdk.createAgent(...)
agent.setMCP("https://mcp.example.com/")
agent.setA2A("https://a2a.example.com/agent.json")

# Register - automatically handles everything!
agent.registerIPFS()

# Get agent ID
print(f"Agent registered: {agent.agentId}")
print(f"Agent URI: {agent.agentURI}")  # ipfs://Qm...
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Configure your agent
const agent = sdk.createAgent(...);
await agent.setMCP('https://mcp.example.com/');
await agent.setA2A('https://a2a.example.com/agent.json');

// Register - automatically handles everything! (async in TypeScript)
const registrationFile = await agent.registerIPFS();

// Get agent ID
console.log(`Agent registered: ${registrationFile.agentId}`);
console.log(`Agent URI: ${registrationFile.agentURI}`); // ipfs://Qm...
```

</TabItem>
</Tabs>

## Update Registration

After making changes, re-register to update on-chain:

<Tabs>
<TabItem label="Python">

```python
# Modify agent
agent.updateInfo(description="Updated description")
agent.setMCP("https://new-mcp.example.com")

# Re-register (uploads new file, updates URI)
agent.registerIPFS()

print(f"Updated: {agent.agentURI}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Modify agent
agent.updateInfo(undefined, 'Updated description', undefined);
await agent.setMCP('https://new-mcp.example.com');

// Re-register (uploads new file, updates URI) - async in TypeScript
const registrationFile = await agent.registerIPFS();

console.log(`Updated: ${registrationFile.agentURI}`);
```

</TabItem>
</Tabs>

The SDK automatically:

- Uploads updated registration file to IPFS
- Only updates changed metadata on-chain
- Sets new IPFS URI
- Clears dirty metadata flags
## Registration File Format

Your agent’s registration file is stored on IPFS:

```json
{
  "type": "https://eips.ethereum.org/EIPS/eip-8004#registration-v1",
  "name": "My AI Agent",
  "description": "Agent description",
  "image": "https://example.com/image.png",
  "endpoints": [
    {
      "name": "MCP",
      "endpoint": "https://mcp.example.com/",
      "version": "2025-06-18"
    }
  ],
  "registrations": [
    {
      "agentId": 123,
      "agentRegistry": "eip155:11155111:0x..."
    }
  ],
  "supportedTrust": ["reputation"],
  "active": true,
  "x402support": false,
  "updatedAt": 1234567890
}
```

## Optional: Endpoint Domain Verification (.well-known)

If you want verifiers to treat an HTTPS endpoint domain as “verified”, you can publish:

- `https://{endpoint-domain}/.well-known/agent-registration.json`

That file should contain a `registrations` entry matching your on-chain identity:

```json
{
  "registrations": [
    {
      "agentId": 123,
      "agentRegistry": "eip155:11155111:0x8004A818BFB912233c491871b3d84c89A494BD9e"
    }
  ]
}
```

Notes:

- This is optional and is primarily used by third-party verifiers/aggregators.

## Benefits of IPFS

- **Decentralized** - No single point of failure
- **Censorship resistant** - Data replicated across nodes
- **Content addressing** - Guaranteed integrity via CIDs
- **Permanent** - Files remain accessible with proper pinning
## Next Steps

- Learn [HTTP Registration](/2-usage/2-4-registration-http/)
- Explore [Search](/2-usage/2-5-search/)

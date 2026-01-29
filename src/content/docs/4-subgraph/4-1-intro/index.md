---
title: "Intro"
description: "Agent0 Subgraph overview"
---
The Agent0 SDK uses a subgraph for fast agent discovery and search. The subgraph automatically indexes ERC-8004 data from the blockchain and IPFS, providing GraphQL queries for efficient agent search and filtering.

## Automatic Subgraph Integration

The SDK **automatically** uses the Agent0 subgraph - no configuration needed:

<Tabs>
<TabItem label="Python">

```python
# SDK automatically uses the default subgraph
sdk = SDK(
    chainId=11155111,
    rpcUrl="https://sepolia.infura.io/v3/YOUR_PROJECT_ID",
    signer=your_private_key
)

# All search operations use the subgraph automatically
results = sdk.searchAgents(name="AI")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// SDK automatically uses the default subgraph
const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: 'https://sepolia.infura.io/v3/YOUR_PROJECT_ID',
  // read-only is fine for search; omit privateKey/walletProvider
});

// All search operations use the subgraph automatically (async in TypeScript)
const results = await sdk.searchAgents({ name: 'AI' });
```

</TabItem>
</Tabs>

## Override Subgraph URL

You can override the default subgraph URL using `subgraphOverrides` if needed:

<Tabs>
<TabItem label="Python">

```python
# Use a custom subgraph endpoint for specific chains
sdk = SDK(
    chainId=11155111,
    rpcUrl=RPC_URL,
    signer=PRIVATE_KEY,
    subgraphOverrides={
        11155111: "https://gateway.thegraph.com/api/00a452ad3cd1900273ea62c1bf283f93/subgraphs/id/6wQRC7geo9XYAhckfmfo8kbMRLeWU8KQd3XsJqFKmZLT"
    }
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Use a custom subgraph endpoint for specific chains
const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: RPC_URL,
  // read-only is fine for search; omit privateKey/walletProvider
  subgraphOverrides: {
    11155111: 'https://gateway.thegraph.com/api/00a452ad3cd1900273ea62c1bf283f93/subgraphs/id/6wQRC7geo9XYAhckfmfo8kbMRLeWU8KQd3XsJqFKmZLT',
  },
});
```

</TabItem>
</Tabs>

## Supported Networks

**Currently supported:**

- **Ethereum Mainnet** (Chain ID: `1`)
  - Default (SDK): `https://gateway.thegraph.com/api/7fd2e7d89ce3ef24cd0d4590298f0b2c/subgraphs/id/FX78UzofJFr5h2Udznv7pZ2uLG1JBbYsPm7eecRSYnty`
- **Ethereum Sepolia** (Chain ID: `11155111`)
  - Default (SDK): `https://gateway.thegraph.com/api/00a452ad3cd1900273ea62c1bf283f93/subgraphs/id/6wQRC7geo9XYAhckfmfo8kbMRLeWU8KQd3XsJqFKmZLT`

Note: The Graph Gateway endpoints require authentication (API key / authorization header). If you’re querying manually, use `https://gateway.thegraph.com/api/<API_KEY>/subgraphs/id/<SUBGRAPH_ID>`.

**Coming soon:**

- Base Sepolia
- Base Mainnet
- Additional networks
## What the Subgraph Provides

The subgraph indexes:

- **Agent registrations** - Identity, metadata, endpoints
- **Agent capabilities** - MCP tools/prompts/resources, A2A skills/tasks
- **Feedback data** - Scores, tags, reputation signals
- **Real-time updates** - Automatic indexing of new registrations and feedback
## Benefits

- **Fast search** - Query thousands of agents in milliseconds
- **Rich filtering** - Search by capabilities, reputation, trust models
- **Real-time data** - Always up-to-date with blockchain events
- **No RPC limits** - Avoid rate limits on blockchain queries
## Next Steps

- Explore [Data Structures](/4-subgraph/4-2-data-structures/)
- See [Example Queries](/4-subgraph/4-3-example-queries/)

---
title: "Search"
description: "Discover agents"
---
Powerful search capabilities to find agents by capabilities, reputation, and more.

## Basic Search

<Tabs>
<TabItem label="Python">

```python
from agent0_sdk import SDK

# Initialize SDK (no signer needed for search)
sdk = SDK(
    chainId=11155111,
    rpcUrl="https://sepolia.infura.io/v3/YOUR_PROJECT_ID"
)

# Search by name (substring match)
results = sdk.searchAgents(name="AI")
print(f"Found {len(results['items'])} agents")
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';

// Initialize SDK (no signer needed for search)
const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: 'https://sepolia.infura.io/v3/YOUR_PROJECT_ID',
});

// Search by name (substring match) - async in TypeScript
const results = await sdk.searchAgents({ name: 'AI' });
console.log(`Found ${results.items.length} agents`);
```

</TabItem>
</Tabs>

## Search Parameters

### Keyword (Semantic Search)

Use `keyword` to prefilter agents using the external semantic search endpoint, then apply all other filters on subgraph data.

<Tabs>
<TabItem label="Python">

```python
results = sdk.searchAgents(
    filters={"keyword": "market analysis", "chains": [1]},
    options={"pageSize": 20},
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const results = await sdk.searchAgents(
  { keyword: 'market analysis', chains: [1] },
  { pageSize: 20 }
);
```

</TabItem>
</Tabs>

### By Endpoints

<Tabs>
<TabItem label="Python">

```python
# Find agents with MCP endpoints
results = sdk.searchAgents(filters={"hasMCP": True})

# Find agents with A2A endpoints
results = sdk.searchAgents(filters={"hasA2A": True})

# Find agents with a Web endpoint
results = sdk.searchAgents(filters={"hasWeb": True})
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Find agents with MCP endpoints
const results = await sdk.searchAgents({ hasMCP: true });

// Find agents with A2A endpoints
const results = await sdk.searchAgents({ hasA2A: true });

// Find agents with a Web endpoint
const results = await sdk.searchAgents({ hasWeb: true });
```

</TabItem>
</Tabs>

### By Capabilities

<Tabs>
<TabItem label="Python">

```python
# Find agents with specific MCP tools
results = sdk.searchAgents(mcpTools=["code_generation"])

# Find agents with specific A2A skills
results = sdk.searchAgents(a2aSkills=["python"])

# Find agents with specific MCP prompts
results = sdk.searchAgents(mcpPrompts=["code_review"])

# Find agents with specific MCP resources
results = sdk.searchAgents(mcpResources=["documentation"])
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Find agents with specific MCP tools
const results = await sdk.searchAgents({ mcpTools: ['code_generation'] });

// Find agents with specific A2A skills
const results = await sdk.searchAgents({ a2aSkills: ['python'] });

// Find agents with specific MCP prompts
const results = await sdk.searchAgents({ mcpPrompts: ['code_review'] });

// Find agents with specific MCP resources
const results = await sdk.searchAgents({ mcpResources: ['documentation'] });
```

</TabItem>
</Tabs>

### By Trust Models

<Tabs>
<TabItem label="Python">

```python
# Find agents supporting reputation
results = sdk.searchAgents(supportedTrust=["reputation"])

# Find agents with x402 payment support
results = sdk.searchAgents(x402support=True)
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Find agents supporting reputation
const results = await sdk.searchAgents({ supportedTrust: ['reputation'] });

// Find agents with x402 payment support
const results = await sdk.searchAgents({ x402support: true });
```

</TabItem>
</Tabs>

### By Status

<Tabs>
<TabItem label="Python">

```python
# Find only active agents
results = sdk.searchAgents(active=True)

# Find inactive agents
results = sdk.searchAgents(active=False)
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Find only active agents
const results = await sdk.searchAgents({ active: true });

// Find inactive agents
const results = await sdk.searchAgents({ active: false });
```

</TabItem>
</Tabs>

### By ENS

<Tabs>
<TabItem label="Python">

```python
# Find agents by ENS domain
results = sdk.searchAgents(filters={"ensContains": "agent.eth"})
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Find agents by ENS domain
const results = await sdk.searchAgents({ ensContains: 'agent.eth' });
```

</TabItem>
</Tabs>

### By Reputation / Feedback (Unified Search)

Reputation filters are expressed as `filters.feedback` (this replaces the old “search by reputation” API).

<Tabs>
<TabItem label="Python">

```python
results = sdk.searchAgents(
    filters={
        "chains": [1],
        "feedback": {
            "includeRevoked": False,
            "minValue": 80,
            "minCount": 3,
            "tag1": "starred",
            "tag2": "token_analysis",
            "endpoint": "gekkoterminal",
        },
    },
    options={"pageSize": 20, "sort": ["averageValue:desc"]},
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const results = await sdk.searchAgents(
  {
    chains: [1],
    feedback: {
      includeRevoked: false,
      minValue: 80,
      minCount: 3,
      tag1: 'starred',
      tag2: 'token_analysis',
      endpoint: 'gekkoterminal',
    },
  },
  { pageSize: 20, sort: ['averageValue:desc'] }
);
```

</TabItem>
</Tabs>

### By Metadata (Two-Phase Prefilter)

Metadata filters query `AgentMetadata` first, then constrain the agent query.

<Tabs>
<TabItem label="Python">

```python
results = sdk.searchAgents(
    filters={"hasMetadataKey": "agentWallet"},
    options={"pageSize": 20},
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const results = await sdk.searchAgents(
  { hasMetadataKey: 'agentWallet' },
  { pageSize: 20 }
);
```

</TabItem>
</Tabs>

## Combined Search

<Tabs>
<TabItem label="Python">

```python
# Complex multi-criteria search
results = sdk.searchAgents(
    filters={
        "mcpTools": ["code_generation"],
        "a2aSkills": ["python"],
        "active": True,
        "x402support": True,
        "hasMCP": True,
        "feedback": {"hasFeedback": True, "minValue": 70},
    },
    options={"pageSize": 20},
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Complex multi-criteria search
const results = await sdk.searchAgents(
  {
    mcpTools: ['code_generation'],
    a2aSkills: ['python'],
    active: true,
    x402support: true,
    hasMCP: true,
    feedback: { hasFeedback: true, minValue: 70 },
  },
  { pageSize: 20 }
);
```

</TabItem>
</Tabs>

## Pagination and Sorting

<Tabs>
<TabItem label="Python">

```python
# Paginated search
results = sdk.searchAgents(
    filters={},
    options={
        "pageSize": 20,
        "cursor": results.get("nextCursor"),  # For next page
        "sort": ["updatedAt:desc"],  # Sort by most recently updated
    },
)

for agent in results['items']:
    print(f"{agent.name}: {agent.description}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Paginated search
let cursor: string | undefined;
const results = await sdk.searchAgents({}, {
  sort: ['updatedAt:desc'], // Sort by most recently updated
  pageSize: 20,
  cursor, // For next page (set cursor = results.nextCursor)
});

for (const agent of results.items) {
  console.log(`${agent.name}: ${agent.description}`);
}
```

</TabItem>
</Tabs>

## Get Single Agent

<Tabs>
<TabItem label="Python">

```python
# Get specific agent by ID
# Using default chain
agent = sdk.getAgent("123")  # Uses SDK's default chain

# Explicitly specify chain
agent = sdk.getAgent("11155111:123")  # ETH Sepolia

print(f"Name: {agent.name}")
print(f"MCP Tools: {agent.mcpTools}")
print(f"A2A Skills: {agent.a2aSkills}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Get specific agent by ID (async in TypeScript)
// Using default chain
const agent = await sdk.getAgent('123');  // Uses SDK's default chain

// Explicitly specify chain
const agent = await sdk.getAgent('11155111:123');  // ETH Sepolia

console.log(`Name: ${agent.name}`);
console.log(`MCP Tools: ${agent.mcpTools?.join(', ')}`);
console.log(`A2A Skills: ${agent.a2aSkills?.join(', ')}`);
```

</TabItem>
</Tabs>

## Multi-Chain Search

The SDK supports multi-chain search when multiple chains are configured.
SDK defaults currently include **Ethereum Mainnet (1)**, **Ethereum Sepolia (11155111)**, and **Polygon Mainnet (137)** for discovery.

### Default Chain

When you initialize the SDK, you specify a **default chain**:

<Tabs>
<TabItem label="Python">

```python
sdk = SDK(
    chainId=11155111,  # This becomes the default chain
    rpcUrl="https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY"
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const sdk = new SDK({
  chainId: 11155111,  // This becomes the default chain
  rpcUrl: 'https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY'
});
```

</TabItem>
</Tabs>

The default chain is used when:

- You provide an `agentId` without a `chainId` prefix (e.g., `"1234"` instead of `"11155111:1234"`)
- You call functions without specifying a chain parameter
### Agent ID Format

The SDK supports two agent ID formats:

- **Agent ID only**: `"1234"` - Uses SDK’s default chain
- **Chain ID prefix**: `"11155111:1234"` - Explicitly specifies the chain (format: `"{chainId}:{agentId}"`)
### Supported Networks

- **Ethereum Mainnet** (Chain ID: `1`)
- **Ethereum Sepolia** (Chain ID: `11155111`)
- **Polygon Mainnet** (Chain ID: `137`)

Additional networks are planned but not enabled in SDK defaults yet.
### Multi-Chain Agent Search

<Tabs>
<TabItem label="Python">

```python
# Single chain (uses SDK's default chain)
results = sdk.searchAgents(filters={"active": True})

# Single specific chain
results = sdk.searchAgents(filters={"chains": [11155111], "active": True})

# Multiple chains
results = sdk.searchAgents(filters={"chains": [1, 11155111, 137], "active": True})

# All supported chains
results = sdk.searchAgents(filters={"chains": "all", "active": True})
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Single chain (uses SDK's default chain)
const results = await sdk.searchAgents({ active: true });

// Single specific chain
const results = await sdk.searchAgents({
  active: true,
  chains: [11155111]  // Ethereum Sepolia
});

// Multiple chains
const results = await sdk.searchAgents({
  active: true,
  chains: [1, 11155111]  // Ethereum Mainnet and Ethereum Sepolia
});

// All supported chains
const results = await sdk.searchAgents({
  active: true,
  chains: 'all'  // Searches all configured chains
});
```

</TabItem>
</Tabs>

### Multi-Chain Response Format

When searching multiple chains, the response includes metadata:

<Tabs>
<TabItem label="Python">

```python
{
    "items": [AgentSummary, ...],  # Agents from all requested chains
    "nextCursor": "20",  # Pagination cursor
    "meta": {  # Only present for multi-chain queries
        "chains": [11155111],  # Chains that were queried
        "successfulChains": [11155111],  # Chains that returned results
        "failedChains": [],  # Chains that failed (if any)
        "totalResults": 15,  # Total agents found
        "timing": {"totalMs": 234}  # Query time in milliseconds
    }
}
```

</TabItem>
<TabItem label="TypeScript">

```ts
{
  items: AgentSummary[],  // Agents from all requested chains
  nextCursor?: string,     // Pagination cursor
  meta?: {                  // Only present for multi-chain queries
    chains: number[],       // Chains that were queried
    successfulChains: number[],  // Chains that returned results
    failedChains: number[],      // Chains that failed (if any)
    totalResults: number,    // Total agents found
    timing: {
      totalMs: number,      // Total query time in milliseconds
      averagePerChainMs?: number  // Average time per chain
    }
  }
}
```

</TabItem>
</Tabs>

## Agent Summary Properties

The search returns `AgentSummary` objects with:

<Tabs>
<TabItem label="Python">

```python
agent.chainId          # 11155111
agent.agentId         # "11155111:123"
agent.name            # "My Agent"
agent.description     # "Agent description"
agent.image          # "https://..."
agent.active         # True/False
agent.owners         # ["0x..."]
agent.operators      # ["0x..."]
agent.walletAddress  # "0x..."
agent.mcpTools       # ["tool1", "tool2"]
agent.a2aSkills      # ["skill1", "skill2"]
```

</TabItem>
<TabItem label="TypeScript">

```ts
import type { AgentSummary } from 'agent0-sdk';

agent.chainId          // 11155111
agent.agentId         // "11155111:123"
agent.name            // "My Agent"
agent.description     // "Agent description"
agent.image           // "https://..." | undefined
agent.active          // true | false
agent.owners          // ["0x..."]
agent.operators       // ["0x..."]
agent.walletAddress   // "0x..." | undefined
agent.mcpTools        // ["tool1", "tool2"] | undefined
agent.a2aSkills       // ["skill1", "skill2"] | undefined
```

</TabItem>
</Tabs>

## Advanced Search

<Tabs>
<TabItem label="Python">

```python
# Using SearchFilters for complex queries
results = sdk.searchAgents(
    filters={
        "name": "Test",
        "mcpTools": ["code_generation", "analysis"],
        "active": True,
        "supportedTrust": ["reputation"],
        "feedback": {"hasFeedback": True},
    },
    options={"pageSize": 20, "sort": ["updatedAt:desc"]},
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { SearchFilters, SearchOptions } from 'agent0-sdk';

// Using SearchFilters/SearchOptions for complex queries
const filters: SearchFilters = {
  name: 'Test',
  mcpTools: ['code_generation', 'analysis'],
  active: true,
  supportedTrust: ['reputation'],
  feedback: { hasFeedback: true },
};
const options: SearchOptions = { pageSize: 20, sort: ['updatedAt:desc'] };

const results = await sdk.searchAgents(filters, options);
```

</TabItem>
</Tabs>

## Next Steps

- Learn about [Feedback](/2-usage/2-6-use-feedback/)
- Try [Examples](/3-examples/3-1-quick-start/)

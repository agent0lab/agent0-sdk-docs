---
title: "Search Agents"
description: "Advanced search examples"
---
Creative examples showing various search and discovery patterns.

## Find MCP-Aware Agents

<Tabs>
<TabItem label="Python">

```python
from agent0_sdk import SDK
import os

# Initialize SDK
# Subgraph automatically uses default URL - no configuration needed!
sdk = SDK(
    chainId=11155111,
    rpcUrl=os.getenv("RPC_URL")
)

# Find all agents with MCP endpoints
results = sdk.searchAgents(mcp=True)
for agent in results['items']:
    print(f"{agent.name} - MCP enabled")
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';

async function main() {
  // Initialize SDK
  // Subgraph automatically uses default URL - no configuration needed!
  const sdk = new SDK({
    chainId: 11155111,
    rpcUrl: process.env.RPC_URL || '',
  });

  // Find all agents with MCP endpoints (async in TypeScript)
  const results = await sdk.searchAgents({ mcp: true });
  for (const agent of results.items) {
    console.log(`${agent.name} - MCP enabled`);
  }
}

main().catch(console.error);
```

</TabItem>
</Tabs>

## Find Agents by Skills

<Tabs>
<TabItem label="Python">

```python
# Python developers
results = sdk.searchAgents(a2aSkills=["python"])
print(f"Found {len(results['items'])} Python agents")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Python developers (async in TypeScript)
const results = await sdk.searchAgents({ a2aSkills: ['python'] });
console.log(`Found ${results.items.length} Python agents`);
```

</TabItem>
</Tabs>

## Highly-Rated Agents

<Tabs>
<TabItem label="Python">

```python
# Top-rated agents
results = sdk.searchAgentsByReputation(
    minAverageValue=90,
    tags=["enterprise"]
)
for agent in results['items']:
    print(f"{agent.name}: {agent.extras['averageValue']}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Top-rated agents (async in TypeScript)
const results = await sdk.searchAgentsByReputation({
  tags: ['enterprise'],
  minAverageValue: 90,
});
for (const agent of results.items) {
  console.log(`${agent.name}: ${agent.extras.averageValue}`);
}
```

</TabItem>
</Tabs>

## Multi-Criteria Search

<Tabs>
<TabItem label="Python">

```python
# Complex search
results = sdk.searchAgents(
    mcpTools=["code_generation", "analysis"],
    a2aSkills=["python", "javascript"],
    active=True,
    x402support=True,
    supportedTrust=["reputation"]
)

print(f"Found {len(results['items'])} matching agents")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Complex search (async in TypeScript)
const results = await sdk.searchAgents({
  mcpTools: ['code_generation', 'analysis'],
  a2aSkills: ['python', 'javascript'],
  active: true,
  x402support: true,
  supportedTrust: ['reputation'],
});

console.log(`Found ${results.items.length} matching agents`);
```

</TabItem>
</Tabs>

## Pagination

<Tabs>
<TabItem label="Python">

```python
# Paginated results
cursor = None
all_agents = []

while True:
    results = sdk.searchAgents(page_size=50, cursor=cursor)
    all_agents.extend(results['items'])

    cursor = results.get('nextCursor')
    if not cursor:
        break

print(f"Total agents: {len(all_agents)}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Paginated results (async in TypeScript)
let cursor: string | undefined;
const allAgents = [];

while (true) {
  const results = await sdk.searchAgents({}, { pageSize: 50, cursor });
  allAgents.push(...results.items);

  cursor = results.nextCursor;
  if (!cursor) {
    break;
  }
}

console.log(`Total agents: ${allAgents.length}`);
```

</TabItem>
</Tabs>

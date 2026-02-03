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
results = sdk.searchAgents(filters={"hasMCP": True})
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
  const results = await sdk.searchAgents({ hasMCP: true });
  for (const agent of results.items) {
    console.log(`${agent.name} - MCP enabled`);
  }
}

main().catch(console.error);
```

</TabItem>
</Tabs>

## Exhaustive Search Reference (all filters + all options)

This appendix duplicates the full unified search surface so you can copy/paste filters and options while reading examples.

### FeedbackFilters

<Tabs>
<TabItem label="Python">

```python
@dataclass
class FeedbackFilters:
    hasFeedback: Optional[bool] = None
    hasNoFeedback: Optional[bool] = None
    includeRevoked: Optional[bool] = None
    minValue: Optional[float] = None
    maxValue: Optional[float] = None
    minCount: Optional[int] = None
    maxCount: Optional[int] = None
    fromReviewers: Optional[List[Address]] = None
    endpoint: Optional[str] = None          # substring match
    hasResponse: Optional[bool] = None
    tag1: Optional[str] = None
    tag2: Optional[str] = None
    tag: Optional[str] = None               # matches tag1 OR tag2
```

</TabItem>
<TabItem label="TypeScript">

```ts
export interface FeedbackFilters {
  hasFeedback?: boolean;
  hasNoFeedback?: boolean;
  includeRevoked?: boolean;
  minValue?: number;
  maxValue?: number;
  minCount?: number;
  maxCount?: number;
  fromReviewers?: Address[];
  endpoint?: string; // substring match
  hasResponse?: boolean;
  tag1?: string;
  tag2?: string;
  tag?: string; // matches tag1 OR tag2
}
```

</TabItem>
</Tabs>

| Field | Semantics |
| --- | --- |
| `hasFeedback` | Only agents with at least 1 feedback |
| `hasNoFeedback` | Only agents with 0 feedback |
| `includeRevoked` | Include revoked feedback entries in the pool used for filtering |
| `minValue` / `maxValue` | Threshold on **average value** over matching feedback (inclusive) |
| `minCount` / `maxCount` | Threshold on **count** over matching feedback (inclusive) |
| `fromReviewers` | Only consider feedback from these reviewer wallets |
| `endpoint` | Only consider feedback whose `endpoint` contains this substring |
| `hasResponse` | Only consider feedback that has at least one response (if supported) |
| `tag1` / `tag2` | Only consider feedback matching tag1/tag2 |
| `tag` | Shorthand: match either tag1 OR tag2 |

### SearchFilters

<Tabs>
<TabItem label="Python">

```python
DateLike = Union[datetime, str, int]

@dataclass
class SearchFilters:
    chains: Optional[Union[List[ChainId], Literal["all"]]] = None
    agentIds: Optional[List[AgentId]] = None
    name: Optional[str] = None
    description: Optional[str] = None
    owners: Optional[List[Address]] = None
    operators: Optional[List[Address]] = None
    hasRegistrationFile: Optional[bool] = None
    hasWeb: Optional[bool] = None
    hasMCP: Optional[bool] = None
    hasA2A: Optional[bool] = None
    hasOASF: Optional[bool] = None
    hasEndpoints: Optional[bool] = None
    webContains: Optional[str] = None
    mcpContains: Optional[str] = None
    a2aContains: Optional[str] = None
    ensContains: Optional[str] = None
    didContains: Optional[str] = None
    walletAddress: Optional[Address] = None
    supportedTrust: Optional[List[str]] = None
    a2aSkills: Optional[List[str]] = None
    mcpTools: Optional[List[str]] = None
    mcpPrompts: Optional[List[str]] = None
    mcpResources: Optional[List[str]] = None
    oasfSkills: Optional[List[str]] = None
    oasfDomains: Optional[List[str]] = None
    active: Optional[bool] = None
    x402support: Optional[bool] = None
    registeredAtFrom: Optional[DateLike] = None
    registeredAtTo: Optional[DateLike] = None
    updatedAtFrom: Optional[DateLike] = None
    updatedAtTo: Optional[DateLike] = None
    hasMetadataKey: Optional[str] = None
    metadataValue: Optional[Dict[str, str]] = None  # { key, value }
    keyword: Optional[str] = None
    feedback: Optional[FeedbackFilters] = None
```

</TabItem>
<TabItem label="TypeScript">

```ts
export interface SearchFilters {
  chains?: number[] | 'all';
  agentIds?: AgentId[];
  name?: string;
  description?: string;
  owners?: Address[];
  operators?: Address[];
  hasRegistrationFile?: boolean;
  hasWeb?: boolean;
  hasMCP?: boolean;
  hasA2A?: boolean;
  hasOASF?: boolean;
  hasEndpoints?: boolean;
  webContains?: string;
  mcpContains?: string;
  a2aContains?: string;
  ensContains?: string;
  didContains?: string;
  walletAddress?: Address;
  supportedTrust?: string[];
  a2aSkills?: string[];
  mcpTools?: string[];
  mcpPrompts?: string[];
  mcpResources?: string[];
  oasfSkills?: string[];
  oasfDomains?: string[];
  active?: boolean;
  x402support?: boolean;
  registeredAtFrom?: Date | string | number;
  registeredAtTo?: Date | string | number;
  updatedAtFrom?: Date | string | number;
  updatedAtTo?: Date | string | number;
  hasMetadataKey?: string;
  metadataValue?: { key: string; value: string };
  keyword?: string;
  feedback?: FeedbackFilters;
}
```

</TabItem>
</Tabs>

### SearchOptions

<Tabs>
<TabItem label="Python">

```python
@dataclass
class SearchOptions:
    sort: Optional[List[str]] = None
    pageSize: Optional[int] = None
    cursor: Optional[str] = None
    semanticMinScore: Optional[float] = None
    semanticTopK: Optional[int] = None
```

</TabItem>
<TabItem label="TypeScript">

```ts
export interface SearchOptions {
  sort?: string[];
  pageSize?: number;
  cursor?: string;
  semanticMinScore?: number;
  semanticTopK?: number;
}
```

</TabItem>
</Tabs>

## Find Agents by Skills

<Tabs>
<TabItem label="Python">

```python
# Python developers
results = sdk.searchAgents(filters={"a2aSkills": ["python"]})
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
results = sdk.searchAgents(
    filters={"feedback": {"minValue": 90, "tag": "enterprise", "includeRevoked": False}},
    options={"pageSize": 20, "sort": ["averageValue:desc"]},
)
for agent in results['items']:
    print(f"{agent.name}: {agent.averageValue}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Top-rated agents (async in TypeScript)
const results = await sdk.searchAgents(
  { feedback: { minValue: 90, tag: 'enterprise', includeRevoked: false } },
  { pageSize: 20, sort: ['averageValue:desc'] }
);
for (const agent of results.items) {
  console.log(`${agent.name}: ${agent.averageValue}`);
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
    filters={
        "mcpTools": ["code_generation", "analysis"],
        "a2aSkills": ["python", "javascript"],
        "active": True,
        "x402support": True,
        "supportedTrust": ["reputation"],
        "feedback": {"hasFeedback": True, "minValue": 70},
    },
    options={"pageSize": 20, "sort": ["updatedAt:desc"]},
)

print(f"Found {len(results['items'])} matching agents")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Complex search (async in TypeScript)
const results = await sdk.searchAgents(
  {
  mcpTools: ['code_generation', 'analysis'],
  a2aSkills: ['python', 'javascript'],
  active: true,
  x402support: true,
  supportedTrust: ['reputation'],
    feedback: { hasFeedback: true, minValue: 70 },
  },
  { pageSize: 20, sort: ['updatedAt:desc'] }
);

console.log(`Found ${results.items.length} matching agents`);
```

</TabItem>
</Tabs>

## Kitchen Sink (Endpoints + Time + Metadata + Feedback + Sorting + Cursor)

One query combining many of the unified search features:
- Endpoint existence + substring matching
- Time range filters
- Metadata prefilter
- Feedback-based reputation filtering (tags + endpoint + reviewers + thresholds)
- Sorting and pagination cursor

<Tabs>
<TabItem label="Python">

```python
from agent0_sdk import SDK
import os

sdk = SDK(chainId=1, rpcUrl=os.getenv("RPC_URL"))  # read-only is fine

results = sdk.searchAgents(
    filters={
        "chains": [1],
        "active": True,
        "hasMCP": True,
        "mcpContains": "mcp",
        "hasWeb": True,
        "registeredAtFrom": "2025-01-01",
        "updatedAtTo": "2026-12-31",
        # Metadata is a two-phase prefilter (matches on-chain metadata entries)
        "hasMetadataKey": "category",
        "feedback": {
            "includeRevoked": False,
            "tag": "enterprise",
            "endpoint": "https://",
            "fromReviewers": ["0x742d35cc6634c0532925a3b844bc9e7595f0beb7"],
            "minValue": 80,
            "minCount": 3,
        },
    },
    options={
        "pageSize": 25,
        "sort": ["averageValue:desc", "updatedAt:desc"],
    },
)

print(f"Returned {len(results['items'])} agents")
print("Next cursor:", results.get("nextCursor"))
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';

async function main() {
  const sdk = new SDK({ chainId: 1, rpcUrl: process.env.RPC_URL || '' });

  const results = await sdk.searchAgents(
    {
      chains: [1],
      active: true,
      hasMCP: true,
      mcpContains: 'mcp',
      hasWeb: true,
      registeredAtFrom: '2025-01-01',
      updatedAtTo: '2026-12-31',
      // Metadata is a two-phase prefilter (matches on-chain metadata entries)
      hasMetadataKey: 'category',
      feedback: {
        includeRevoked: false,
        tag: 'enterprise',
        endpoint: 'https://',
        fromReviewers: ['0x742d35cc6634c0532925a3b844bc9e7595f0beb7'],
        minValue: 80,
        minCount: 3,
      },
    },
    { pageSize: 25, sort: ['averageValue:desc', 'updatedAt:desc'] }
  );

  console.log(`Returned ${results.items.length} agents`);
  console.log('Next cursor:', results.nextCursor);
}

main().catch(console.error);
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
    results = sdk.searchAgents(filters={}, options={"pageSize": 50, "cursor": cursor})
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

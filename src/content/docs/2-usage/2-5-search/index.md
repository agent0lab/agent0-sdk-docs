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
print(f"Found {len(results)} agents")
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
console.log(`Found ${results.length} agents`);
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
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const results = await sdk.searchAgents(
  { keyword: 'market analysis', chains: [1] }
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
results = sdk.searchAgents(filters={"mcpTools": ["code_generation"]})

# Find agents with specific A2A skills
results = sdk.searchAgents(filters={"a2aSkills": ["python"]})

# Find agents with specific MCP prompts
results = sdk.searchAgents(filters={"mcpPrompts": ["code_review"]})

# Find agents with specific MCP resources
results = sdk.searchAgents(filters={"mcpResources": ["documentation"]})
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
results = sdk.searchAgents(filters={"supportedTrust": ["reputation"]})

# Find agents with x402 payment support
results = sdk.searchAgents(filters={"x402support": True})
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
results = sdk.searchAgents(filters={"active": True})

# Find inactive agents
results = sdk.searchAgents(filters={"active": False})
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
    options={"sort": ["averageValue:desc"]},
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
  { sort: ['averageValue:desc'] }
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
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const results = await sdk.searchAgents(
  { hasMetadataKey: 'agentWallet' }
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
);
```

</TabItem>
</Tabs>

## Sorting (No Pagination)

<Tabs>
<TabItem label="Python">

```python
# Sorting (returns all matching results)
results = sdk.searchAgents(filters={}, options={"sort": ["updatedAt:desc"]})

for agent in results:
    print(f"{agent.name}: {agent.description}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Sorting (returns all matching results)
const results = await sdk.searchAgents({}, { sort: ['updatedAt:desc'] });

for (const agent of results) {
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

`searchAgents()` always returns a **plain list** of `AgentSummary` (even for multi-chain queries). The list may contain agents from multiple chains when you set `filters.chains` to a list or `'all'`.

## Agent Summary Properties

`searchAgents()` returns `AgentSummary` objects. Below is the **complete** `AgentSummary` schema and field-by-field meaning.

<Tabs>
<TabItem label="Python">

```python
@dataclass
class AgentSummary:
    chainId: ChainId
    agentId: AgentId
    name: str
    image: Optional[URI]
    description: str
    owners: List[Address]
    operators: List[Address]
    # Endpoint strings (present when advertised; not booleans)
    mcp: Optional[str] = None
    a2a: Optional[str] = None
    web: Optional[str] = None
    email: Optional[str] = None
    ens: Optional[str]
    did: Optional[str]
    walletAddress: Optional[Address]
    supportedTrusts: List[str]
    a2aSkills: List[str]
    mcpTools: List[str]
    mcpPrompts: List[str]
    mcpResources: List[str]
    oasfSkills: List[str]
    oasfDomains: List[str]
    active: bool
    x402support: bool
    # Optional (subgraph fields / search-derived)
    createdAt: Optional[int] = None
    updatedAt: Optional[int] = None
    lastActivity: Optional[int] = None
    agentURI: Optional[str] = None
    agentURIType: Optional[str] = None
    feedbackCount: Optional[int] = None
    averageValue: Optional[float] = None
    semanticScore: Optional[float] = None
    extras: Dict[str, Any] = field(default_factory=dict)
```

</TabItem>
<TabItem label="TypeScript">

```ts
export interface AgentSummary {
  chainId: number;
  agentId: AgentId;
  name: string;
  image?: URI;
  description: string;
  owners: Address[];
  operators: Address[];
  // Endpoint strings (present when advertised; not booleans)
  mcp?: string;
  a2a?: string;
  web?: string;
  email?: string;
  ens?: string;
  did?: string;
  walletAddress?: Address;
  supportedTrusts: string[];
  a2aSkills: string[];
  mcpTools: string[];
  mcpPrompts: string[];
  mcpResources: string[];
  oasfSkills: string[];
  oasfDomains: string[];
  active: boolean;
  x402support: boolean;
  // Optional (subgraph fields / search-derived)
  createdAt?: number;
  updatedAt?: number;
  lastActivity?: number;
  agentURI?: string;
  agentURIType?: string;
  feedbackCount?: number;
  averageValue?: number;
  semanticScore?: number;
  extras: Record<string, any>;
}
```

</TabItem>
</Tabs>

| Field | Type (TS / Python) | When present | Source |
| --- | --- | --- | --- |
| `chainId` | `number` / `int` | Always | Subgraph `Agent.chainId` |
| `agentId` | `AgentId` / `AgentId` | Always | Subgraph `Agent.id` normalized to `"chainId:agentId"` |
| `name` | `string` / `str` | Always | Subgraph `Agent.registrationFile.name` |
| `description` | `string` / `str` | Always | Subgraph `Agent.registrationFile.description` |
| `image` | `URI?` / `Optional[URI]` | Optional | Subgraph `Agent.registrationFile.image` |
| `owners` | `Address[]` / `List[Address]` | Always | Subgraph `Agent.owner` |
| `operators` | `Address[]` / `List[Address]` | Always | Subgraph `Agent.operators` |
| `active` | `boolean` / `bool` | Always | Subgraph `Agent.registrationFile.active` |
| `x402support` | `boolean` / `bool` | Always | Subgraph `Agent.registrationFile.x402Support` (compat: `x402support`) |
| `mcp` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.registrationFile.mcpEndpoint` |
| `a2a` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.registrationFile.a2aEndpoint` |
| `web` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.registrationFile.webEndpoint` |
| `email` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.registrationFile.emailEndpoint` |
| `ens` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.registrationFile.ens` |
| `did` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.registrationFile.did` |
| `walletAddress` | `Address?` / `Optional[Address]` | Optional | Subgraph `Agent.agentWallet` (on-chain metadata) |
| `supportedTrusts` | `string[]` / `List[str]` | Always | Subgraph `Agent.registrationFile.supportedTrusts` |
| `a2aSkills` | `string[]` / `List[str]` | Always | Subgraph `Agent.registrationFile.a2aSkills` |
| `mcpTools` | `string[]` / `List[str]` | Always | Subgraph `Agent.registrationFile.mcpTools` |
| `mcpPrompts` | `string[]` / `List[str]` | Always | Subgraph `Agent.registrationFile.mcpPrompts` |
| `mcpResources` | `string[]` / `List[str]` | Always | Subgraph `Agent.registrationFile.mcpResources` |
| `oasfSkills` | `string[]` / `List[str]` | Always (may be empty) | Subgraph `Agent.registrationFile.oasfSkills` |
| `oasfDomains` | `string[]` / `List[str]` | Always (may be empty) | Subgraph `Agent.registrationFile.oasfDomains` |
| `createdAt` | `number?` / `Optional[int]` | Optional | Subgraph `Agent.createdAt` |
| `updatedAt` | `number?` / `Optional[int]` | Optional | Subgraph `Agent.updatedAt` |
| `lastActivity` | `number?` / `Optional[int]` | Optional | Subgraph `Agent.lastActivity` |
| `agentURI` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.agentURI` |
| `agentURIType` | `string?` / `Optional[str]` | Optional | Subgraph `Agent.agentURIType` |
| `feedbackCount` | `number?` / `Optional[int]` | Optional | Subgraph `Agent.totalFeedback` |
| `averageValue` | `number?` / `Optional[float]` | Optional | Computed by unified search feedback prefilter for the current query |
| `semanticScore` | `number?` / `Optional[float]` | Optional | Returned only for keyword searches (semantic prefilter score) |
| `extras` | `Record` / `Dict[str, Any]` | Always | Reserved for experimental/extra fields |

## Exhaustive Search Reference (all filters + all options)

This section duplicates the full unified search surface so you can copy/paste filters and options without jumping to other pages.

### FeedbackFilters

All reputation filtering is expressed under `SearchFilters.feedback`.

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
| `minValue` / `maxValue` | Threshold on **average value** over feedback matching the other feedback constraints (inclusive) |
| `minCount` / `maxCount` | Threshold on **count** of feedback matching the other feedback constraints (inclusive) |
| `fromReviewers` | Only consider feedback from these reviewer wallets |
| `endpoint` | Only consider feedback where `endpoint` contains this substring |
| `hasResponse` | Only consider feedback that has at least one response (if supported) |
| `tag1` / `tag2` | Only consider feedback with matching tag1/tag2 |
| `tag` | Shorthand: match either tag1 OR tag2 |

### SearchFilters

<Tabs>
<TabItem label="Python">

```python
DateLike = Union[datetime, str, int]

@dataclass
class SearchFilters:
    # Chain / identity
    chains: Optional[Union[List[ChainId], Literal["all"]]] = None
    agentIds: Optional[List[AgentId]] = None

    # Text
    name: Optional[str] = None              # substring
    description: Optional[str] = None       # substring

    # Owners / operators
    owners: Optional[List[Address]] = None
    operators: Optional[List[Address]] = None

    # Endpoint existence
    hasRegistrationFile: Optional[bool] = None
    hasWeb: Optional[bool] = None
    hasMCP: Optional[bool] = None
    hasA2A: Optional[bool] = None
    hasOASF: Optional[bool] = None
    hasEndpoints: Optional[bool] = None

    # Endpoint substring contains
    webContains: Optional[str] = None
    mcpContains: Optional[str] = None
    a2aContains: Optional[str] = None
    ensContains: Optional[str] = None
    didContains: Optional[str] = None

    # Wallet
    walletAddress: Optional[Address] = None

    # Capability arrays (ANY semantics)
    supportedTrust: Optional[List[str]] = None
    a2aSkills: Optional[List[str]] = None
    mcpTools: Optional[List[str]] = None
    mcpPrompts: Optional[List[str]] = None
    mcpResources: Optional[List[str]] = None
    oasfSkills: Optional[List[str]] = None
    oasfDomains: Optional[List[str]] = None

    # Status
    active: Optional[bool] = None
    x402support: Optional[bool] = None

    # Time filters
    registeredAtFrom: Optional[DateLike] = None
    registeredAtTo: Optional[DateLike] = None
    updatedAtFrom: Optional[DateLike] = None
    updatedAtTo: Optional[DateLike] = None

    # Metadata filters (two-phase)
    hasMetadataKey: Optional[str] = None
    metadataValue: Optional[Dict[str, str]] = None  # { key, value }

    # Semantic search
    keyword: Optional[str] = None

    # Feedback filters (two-phase)
    feedback: Optional[FeedbackFilters] = None
```

</TabItem>
<TabItem label="TypeScript">

```ts
export interface SearchFilters {
  // Chain / identity
  chains?: number[] | 'all';
  agentIds?: AgentId[];

  // Text
  name?: string; // substring
  description?: string; // substring

  // Owners / operators
  owners?: Address[];
  operators?: Address[];

  // Endpoint existence
  hasRegistrationFile?: boolean;
  hasWeb?: boolean;
  hasMCP?: boolean;
  hasA2A?: boolean;
  hasOASF?: boolean;
  hasEndpoints?: boolean;

  // Endpoint substring contains
  webContains?: string;
  mcpContains?: string;
  a2aContains?: string;
  ensContains?: string;
  didContains?: string;

  // Wallet
  walletAddress?: Address;

  // Capability arrays (ANY semantics)
  supportedTrust?: string[];
  a2aSkills?: string[];
  mcpTools?: string[];
  mcpPrompts?: string[];
  mcpResources?: string[];
  oasfSkills?: string[];
  oasfDomains?: string[];

  // Status
  active?: boolean;
  x402support?: boolean;

  // Time filters
  registeredAtFrom?: Date | string | number;
  registeredAtTo?: Date | string | number;
  updatedAtFrom?: Date | string | number;
  updatedAtTo?: Date | string | number;

  // Metadata filters (two-phase)
  hasMetadataKey?: string;
  metadataValue?: { key: string; value: string };

  // Semantic search
  keyword?: string;

  // Feedback filters (two-phase)
  feedback?: FeedbackFilters;
}
```

</TabItem>
</Tabs>

| Field | Semantics |
| --- | --- |
| `chains` | `undefined` uses SDK default chain; list queries those chains; `"all"` queries all configured chains |
| `agentIds` | Only these agent IDs (`"chainId:agentId"`) |
| `name` / `description` | Case-insensitive substring match |
| `owners` / `operators` | Match agent owner or any operator |
| `hasRegistrationFile` | Require a registration file |
| `hasWeb` / `hasMCP` / `hasA2A` / `hasOASF` | Require that endpoint type is present |
| `hasEndpoints` | Require at least one of {web, email, mcp, a2a, oasf} |
| `webContains` / `mcpContains` / `a2aContains` / `ensContains` / `didContains` | Case-insensitive substring match for those endpoint strings |
| `walletAddress` | Exact match for the agent wallet address (if set) |
| `supportedTrust` | ANY-of: agent supports at least one trust model string |
| `a2aSkills` / `mcpTools` / `mcpPrompts` / `mcpResources` / `oasfSkills` / `oasfDomains` | ANY-of: matches at least one listed element |
| `active` / `x402support` | Boolean filters |
| `registeredAtFrom/To` | Inclusive timestamp range over agent `createdAt` |
| `updatedAtFrom/To` | Inclusive timestamp range over agent `updatedAt` |
| `hasMetadataKey` | Require an on-chain metadata entry with this key (two-phase prefilter) |
| `metadataValue` | Require metadata key/value exact match (two-phase prefilter) |
| `keyword` | Semantic keyword prefilter via external semantic-search endpoint |
| `feedback` | Unified reputation filtering (see `FeedbackFilters`) |

### SearchOptions

<Tabs>
<TabItem label="Python">

```python
@dataclass
class SearchOptions:
    sort: Optional[List[str]] = None
    semanticMinScore: Optional[float] = None
    semanticTopK: Optional[int] = None
```

</TabItem>
<TabItem label="TypeScript">

```ts
export interface SearchOptions {
  sort?: string[];
  semanticMinScore?: number;
  semanticTopK?: number;
}
```

</TabItem>
</Tabs>

| Field | Semantics |
| --- | --- |
| `sort` | List of sort keys: `\"field:asc\"` or `\"field:desc\"` |
| `semanticMinScore` | Minimum semantic score cutoff (keyword searches only) |
| `semanticTopK` | Limits semantic prefilter size (semantic endpoint has no cursor) |

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
    options={"sort": ["updatedAt:desc"]},
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
const options: SearchOptions = { sort: ['updatedAt:desc'] };

const results = await sdk.searchAgents(filters, options);
```

</TabItem>
</Tabs>

## Next Steps

- Learn about [Feedback](/2-usage/2-6-use-feedback/)
- Try [Examples](/3-examples/3-1-quick-start/)

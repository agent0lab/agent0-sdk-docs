---
title: "SDK API"
description: "SDK class reference"
---
Complete reference for the SDK class.

For detailed ID format documentation, see [Models Reference](/5-reference/5-3-models/).

## Initialization

<Tabs>
<TabItem label="Python">

```python
sdk = SDK(
    chainId=11155111,  # ChainId
    rpcUrl="https://sepolia.infura.io/v3/YOUR_PROJECT_ID",
    signer=None,  # Optional[Any] (omit for read-only)
    registryOverrides=None,  # Optional[Dict[ChainId, Dict[str, Address]]]
    indexingStore=None,
    embeddings=None,
    ipfs=None,  # Optional[str]: "node" | "filecoinPin" | "pinata"
    ipfsNodeUrl=None,
    filecoinPrivateKey=None,
    pinataJwt=None,
    subgraphOverrides=None,  # Optional[Dict[ChainId, str]]
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { Wallet, Signer } from 'ethers';

const sdk = new SDK({
  chainId: 11155111,
  rpcUrl: 'https://sepolia.infura.io/v3/YOUR_PROJECT_ID',
  signer: process.env.PRIVATE_KEY as string | Wallet | Signer | undefined, // Optional for read-only operations
  // registryOverrides?: Record<ChainId, Record<string, Address>>
  // subgraphUrl?: string
  // subgraphOverrides?: Record<ChainId, string>
});
```

</TabItem>
</Tabs>

**Note:** The `chainId` parameter sets the SDK’s default chain. When you provide an `agentId` without a `chainId` prefix, the SDK uses this default chain.

## Agent Methods

### createAgent

Create a new agent.

<Tabs>
<TabItem label="Python">

```python
agent = sdk.createAgent(
    name: str,
    description: str,
    image: Optional[str] = None
) -> Agent
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK, Agent } from 'agent0-sdk';

const agent: Agent = sdk.createAgent(
  name: string,
  description: string,
  image?: string
);
```

</TabItem>
</Tabs>

### loadAgent

Load an existing agent by ID.

<Tabs>
<TabItem label="Python">

```python
agent = sdk.loadAgent(agentId: str) -> Agent
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK, Agent } from 'agent0-sdk';
import type { AgentId } from 'agent0-sdk';

const agent: Agent = await sdk.loadAgent(agentId: AgentId);
```

</TabItem>
</Tabs>

## Discovery Methods

### searchAgents

Search for agents with filters.

<Tabs>
<TabItem label="Python">

```python
results = sdk.searchAgents(
    params: Union[SearchParams, Dict, None] = None,
    sort: List[str] = None,
    page_size: int = 50,
    cursor: Optional[str] = None,
    **kwargs
) -> Dict[str, Any]
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { SearchParams, AgentSummary } from 'agent0-sdk';

const results: { items: AgentSummary[]; nextCursor?: string } = await sdk.searchAgents(
  filters?: SearchParams,
  options?: { sort?: string[]; pageSize?: number; cursor?: string }
);
```

</TabItem>
</Tabs>

**Parameters:**

- `params.chains` (optional):

- `None` / `undefined` (default) - Uses SDK’s default chain
- `[chainId1, chainId2, ...]` - List of specific chain IDs to search
- `"all"` - Searches all configured chains in parallel

**Multi-chain response:**
When `chains` is specified (not default), the response includes a `meta` object with chain information.

### getAgent

Get a single agent summary.

<Tabs>
<TabItem label="Python">

```python
agent = sdk.getAgent(agentId: str) -> AgentSummary
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, AgentSummary } from 'agent0-sdk';

const agent: AgentSummary | null = await sdk.getAgent(agentId: AgentId);
```

</TabItem>
</Tabs>

**Parameters:**

- `agentId` (str / AgentId): Agent ID in format `"agentId"` (uses SDK’s default chain) or `"chainId:agentId"` (explicit chain, e.g., `"11155111:1234"`)
**Examples:**

<Tabs>
<TabItem label="Python">

```python
# Using default chain
agent = sdk.getAgent("1234")  # Uses SDK's default chain

# Explicitly specify chain
agent = sdk.getAgent("11155111:1234")  # ETH Sepolia
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Using default chain
const agent = await sdk.getAgent('1234');  // Uses SDK's default chain

// Explicitly specify chain
const agent = await sdk.getAgent('11155111:1234');  // ETH Sepolia
```

</TabItem>
</Tabs>

## Feedback Methods

### prepareFeedbackFile

Prepare an **off-chain** feedback file payload (optional).

<Tabs>
<TabItem label="Python">

```python
feedback_file = sdk.prepareFeedbackFile({
    "text": "Optional rich feedback text",
    "capability": "tools",
    "name": "financial_analyzer",
    "skill": "financial_analysis",
    "task": "analyze_balance_sheet",
    "context": {"userId": "user123"},
    "proofOfPayment": {"txHash": "0x...", "amount": "0.01"},
})
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { FeedbackFileInput } from 'agent0-sdk';

const feedbackFile: FeedbackFileInput = sdk.prepareFeedbackFile({
  text: undefined,
  capability: 'tools',
  name: 'financial_analyzer',
  skill: 'financial_analysis',
  task: 'analyze_balance_sheet',
  context: { userId: 'user123' },
  proofOfPayment: { txHash: '0x...', amount: '0.01' },
});
```

</TabItem>
</Tabs>

### giveFeedback

Give feedback on-chain (optionally with an off-chain feedback file).

<Tabs>
<TabItem label="Python">

```python
feedback = sdk.giveFeedback(
    agentId="11155111:123",
    score=85,
    tag1="data_analyst",
    tag2="finance",
    endpoint="https://api.example.com/feedback",
    feedbackFile=feedback_file,  # optional
) -> Feedback
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, Feedback, FeedbackFileInput } from 'agent0-sdk';

const feedback: Feedback = await sdk.giveFeedback(
  agentId,
  85,
  'data_analyst',
  'finance',
  'https://api.example.com/feedback',
  feedbackFile // optional: FeedbackFileInput
);
```

</TabItem>
</Tabs>

### getFeedback

Get single feedback.

<Tabs>
<TabItem label="Python">

```python
feedback = sdk.getFeedback(
    agentId="11155111:123",
    clientAddress="0xabc...",
    feedbackIndex=0
) -> Feedback
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, Address, Feedback } from 'agent0-sdk';

const feedback: Feedback = await sdk.getFeedback(
  agentId: AgentId,
  clientAddress: Address,
  feedbackIndex: number
);
```

</TabItem>
</Tabs>

**Note:** `feedbackIndex` in the feedback ID is 0-based (first feedback = 0, second = 1, etc.)

**Note:** Both SDKs take separate parameters instead of a single `feedbackId` string.

### searchFeedback

Search feedback with filters.

<Tabs>
<TabItem label="Python">

```python
results = sdk.searchFeedback(
    agentId="11155111:123",
    reviewers=None,
    tags=["data_analyst"],
    capabilities=["tools"],
    skills=["financial_analysis"],
    tasks=None,
    names=None,
    minScore=70,
    maxScore=100,
    include_revoked=False,
    first=100,
    skip=0,
) -> List[Feedback]
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, Address, Feedback } from 'agent0-sdk';

const results: Feedback[] = await sdk.searchFeedback(
  filters: {
    agentId: AgentId;
    tags?: string[];
    reviewers?: Address[];
    capabilities?: string[];
    skills?: string[];
    tasks?: string[];
    names?: string[];
    includeRevoked?: boolean;
  },
  options?: { minScore?: number; maxScore?: number }
);
```

</TabItem>
</Tabs>

**Parameters:**

- `agentId` (str / AgentId): Agent ID in format `"agentId"` (uses SDK’s default chain) or `"chainId:agentId"` (explicit chain)
### searchAgentsByReputation

Find agents by reputation.

<Tabs>
<TabItem label="Python">

```python
results = sdk.searchAgentsByReputation(
    agents: Optional[List[AgentId]] = None,
    tags: Optional[List[str]] = None,
    reviewers: Optional[List[Address]] = None,
    capabilities: Optional[List[str]] = None,
    skills: Optional[List[str]] = None,
    tasks: Optional[List[str]] = None,
    names: Optional[List[str]] = None,
    minAverageScore: Optional[int] = None,
    includeRevoked: bool = False,
    page_size: int = 50,
    cursor: Optional[str] = None,
    sort: Optional[List[str]] = None,
    chains: Optional[Union[List[ChainId], Literal["all"]]] = None,
) -> Dict
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, AgentSummary, Address } from 'agent0-sdk';

const results: { items: AgentSummary[]; nextCursor?: string; meta?: {...} } = await sdk.searchAgentsByReputation(
  filters?: {
    agents?: AgentId[];
    tags?: string[];
    reviewers?: Address[];
    capabilities?: string[];
    skills?: string[];
    tasks?: string[];
    names?: string[];
    minAverageScore?: number;
  },
  options?: { includeRevoked?: boolean; pageSize?: number; cursor?: string; sort?: string[]; chains?: number[] | 'all' }
);
```

</TabItem>
</Tabs>

**Parameters:**

- `chains` (optional):

- `None` / `undefined` (default) - Uses SDK’s default chain
- `[chainId1, chainId2, ...]` - List of specific chain IDs to search
- `"all"` - Searches all configured chains in parallel

### revokeFeedback

Revoke feedback.

<Tabs>
<TabItem label="Python">

```python
result = sdk.revokeFeedback(
    agentId: str,
    feedbackIndex: int
) -> Feedback
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId } from 'agent0-sdk';

const txHash: string = await sdk.revokeFeedback(
  agentId: AgentId,
  feedbackIndex: number
);
```

</TabItem>
</Tabs>

**TypeScript Note:** Returns transaction hash string, not Feedback object.

### appendResponse

Append response to feedback.

<Tabs>
<TabItem label="Python">

```python
feedback = sdk.appendResponse(
    agentId: str,
    clientAddress: str,
    feedbackIndex: int,
    response: Dict
) -> Feedback
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, Address, URI } from 'agent0-sdk';

const txHash: string = await sdk.appendResponse(
  agentId: AgentId,
  clientAddress: Address,
  feedbackIndex: number,
  response: { uri: URI; hash: string }
);
```

</TabItem>
</Tabs>

**TypeScript Note:** Returns transaction hash string, not Feedback object. Response parameter is an object with `uri` and `hash` properties.

### getReputationSummary

Get reputation summary for an agent.

<Tabs>
<TabItem label="Python">

```python
summary = sdk.getReputationSummary(
    agentId: str
) -> Dict
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId } from 'agent0-sdk';

const summary: { count: number; averageScore: number } = await sdk.getReputationSummary(
  agentId: AgentId,
  tag1?: string,
  tag2?: string
);
```

</TabItem>
</Tabs>

**Parameters:**

- `agentId` (str / AgentId): Agent ID in format `"agentId"` (uses SDK’s default chain) or `"chainId:agentId"` (explicit chain)
## Transfer Methods

### transferAgent

Transfer agent ownership to a new address.

<Tabs>
<TabItem label="Python">

```python
result = sdk.transferAgent(
    agentId: str,
    newOwnerAddress: str
) -> Dict[str, Any]
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, Address } from 'agent0-sdk';

const result: {
  txHash: string;
  from: Address;
  to: Address;
  agentId: AgentId;
} = await sdk.transferAgent(
  agentId: AgentId,
  newOwner: Address
);
```

</TabItem>
</Tabs>

**Parameters:**

- `agentId` (str / AgentId): The agent ID to transfer
- `newOwnerAddress` / `newOwner` (str / Address): Ethereum address of the new owner
**Returns:**

- Python: `Dict[str, Any]` containing:

- `txHash` (str): Transaction hash
- `from` (str): Previous owner address
- `to` (str): New owner address
- `agentId` (str): Agent ID that was transferred

- TypeScript: Object with typed fields `{ txHash: string; from: Address; to: Address; agentId: AgentId }`
**Raises/Throws:**

- Python: `ValueError`: If agent not found or transfer not allowed
- TypeScript: `Error`: If agent not found or transfer not allowed
**Example:**

<Tabs>
<TabItem label="Python">

```python
# Transfer agent using SDK method
result = sdk.transferAgent(
    agentId="11155111:123",
    newOwnerAddress="0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6"
)

print(f"Transfer successful: {result['txHash']}")
print(f"New owner: {result['to']}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Transfer agent using SDK method
const result = await sdk.transferAgent(
  "11155111:123",
  "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6"
);

console.log(`Transfer successful: ${result.txHash}`);
console.log(`New owner: ${result.to}`);
```

</TabItem>
</Tabs>

**Comparison with Agent.transfer():**

- `sdk.transferAgent()` is a convenience method that loads the agent first
- `agent.transfer()` works directly on an existing agent instance
- Both methods perform the same validation and transfer logic
- Use `sdk.transferAgent()` when you only have the agent ID
- Use `agent.transfer()` when you already have an agent instance
**Important Notes:**

- Only the current owner can transfer the agent
- Agent URI, metadata, and all other data remain unchanged
- Transfer is irreversible - ensure the new owner is correct
- Invalid addresses and self-transfers are automatically rejected
- Address validation includes checksum format verification
## Owner Utility Methods

### getAgentOwner

Get the current owner of an agent.

<Tabs>
<TabItem label="Python">

```python
owner = sdk.getAgentOwner(agentId: str) -> str
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, Address } from 'agent0-sdk';

const owner: Address = await sdk.getAgentOwner(agentId: AgentId);
```

</TabItem>
</Tabs>

**Parameters:**

- `agentId` (str / AgentId): The agent ID to check
**Returns:**

- Python: `str` - The current owner’s Ethereum address
- TypeScript: `Address` - The current owner’s Ethereum address
**Raises/Throws:**

- Python: `ValueError`: If agent ID is invalid or agent doesn’t exist
- TypeScript: `Error`: If agent ID is invalid or agent doesn’t exist
**Example:**

<Tabs>
<TabItem label="Python">

```python
owner = sdk.getAgentOwner("11155111:123")
print(f"Current owner: {owner}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
const owner = await sdk.getAgentOwner("11155111:123");
console.log(`Current owner: ${owner}`);
```

</TabItem>
</Tabs>

### isAgentOwner

Check if an address is the owner of an agent.

<Tabs>
<TabItem label="Python">

```python
is_owner = sdk.isAgentOwner(
    agentId: str,
    address: Optional[str] = None
) -> bool
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { AgentId, Address } from 'agent0-sdk';

const isOwner: boolean = await sdk.isAgentOwner(
  agentId: AgentId,
  address: Address
);
```

</TabItem>
</Tabs>

**Parameters:**

- `agentId` (str / AgentId): The agent ID to check
- `address` (str / Address, optional in Python, required in TypeScript): Address to check (Python defaults to SDK’s signer address)
**Returns:**

- `bool`: True if the address is the owner, False otherwise
**Raises/Throws:**

- Python: `ValueError`: If agent ID is invalid or agent doesn’t exist
- TypeScript: `Error`: If agent ID is invalid or agent doesn’t exist
**Example:**

<Tabs>
<TabItem label="Python">

```python
# Check if current signer is owner
is_owner = sdk.isAgentOwner("11155111:123")

# Check if specific address is owner
is_owner = sdk.isAgentOwner("11155111:123", "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Check if specific address is owner (address is required in TypeScript)
const isOwner = await sdk.isAgentOwner(
  "11155111:123",
  "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6"
);
```

</TabItem>
</Tabs>

### canTransferAgent

Check if an address can transfer an agent (i.e., is the owner).

<Tabs>
<TabItem label="Python">

```python
can_transfer = sdk.canTransferAgent(
    agentId: str,
    address: Optional[str] = None
) -> bool
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Note: This method is not available in TypeScript SDK
// Use isAgentOwner instead, which serves the same purpose
const canTransfer = await sdk.isAgentOwner(agentId, address);
```

</TabItem>
</Tabs>

**TypeScript Note:** This method is not available in the TypeScript SDK. Use `isAgentOwner()` instead, which serves the same purpose.

**Parameters:**

- `agentId` (str): The agent ID to check
- `address` (str, optional): Address to check (defaults to SDK’s signer address)
**Returns:**

- `bool`: True if the address can transfer the agent, False otherwise
**Example:**

<Tabs>
<TabItem label="Python">

```python
# Check if current signer can transfer
can_transfer = sdk.canTransferAgent("11155111:123")

# Check if specific address can transfer
can_transfer = sdk.canTransferAgent("11155111:123", "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Use isAgentOwner as equivalent
const canTransfer = await sdk.isAgentOwner(
  "11155111:123",
  "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6"
);
```

</TabItem>
</Tabs>

## Utility Methods

### chain_id / chainId

Get current chain ID.

<Tabs>
<TabItem label="Python">

```python
chain_id = sdk.chain_id() -> int
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { ChainId } from 'agent0-sdk';

const chainId: ChainId = await sdk.chainId();
```

</TabItem>
</Tabs>

**TypeScript Note:** Method is async and uses camelCase naming.

### registries

Get registry addresses.

<Tabs>
<TabItem label="Python">

```python
registries = sdk.registries() -> Dict[str, str]
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';
import type { Address } from 'agent0-sdk';

const registries: Record = sdk.registries();
```

</TabItem>
</Tabs>

### set_chain

Switch to a different chain.

<Tabs>
<TabItem label="Python">

```python
sdk.set_chain(chain_id: int) -> None
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Note: This method is not available in TypeScript SDK
// Create a new SDK instance with the desired chainId instead
const sdk = new SDK({
  chainId: newChainId,
  rpcUrl: newRpcUrl,
  // ... other config
});
```

</TabItem>
</Tabs>

**TypeScript Note:** This method is not available in the TypeScript SDK. Create a new SDK instance with the desired `chainId` instead.

### isReadOnly

Check if SDK is in read-only mode.

<Tabs>
<TabItem label="Python">

```python
is_readonly = sdk.isReadOnly -> bool
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';

const isReadOnly: boolean = sdk.isReadOnly;
```

</TabItem>
</Tabs>

**TypeScript Note:** Property access (not a method), uses camelCase naming.

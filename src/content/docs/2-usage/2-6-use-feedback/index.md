---
title: "Feedback"
description: "Give and manage feedback"
---
Complete guide to giving feedback, managing reputation, and using feedback data to evaluate agents.

## Feedback ID Format

Feedback IDs follow the format `"agentId:clientAddress:feedbackIndex"`:

- **agentId**: The agent’s ID in `"chainId:agentId"` format (e.g., `"11155111:123"`) or just `"agentId"` (uses SDK’s default chain)
- **clientAddress**: Ethereum address of the feedback giver (normalized to lowercase)
- **feedbackIndex**: Sequential index of feedback from this client to this agent (0-based)
- **Example**: `"11155111:123:0x742d35cc6634c0532925a3b844bc9e7595f0beb7:0"` = First feedback from client `0x742d...` to agent `11155111:123`
See [Models Reference](/5-reference/5-3-models/) for detailed ID format documentation.

## Give Feedback

Submit feedback on-chain. **Only `agentId` and `score` are required.**

Optionally, you can also include **additional on-chain fields** (`tag1`, `tag2`, `endpoint`).

Separately, if you want richer context (text/capability/skill/task/etc), you can **optionally** attach an **off-chain** `feedbackFile` payload (see the next section).

### Feedback Parameters

**Mandatory on-chain fields:**

- `agentId` - The agent’s ID
- `score` - Rating from 0-100

**Optional on-chain fields:**

- `tag1`, `tag2` - Optional on-chain tags (free-form strings)
- `endpoint` - Optional on-chain endpoint URI related to the feedback

**Optional off-chain field:**

- `feedbackFile` - Optional off-chain feedback file payload (create with `prepareFeedbackFile(...)`)

Common `feedbackFile` fields:

- `text` - Optional free-form text
- `capability` - MCP capability type (“tools”, “prompts”, “resources”)
- `name` - MCP tool/resource/prompt name
- `skill` - A2A skill identifier
- `task` - A2A task identifier
- `context` - Dictionary with additional context information
- `proofOfPayment` - Payment proof data for x402 payments

<Tabs>
<TabItem label="Python">

```python
# Minimal on-chain feedback (no file). Only agentId + score are required.
feedback2 = sdk.giveFeedback(
    agentId="11155111:123",
    score=85,
    tag1="data_analyst",  # optional on-chain
    tag2="finance",       # optional on-chain
    endpoint="https://api.example.com/feedback",  # optional on-chain
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Minimal on-chain feedback (no file). Only agentId + score are required.
const feedback2 = await sdk.giveFeedback(
  '11155111:123',
  85,
  'data_analyst', // tag1 (optional on-chain)
  'finance', // tag2 (optional on-chain)
  'https://api.example.com/feedback' // endpoint (optional on-chain)
);
```

</TabItem>
</Tabs>

## Optional: Prepare a Feedback File (Rich Off-chain Fields)

Use `prepareFeedbackFile()` to build an **optional off-chain** feedback payload when you need rich fields (text/context/capability/etc).
On-chain fields like `score`, `tag1`, `tag2`, and `endpoint` are still passed directly to `giveFeedback(...)`.

<Tabs>
<TabItem label="Python">

```python
feedback_file = sdk.prepareFeedbackFile({
    "text": "Great agent, very helpful.",
    "capability": "tools",
    "name": "financial_analyzer",
    "skill": "financial_analysis",
    "task": "analyze_balance_sheet",
    "context": {"sessionId": "abc"},
})

# Submit feedback (on-chain fields + optional feedbackFile)
feedback = sdk.giveFeedback(
    agentId="11155111:123",
    score=85,
    tag1="data_analyst",
    tag2="finance",
    endpoint="https://api.example.com/feedback",
    feedbackFile=feedback_file,  # optional
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
const feedbackFile = sdk.prepareFeedbackFile({
  text: 'Great agent, very helpful.',
  capability: 'tools',
  name: 'financial_analyzer',
  skill: 'financial_analysis',
  task: 'analyze_balance_sheet',
  context: { sessionId: 'abc' },
});

// Submit feedback (on-chain fields + optional feedbackFile)
const feedback = await sdk.giveFeedback(
  '11155111:123',
  85,
  'data_analyst',
  'finance',
  'https://api.example.com/feedback',
  feedbackFile
);
```

</TabItem>
</Tabs>

## Read Feedback

### Get Single Feedback

<Tabs>
<TabItem label="Python">

```python
# Read feedback by components (feedbackIndex is 0-based)
feedback = sdk.getFeedback("11155111:123", "0xClient", 0)
print(f"Score: {feedback.score}")
print(f"Tags: {feedback.tags}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Read feedback by ID
// Note: In TypeScript, getFeedback requires separate params
const feedback = await sdk.getFeedback(
  '11155111:123',
  '0xClient', // clientAddress
  0 // feedbackIndex
);
console.log(`Score: ${feedback.score}`);
console.log(`Tags: ${feedback.tags}`);
```

</TabItem>
</Tabs>

### Search Feedback

<Tabs>
<TabItem label="Python">

```python
# Search feedback with filters
# Using default chain
results = sdk.searchFeedback(
    agentId="123",  # Uses SDK's default chain
    capabilities=["tools"],
    skills=["python"],
    tags=["data_analyst"],
    minScore=80,
    maxScore=100
)

for fb in results:
    print(f"{fb.score}/100: {fb.tags}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Search feedback with filters (async in TypeScript)
// Using default chain
const results = await sdk.searchFeedback(
  {
    agentId: '123', // Uses SDK's default chain
    tags: ['data_analyst'],
    capabilities: ['tools'],
    skills: ['python'],
  },
  { minScore: 80, maxScore: 100 }
);

for (const fb of results) {
  console.log(`${fb.score}/100: ${fb.tags.join(', ')}`);
}
```

</TabItem>
</Tabs>

## Reputation Summary

<Tabs>
<TabItem label="Python">

```python
# Get aggregated reputation
# Using default chain
summary = sdk.getReputationSummary("123")  # Uses SDK's default chain

# Explicitly specify chain
summary = sdk.getReputationSummary("11155111:123")  # ETH Sepolia

print(f"Average score: {summary['averageScore']}")
print(f"Total feedback: {summary['totalFeedback']}")
print(f"Score distribution: {summary['scoreDistribution']}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Get aggregated reputation (async in TypeScript)
// Note: TypeScript version returns count and averageScore only
// Using default chain
const summary = await sdk.getReputationSummary('123');  // Uses SDK's default chain

// Explicitly specify chain
const summary = await sdk.getReputationSummary('11155111:123');  // ETH Sepolia

console.log(`Average score: ${summary.averageScore}`);
console.log(`Total feedback: ${summary.count}`);
// Note: scoreDistribution is not available in TypeScript SDK
```

</TabItem>
</Tabs>

## Agent Reputation Search

Find agents by reputation:

<Tabs>
<TabItem label="Python">

```python
# Find highly-rated agents
# Single chain (uses SDK's default chain)
results = sdk.searchAgentsByReputation(
    minAverageScore=80,
    tags=["enterprise"],
    capabilities=["code_generation"]
)

# Single specific chain
results = sdk.searchAgentsByReputation(
    minAverageScore=80,
    tags=["enterprise"],
    capabilities=["code_generation"],
    chains=[11155111]  # ETH Sepolia
)

# Multiple chains
results = sdk.searchAgentsByReputation(
    minAverageScore=80,
    tags=["enterprise"],
    capabilities=["code_generation"],
    chains=[11155111]
)

# All supported chains
results = sdk.searchAgentsByReputation(
    minAverageScore=80,
    tags=["enterprise"],
    capabilities=["code_generation"],
    chains="all"  # Searches all configured chains
)

for agent in results['items']:
    print(f"{agent.name}: {agent.extras['averageScore']}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Find highly-rated agents (async in TypeScript)
// Single chain (uses SDK's default chain)
const singleChainResults = await sdk.searchAgentsByReputation(
  {
    minAverageScore: 80,
    tags: ['enterprise'],
    capabilities: ['code_generation'],
  },
  { pageSize: 20 }
);

// Single specific chain
const sepoliaResults = await sdk.searchAgentsByReputation(
  {
    minAverageScore: 80,
    tags: ['enterprise'],
    capabilities: ['code_generation'],
  },
  { chains: [11155111], pageSize: 20 } // ETH Sepolia
);

// Multiple chains
const multiChainResults = await sdk.searchAgentsByReputation(
  {
    minAverageScore: 80,
    tags: ['enterprise'],
    capabilities: ['code_generation'],
  },
  { chains: [11155111], pageSize: 20 }
);

// All supported chains
const allChainsResults = await sdk.searchAgentsByReputation(
  {
    minAverageScore: 80,
    tags: ['enterprise'],
    capabilities: ['code_generation'],
  },
  { chains: 'all', pageSize: 20 } // Searches all configured chains
);

for (const agent of singleChainResults.items) {
  console.log(`${agent.name}: ${agent.extras.averageScore}`);
}
```

</TabItem>
</Tabs>

## Manage Feedback

### Append Response

<Tabs>
<TabItem label="Python">

```python
# Agent responds to feedback with refund acknowledgment
updated_feedback = sdk.appendResponse(
    agentId="11155111:123",
    clientAddress=client_address,
    feedbackIndex=0,
    response={
        "message": "We apologize for the poor service. A full refund has been processed.",
        "refundTxHash": "0x1234567890abcdef...",
        "refundAmount": "0.1 ETH",
        "timestamp": int(time.time())
    }
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Agent responds to feedback with refund acknowledgment (async in TypeScript)
// Note: In TypeScript, response is provided as uri and hash separately
const responseUri = 'ipfs://QmExampleResponse'; // IPFS URI of response file
const responseHash = '0x' + '00'.repeat(32); // Hash of response content

const txHash = await sdk.appendResponse(
  '11155111:123',
  clientAddress,
  0, // feedbackIndex
  {
    uri: responseUri,
    hash: responseHash,
  }
);
console.log(`Response appended. Transaction: ${txHash}`);
```

</TabItem>
</Tabs>

### Revoke Feedback

<Tabs>
<TabItem label="Python">

```python
# Revoke feedback
sdk.revokeFeedback(
    agentId="11155111:123",
    clientAddress=client_address,
    feedbackIndex=0
)
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Revoke feedback (async in TypeScript)
// Note: clientAddress is automatically determined from the signer
const txHash = await sdk.revokeFeedback(
  '11155111:123',
  0 // feedbackIndex
);
console.log(`Feedback revoked. Transaction: ${txHash}`);
```

</TabItem>
</Tabs>

## Feedback Data Structure

```python
@dataclass
class Feedback:
    id: str                        # Unique feedback ID
    agentId: str                   # Agent identifier
    reviewer: str                  # Client address
    score: float                   # 0-100 rating (MANDATORY)
    tags: Optional[List[str]]      # Categorization tags (optional)
    capability: Optional[str]      # MCP capability type (optional)
    name: Optional[str]            # MCP tool/resource/prompt name (optional)
    skill: Optional[str]           # A2A skill (optional)
    task: Optional[str]           # A2A task (optional)
    context: Optional[dict]       # Additional context (optional)
    fileURI: Optional[str]         # IPFS/HTTPS URI (if feedback file exists)
    createdAt: int                 # Timestamp
    answers: List[dict]            # Responses
    isRevoked: bool                # Revocation status
```

**Note:** Only `score` is mandatory when creating feedback. All other fields are optional and can be omitted for minimal on-chain-only feedback.

## Next Steps

- Explore [Examples](/3-examples/3-1-quick-start/)
- Learn about [Subgraph](/4-subgraph/4-1-intro/)

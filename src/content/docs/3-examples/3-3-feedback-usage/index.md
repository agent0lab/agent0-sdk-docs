---
title: "Feedback Usage"
description: "Complete feedback workflow"
---
Full example of giving feedback and managing reputation.

<Tabs>
<TabItem label="Python">

```python
from agent0_sdk import SDK
import os

# Initialize SDKs
agent_sdk = SDK(
    chainId=11155111,
    rpcUrl=os.getenv("RPC_URL"),
    signer=os.getenv("AGENT_PRIVATE_KEY"),
    ipfs="pinata",
    pinataJwt=os.getenv("PINATA_JWT"),
)

client_sdk = SDK(
    chainId=11155111,
    rpcUrl=os.getenv("RPC_URL"),
    signer=os.getenv("CLIENT_PRIVATE_KEY"),
    ipfs="pinata",
    pinataJwt=os.getenv("PINATA_JWT"),
)

agent_id = "11155111:123"

# Client prepares an OPTIONAL off-chain feedback file (for rich fields)
feedback_file = client_sdk.prepareFeedbackFile(
    {
        "text": "Great agent, very helpful.",
        "capability": "tools",
        "name": "financial_analyzer",
        "skill": "financial_analysis",
        "context": {"sessionId": "abc"},
    }
)

# Client submits feedback on-chain (and uploads feedback file if provided)
feedback = client_sdk.giveFeedback(
    agentId=agent_id,
    score=90,
    tag1="data_analyst",
    tag2="finance",
    endpoint="https://api.example.com/feedback",
    feedbackFile=feedback_file,  # optional
)

print(f"✅ Feedback submitted: {feedback.id}")  # (agentId, clientAddress, feedbackIndex)

# Read single feedback (separate params; feedbackIndex is 0-based)
agentId, clientAddress, feedbackIndex = feedback.id
retrieved = agent_sdk.getFeedback(agentId, clientAddress, feedbackIndex)
print(f"Score: {retrieved.score}")
print(f"Tags: {retrieved.tags}")

# Search feedback
all_feedback = agent_sdk.searchFeedback(
    agentId=agent_id,
    tags=["data_analyst"],
    minScore=80,
)
print(f"Found {len(all_feedback)} positive feedback entries")

# Append a response (agent acknowledges the feedback)
agent_sdk.appendResponse(
    agentId=agentId,
    clientAddress=clientAddress,
    feedbackIndex=feedbackIndex,
    response={"text": "Thanks for the feedback!", "timestamp": 0},
)

# Get reputation
summary = agent_sdk.getReputationSummary(agent_id)
print(f"Average: {summary['averageScore']}")
```

</TabItem>
<TabItem label="TypeScript">

```ts
import { SDK } from 'agent0-sdk';

async function main() {
  // Initialize SDKs
  const agentSdk = new SDK({
    chainId: 11155111,
    rpcUrl: process.env.RPC_URL || '',
    signer: process.env.AGENT_PRIVATE_KEY,
    ipfs: 'pinata',
    pinataJwt: process.env.PINATA_JWT,
  });

  const clientSdk = new SDK({
    chainId: 11155111,
    rpcUrl: process.env.RPC_URL || '',
    signer: process.env.CLIENT_PRIVATE_KEY,
    ipfs: 'pinata',
    pinataJwt: process.env.PINATA_JWT,
  });

  const agentId = '11155111:123';

  // Client prepares an OFF-CHAIN feedback file (optional).
  // This does NOT include on-chain fields like score/tag1/tag2/endpoint.
  const feedbackFile = clientSdk.prepareFeedbackFile({
    text: undefined,
    capability: 'tools',
    name: 'financial_analyzer',
    skill: 'financial_analysis',
    task: 'analyze_balance_sheet',
    context: { userId: 'user123', sessionId: 'session456' },
    proofOfPayment: { txHash: '0x...', amount: '0.01' },
  });

  // Submit feedback (async in TypeScript)
  const feedback = await clientSdk.giveFeedback(
    agentId,
    90, // score
    'data_analyst',
    'finance',
    'https://api.example.com/feedback',
    feedbackFile
  );

  console.log(`✅ Feedback submitted: ${feedback.id.join(':')}`);

  // Read single feedback (async in TypeScript)
  // Note: getFeedback requires separate params in TypeScript
  const [feedbackAgentId, clientAddress, feedbackIndex] = feedback.id;
  const retrieved = await agentSdk.getFeedback(
    feedbackAgentId,
    clientAddress,
    feedbackIndex
  );
  console.log(`Score: ${retrieved.score}`);
  console.log(`Tags: ${retrieved.tags}`);

  // Search feedback (async in TypeScript)
  const allFeedback = await agentSdk.searchFeedback(
    {
    agentId,
      tags: ['data_analyst'],
      capabilities: ['tools'],
      skills: ['financial_analysis'],
    },
    { minScore: 80 }
  );
  console.log(`Found ${allFeedback.length} positive feedbacks`);

  // Get reputation (async in TypeScript)
  const summary = await agentSdk.getReputationSummary(agentId);
  console.log(`Average: ${summary.averageScore}`);
}

main().catch(console.error);
```

</TabItem>
</Tabs>

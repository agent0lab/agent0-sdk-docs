---
title: "Data Structures"
description: "Subgraph schema and entities"
---
All data structures in the Agent0 subgraph.

## Core Entities

### Agent

Core agent information:

```graphql
type Agent {
  id: ID!                    # "chainId:agentId"
  chainId: BigInt!
  agentId: BigInt!
  agentURI: String
  agentURIType: String
  owner: Bytes!
  operators: [Bytes!]!
  createdAt: BigInt!
  updatedAt: BigInt!
  registrationFile: AgentRegistrationFile
  feedback: [Feedback!]!
  validations: [Validation!]!
  metadata: [AgentMetadata!]!
  totalFeedback: BigInt!
  lastActivity: BigInt!
}
```

### Feedback

Feedback and reputation data:

```graphql
type Feedback {
  id: ID!                    # "chainId:agentId:clientAddress:feedbackIndex"
  agent: Agent!
  clientAddress: Bytes!
  value: BigDecimal!
  tag1: String
  tag2: String
  feedbackUri: String
  feedbackURIType: String
  feedbackHash: Bytes
  isRevoked: Boolean!
  createdAt: BigInt!
  revokedAt: BigInt
  feedbackFile: FeedbackFile
  responses: [FeedbackResponse!]!
}
```

### Validation

Validator attestations:

```graphql
type Validation {
  id: ID!                    # requestHash
  agent: Agent!
  validatorAddress: Bytes!
  requestUri: String
  requestHash: Bytes!
  response: Int              # 0-100, 0 means pending
  responseUri: String
  responseHash: Bytes
  tag: String
  status: ValidationStatus!
  createdAt: BigInt!
  updatedAt: BigInt!
}

enum ValidationStatus {
  PENDING
  COMPLETED
  EXPIRED
}
```

## File Entities (IPFS)

### AgentRegistrationFile

IPFS registration file data:

```graphql
type AgentRegistrationFile {
  id: ID!                    # Format: "transactionHash:cid"
  cid: String!               # IPFS CID (for querying by content)
  agentId: String!
  name: String
  description: String
  image: String
  active: Boolean
  x402Support: Boolean
  supportedTrusts: [String!]!
  mcpEndpoint: String
  mcpVersion: String
  a2aEndpoint: String
  a2aVersion: String
  ens: String
  did: String
  mcpTools: [String!]!
  mcpPrompts: [String!]!
  mcpResources: [String!]!
  a2aSkills: [String!]!
  createdAt: BigInt!
}
```

### FeedbackFile

IPFS feedback file data:

```graphql
type FeedbackFile {
  id: ID!                    # Format: "transactionHash:cid"
  cid: String!               # IPFS CID (for querying by content)
  feedbackId: String!
  agentRegistry: String
  agentId: BigInt
  clientAddress: String
  createdAtIso: String
  valueRaw: BigInt
  valueDecimals: Int
  text: String
  mcpTool: String
  mcpPrompt: String
  mcpResource: String
  a2aSkills: [String!]!
  a2aContextId: String
  a2aTaskId: String
  oasfSkills: [String!]!
  oasfDomains: [String!]!
  proofOfPaymentFromAddress: String
  proofOfPaymentToAddress: String
  proofOfPaymentChainId: String
  proofOfPaymentTxHash: String
  tag1: String
  tag2: String
  createdAt: BigInt!
}
```

## Metadata Entity

### AgentMetadata

On-chain metadata storage:

```graphql
type AgentMetadata {
  id: ID!                    # "agentId:key"
  agent: Agent!
  key: String!
  value: Bytes!
  updatedAt: BigInt!
}
```

## Statistics Entities

### AgentStats

Per-agent analytics:

```graphql
type AgentStats {
  id: ID!                    # "chainId:agentId"
  agent: Agent!
  totalFeedback: BigInt!
  averageValue: BigDecimal!
  totalValidations: BigInt!
  completedValidations: BigInt!
  averageValidationScore: BigDecimal!
  lastActivity: BigInt!
  updatedAt: BigInt!
}
```

### GlobalStats

Cross-chain statistics:

```graphql
type GlobalStats {
  id: ID!                    # "global"
  totalAgents: BigInt!
  totalFeedback: BigInt!
  totalValidations: BigInt!
  totalProtocols: BigInt!
  agents: [Agent!]!
  tags: [String!]!
  updatedAt: BigInt!
}
```

## Protocol Entity

### Protocol

Chain-specific protocol configuration:

```graphql
type Protocol {
  id: ID!                    # "chainId"
  chainId: BigInt!
  name: String!
  identityRegistry: Bytes!
  reputationRegistry: Bytes!
  validationRegistry: Bytes!
  totalAgents: BigInt!
  totalFeedback: BigInt!
  totalValidations: BigInt!
  agents: [Agent!]!
  tags: [String!]!
  updatedAt: BigInt!
}
```

## Next Steps

- Explore [Example Queries](/4-subgraph/4-3-example-queries/)

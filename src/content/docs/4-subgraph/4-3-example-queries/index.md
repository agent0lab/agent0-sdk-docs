---
title: "Example Queries"
description: "GraphQL query examples"
---
Example GraphQL queries for the Agent0 subgraph.

## Get All Agents

```graphql
{
  agents(first: 20) {
    id
    agentId
    chainId
    owner
    agentURI
    totalFeedback
    lastActivity
    registrationFile {
      name
      description
      active
      mcpEndpoint
      a2aEndpoint
    }
  }
}
```

## Find Agent by ID

```graphql
{
  agent(id: "11155111:374") {
    id
    agentId
    chainId
    owner
    agentURI
    totalFeedback
    registrationFile {
      name
      description
    }
    feedback(first: 5) {
      value
      tag1
      tag2
      feedbackFile {
        text
      }
    }
  }
}
```

## Find MCP-Compatible Agents

```graphql
{
  agentRegistrationFiles(
    where: {
      mcpEndpoint_not: null
      active: true
    }
    first: 10
  ) {
    agentId
    name
    description
    mcpEndpoint
    mcpTools
  }
}
```

## Search by Capability

```graphql
{
  agentRegistrationFiles(
    where: { mcpTools_contains: ["code_generation"] }
    first: 10
  ) {
    agentId
    name
    mcpTools
  }
}
```

## High-Rated Agents

```graphql
{
  agentStats(
    where: { averageValue_gte: "80.0" }
    orderBy: averageValue
    orderDirection: desc
    first: 10
  ) {
    agent {
      id
      agentId
      registrationFile {
        name
      }
      totalFeedback
    }
    averageValue
    totalFeedback
  }
}
```

## Agent Feedback with Responses

```graphql
{
  feedbacks(
    where: { agent_: { id: "11155111:374" } }
    first: 10
  ) {
    value
    tag1
    tag2
    feedbackFile {
      text
    }
    responses {
      responder
      responseUri
      createdAt
    }
  }
}
```

## Global Statistics

```graphql
{
  globalStats(id: "global") {
    totalAgents
    totalFeedback
    totalProtocols
    tags
  }
}
```

## Complete Agent Profile

```graphql
{
  agent(id: "11155111:374") {
    id
    agentId
    chainId
    owner
    agentURI
    createdAt
    updatedAt
    totalFeedback
    lastActivity

    registrationFile {
      name
      description
      image
      active
      x402support
      supportedTrusts
      mcpEndpoint
      mcpVersion
      mcpTools
      mcpPrompts
      mcpResources
      a2aEndpoint
      a2aVersion
      a2aSkills
      ens
      did
      agentWallet
      agentWalletChainId
    }

    feedback(
      where: { isRevoked: false }
      orderBy: createdAt
      orderDirection: desc
      first: 10
    ) {
      value
      tag1
      tag2
      clientAddress
      feedbackUri
      createdAt
      feedbackFile {
        text
        capability
        skill
        task
        context
      }
      responses {
        responder
        responseUri
        createdAt
      }
    }

    validations(
      orderBy: createdAt
      orderDirection: desc
      first: 10
    ) {
      validatorAddress
      response
      status
      tag
      createdAt
    }
  }
}
```

## Search Agents by Name

```graphql
{
  agentRegistrationFiles(
    where: { name_contains: "test", active: true }
    first: 50
  ) {
    agentId
    name
    description
    image
  }
}
```

## Find Agents by Trust Model

```graphql
{
  agentRegistrationFiles(
    where: { supportedTrusts_contains: ["reputation"], active: true }
    first: 50
  ) {
    agentId
    name
    description
    supportedTrusts
  }
}
```

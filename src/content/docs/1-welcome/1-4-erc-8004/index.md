---
title: "ERC-8004"
description: "Agent Identity Standard for Ethereum"
---
ERC-8004 is the Agent Identity Standard for Ethereum that enables discovering, choosing, and interacting with agents across organizational boundaries without pre-existing trust.

## What is ERC-8004?

ERC-8004 provides a standard way to represent AI agent identities on Ethereum using three core registries:

- **Identity Registry** - ERC-721 NFTs for unique agent identities
- **Reputation Registry** - Feedback and reputation tracking
- **Validation Registry** - Third-party validator attestations
This enables permissionless agent discovery, censorship-resistant identity, and interoperable trust signals across platforms.

## Specification

📖 **[Read the full ERC-8004 specification](https://eips.ethereum.org/EIPS/eip-8004)**

## Contracts

The official ERC-8004 contracts are maintained by the 8004 team:

🔗 **[ERC-8004 Contracts Repository](https://github.com/erc-8004/erc-8004-contracts)**

### Testnet Contract Addresses

#### ETH Sepolia

- **IdentityRegistry**: `0x8004A818BFB912233c491871b3d84c89A494BD9e`
- **ReputationRegistry**: `0x8004B663056A597Dffe9eCcC1965A193B7388713`
- **ValidationRegistry**: not deployed in SDK defaults yet

Other networks may be available in the ERC-8004 ecosystem, but are not enabled in Agent0 SDK defaults yet.
## Contract Functions

### Identity Registry

**Registration Functions:**

- `register() → uint256 agentId`
- `register(string agentURI) → uint256 agentId`
- `register(string agentURI, MetadataEntry[] metadata) → uint256 agentId`

**Management Functions:**

- `setAgentURI(uint256 agentId, string newURI)`
- `setMetadata(uint256 agentId, string metadataKey, bytes metadataValue)`
- `getMetadata(uint256 agentId, string metadataKey) → bytes`

**Reserved Metadata Key:**

- `agentWallet` is reserved and cannot be set via `setMetadata()` nor during `register()`.
- It is updated via signature verification:
  - `setAgentWallet(uint256 agentId, address newWallet, uint256 deadline, bytes signature)`

**ERC-721 Functions:**

- `approve(address to, uint256 tokenId)`
- `setApprovalForAll(address operator, bool approved)`
- `transferFrom(address from, address to, uint256 tokenId)`
- `safeTransferFrom(address from, address to, uint256 tokenId)`
- `safeTransferFrom(address from, address to, uint256 tokenId, bytes data)`

**View Functions:**

- `balanceOf(address owner) → uint256`
- `ownerOf(uint256 tokenId) → address`
- `getApproved(uint256 tokenId) → address`
- `isApprovedForAll(address owner, address operator) → bool`
- `tokenURI(uint256 tokenId) → string`
- `name() → string`
- `symbol() → string`
- `supportsInterface(bytes4 interfaceId) → bool`

**Admin Functions:**

- `owner() → address`
- `transferOwnership(address newOwner)`
- `renounceOwnership()`
- `upgradeToAndCall(address newImplementation, bytes data)`
### Reputation Registry

**Feedback Functions:**

- `giveFeedback(uint256 agentId, uint8 score, string tag1, string tag2, string endpoint, string feedbackURI, bytes32 feedbackHash)`
- `revokeFeedback(uint256 agentId, uint64 feedbackIndex)`
- `appendResponse(uint256 agentId, address clientAddress, uint64 feedbackIndex, string responseURI, bytes32 responseHash)`

**Query Functions:**

- `readFeedback(uint256 agentId, address clientAddress, uint64 feedbackIndex) → (uint8 score, string tag1, string tag2, bool isRevoked)`
- `readAllFeedback(uint256 agentId, address[] clientAddresses, string tag1, string tag2, bool includeRevoked) → (address[] clientAddresses, uint64[] feedbackIndexes, uint8[] scores, string[] tag1s, string[] tag2s, bool[] revokedStatuses)`
- `getSummary(uint256 agentId, address[] clientAddresses, string tag1, string tag2) → (uint64 count, uint8 averageScore)`
- `getClients(uint256 agentId) → address[]`
- `getLastIndex(uint256 agentId, address clientAddress) → uint64`
- `getResponseCount(uint256 agentId, address clientAddress, uint64 feedbackIndex, address[] responders) → uint64 count`

**Admin Functions:**

- `getIdentityRegistry → address`
- `owner() → address`
- `transferOwnership(address newOwner)`
- `renounceOwnership()`
- `upgradeToAndCall(address newImplementation, bytes data)`
### Validation Registry

**Validation Functions:**

- `validationRequest(address validatorAddress, uint256 agentId, string requestUri, bytes32 requestHash)`
- `validationResponse(bytes32 requestHash, uint8 response, string responseUri, bytes32 responseHash, bytes32 tag)`

**Query Functions:**

- `getValidationStatus(bytes32 requestHash) → (address validatorAddress, uint256 agentId, uint8 response, bytes32 responseHash, bytes32 tag, uint256 lastUpdate)`
- `getSummary(uint256 agentId, address[] validatorAddresses, bytes32 tag) → (uint64 count, uint8 avgResponse)`
- `getAgentValidations(uint256 agentId) → bytes32[]`
- `getValidatorRequests(address validatorAddress) → bytes32[]`
- `validations(bytes32) → (address validatorAddress, uint256 agentId, uint8 response, bytes32 responseHash, bytes32 tag, uint256 lastUpdate)`

**Admin Functions:**

- `getIdentityRegistry → address`
- `owner() → address`
- `transferOwnership(address newOwner)`
- `renounceOwnership()`
- `upgradeToAndCall(address newImplementation, bytes data)`
## File Examples

### Registration File

```json
{
  "type": "https://eips.ethereum.org/EIPS/eip-8004#registration-v1",
  "name": "myAgentName",
  "description": "A natural language description of the Agent, which MAY include what it does, how it works, pricing, and interaction methods",
  "image": "https://example.com/agentimage.png",
  "endpoints": [
    {
      "name": "web",
      "endpoint": "https://web.agentxyz.com/"
    },
    {
      "name": "A2A",
      "endpoint": "https://agent.example/.well-known/agent-card.json",
      "version": "0.3.0"
    },
    {
      "name": "MCP",
      "endpoint": "https://mcp.agent.eth/",
      "capabilities": [],
      "version": "2025-06-18"
    },
    {
      "name": "OASF",
      "endpoint": "ipfs://{cid}",
      "version": "0.8",
      "skills": [],
      "domains": []
    },
    {
      "name": "ENS",
      "endpoint": "vitalik.eth",
      "version": "v1"
    },
    {
      "name": "DID",
      "endpoint": "did:method:foobar",
      "version": "v1"
    },
    {
      "name": "email",
      "endpoint": "mail@myagent.com"
    }
  ],
  "x402Support": false,
  "active": true,
  "registrations": [
    {
      "agentId": 22,
      "agentRegistry": "{namespace}:{chainId}:{identityRegistry}"
    }
  ],
  "supportedTrust": [
    "reputation",
    "crypto-economic",
    "tee-attestation"
  ]
}
```

### Endpoint Domain Verification (Optional)

An agent MAY optionally prove control of an HTTPS endpoint-domain by publishing:

- `https://{endpoint-domain}/.well-known/agent-registration.json`

Verifiers MAY treat the endpoint-domain as verified if the file is reachable over HTTPS and includes
a `registrations` entry whose `agentRegistry` and `agentId` match the on-chain agent.

### Feedback File

```json
{
  "agentRegistry": "eip155:1:{identityRegistry}",
  "agentId": 22,
  "clientAddress": "eip155:1:{clientAddress}",
  "createdAt": "2025-09-23T12:00:00Z",
  "score": 100,
  "tag1": "foo",
  "tag2": "bar",
  "endpoint": "https://.../",
  "skill": "as-defined-by-A2A-or-OASF",
  "domain": "as-defined-by-OASF",
  "context": "as-defined-by-A2A",
  "task": "as-defined-by-A2A",
  "capability": "tools",
  "name": "foo",
  "proofOfPayment": {
    "fromAddress": "0x00...",
    "toAddress": "0x00...",
    "chainId": "1",
    "txHash": "0x00..."
  }
}
```

## Next Steps

- Learn about [Agent Configuration](/2-usage/2-2-configure-agents/)
- Explore [Usage Examples](/3-examples/3-1-quick-start/)

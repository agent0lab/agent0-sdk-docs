---
title: "Models and Types"
description: "Data models reference"
---
Core data models and types used throughout the SDK.

## Type Aliases

<Tabs>
<TabItem label="Python">

```python
AgentId = str      # Format: "chainId:tokenId" (e.g., "11155111:123")
ChainId = int      # Chain identifier
Address = str       # Ethereum address (0x-hex)
URI = str          # https://... or ipfs://...
CID = str          # IPFS CID
Timestamp = int    # Unix timestamp
IdemKey = str      # Idempotency key
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Type aliases from 'agent0-sdk'
export type AgentId = string;  // Format: "chainId:tokenId" (e.g., "11155111:123")
export type ChainId = number;  // Chain identifier
export type Address = string;  // Ethereum address (0x-hex)
export type URI = string;      // https://... or ipfs://...
export type CID = string;     // IPFS CID
export type Timestamp = number; // Unix timestamp
export type IdemKey = string;  // Idempotency key
```

</TabItem>
</Tabs>

## ID Format Details

### AgentId Format

The SDK supports two agent ID formats:

#### Format 1: Agent ID Only

```plaintext
"1234"
```

- Uses SDK’s default chain (set during SDK initialization)
- Automatically constructs `"{defaultChainId}:1234"` for subgraph queries
- Example: If SDK is initialized with `chainId=11155111`, then `"1234"` is treated as `"11155111:1234"`
#### Format 2: Chain ID Prefix

```plaintext
"chainId:agentId"
```

- Explicitly specifies the chain
- Format: `"{chainId}:{agentId}"`
- Example: `"11155111:1234"` means agent ID `1234` on Ethereum Sepolia (chain ID `11155111`)
#### Supported Chain IDs

- `11155111` - Ethereum Sepolia
  - Additional networks are planned but not enabled in SDK defaults yet.
#### Usage Examples

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

### Feedback ID Format

Feedback IDs uniquely identify individual feedback entries:

- **Format**: `"agentId:clientAddress:feedbackIndex"`
- **agentId**: The agent’s ID in `"chainId:agentId"` format (e.g., `"11155111:123"`) or just `"agentId"` (uses SDK’s default chain)
- **clientAddress**: Ethereum address of feedback giver (normalized to lowercase)
- **feedbackIndex**: Sequential index of feedback from this client to this agent (0-based)
- **Example**: `"11155111:123:0x742d35cc6634c0532925a3b844bc9e7595f0beb7:0"`
## EndpointType

<Tabs>
<TabItem label="Python">

```python
class EndpointType(Enum):
    MCP = "MCP"
    A2A = "A2A"
    ENS = "ENS"
    DID = "DID"
    WALLET = "wallet"
    OASF = "OASF"  # Open Agentic Schema Framework
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Enum from 'agent0-sdk'
export enum EndpointType {
  MCP = 'MCP',
  A2A = 'A2A',
  ENS = 'ENS',
  DID = 'DID',
  WALLET = 'wallet',
  OASF = 'OASF',  // Open Agentic Schema Framework
}
```

</TabItem>
</Tabs>

## TrustModel

<Tabs>
<TabItem label="Python">

```python
class TrustModel(Enum):
    REPUTATION = "reputation"
    CRYPTO_ECONOMIC = "crypto-economic"
    TEE_ATTESTATION = "tee-attestation"
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Enum from 'agent0-sdk'
export enum TrustModel {
  REPUTATION = 'reputation',
  CRYPTO_ECONOMIC = 'crypto-economic',
  TEE_ATTESTATION = 'tee-attestation',
}
```

</TabItem>
</Tabs>

## Endpoint

<Tabs>
<TabItem label="Python">

```python
@dataclass
class Endpoint:
    type: EndpointType
    value: str              # Endpoint value (URL, name, DID, ENS)
    meta: Dict[str, Any]    # Optional metadata
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Interface from 'agent0-sdk'
export interface Endpoint {
  type: EndpointType;
  value: string;  // Endpoint value (URL, name, DID, ENS)
  meta?: Record;  // Optional metadata
}
```

</TabItem>
</Tabs>

## RegistrationFile

<Tabs>
<TabItem label="Python">

```python
@dataclass
class RegistrationFile:
    agentId: Optional[AgentId]
    agentURI: Optional[URI]
    name: str
    description: str
    image: Optional[URI]
    walletAddress: Optional[Address]
    walletChainId: Optional[int]
    endpoints: List[Endpoint]
    trustModels: List[Union[TrustModel, str]]
    owners: List[Address]
    operators: List[Address]
    active: bool
    x402support: bool
    metadata: Dict[str, Any]
    updatedAt: Timestamp
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Interface from 'agent0-sdk'
export interface RegistrationFile {
  agentId?: AgentId;
  agentURI?: URI;
  name: string;
  description: string;
  image?: URI;
  walletAddress?: Address;
  walletChainId?: number;
  endpoints: Endpoint[];
  trustModels: (TrustModel | string)[];
  owners: Address[];  // from chain (read-only, hydrated)
  operators: Address[];  // from chain (read-only, hydrated)
  active: boolean;
  x402support: boolean;
  metadata: Record;
  updatedAt: Timestamp;
}
```

</TabItem>
</Tabs>

**Note:** In TypeScript, there are no built-in `to_dict()` or `from_dict()` methods. Use `JSON.stringify()` and `JSON.parse()` for serialization, or access properties directly from the interface.

## AgentSummary

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
    # Endpoint semantics: endpoint string when present (not booleans)
    mcp: Optional[str]
    a2a: Optional[str]
    web: Optional[str]
    email: Optional[str]
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
    # Optional (search-derived / subgraph fields)
    createdAt: Optional[Timestamp]
    updatedAt: Optional[Timestamp]
    lastActivity: Optional[Timestamp]
    agentURI: Optional[URI]
    agentURIType: Optional[str]
    feedbackCount: Optional[int]
    averageValue: Optional[float]
    semanticScore: Optional[float]
    extras: Dict[str, Any]
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Interface from 'agent0-sdk'
export interface AgentSummary {
  chainId: number;  // ChainId
  agentId: AgentId;
  name: string;
  image?: URI;
  description: string;
  owners: Address[];
  operators: Address[];
  // Endpoint semantics: endpoint string when present (not booleans)
  mcp?: string;
  a2a?: string;
  web?: string;
  email?: string;
  ens?: string;
  did?: string;
  walletAddress?: Address;
  supportedTrusts: string[];  // normalized string keys
  a2aSkills: string[];
  mcpTools: string[];
  mcpPrompts: string[];
  mcpResources: string[];
  oasfSkills?: string[];
  oasfDomains?: string[];
  active: boolean;
  x402support: boolean;
  // Optional (search-derived / subgraph fields)
  createdAt?: number;
  updatedAt?: number;
  lastActivity?: number;
  agentURI?: string;
  agentURIType?: string;
  feedbackCount?: number;
  averageValue?: number;
  semanticScore?: number;
  extras: Record;
}
```

</TabItem>
</Tabs>

## Feedback

<Tabs>
<TabItem label="Python">

```python
@dataclass
class Feedback:
    id: str                 # "agentId:clientAddress:index"
    agentId: AgentId
    reviewer: Address
    value: Optional[float]
    tags: List[str]
    text: Optional[str]
    context: Optional[Dict[str, Any]]
    proofOfPayment: Optional[Dict]
    fileURI: Optional[URI]
    createdAt: Timestamp
    answers: List[Dict[str, Any]]
    isRevoked: bool

    # Off-chain fields
    capability: Optional[str]
    name: Optional[str]
    skill: Optional[str]
    task: Optional[str]
```

</TabItem>
<TabItem label="TypeScript">

```ts
// Interface from 'agent0-sdk'
export interface Feedback {
  id: FeedbackIdTuple;  // [AgentId, Address, number]
  agentId: AgentId;
  reviewer: Address;
  value?: number;
  tags: string[];
  text?: string;
  context?: Record;
  proofOfPayment?: Record;
  fileURI?: URI;
  createdAt: Timestamp;
  answers: Array<Record>;
  isRevoked: boolean;

  // Off-chain only fields (not stored on blockchain)
  capability?: string;  // MCP capability: "prompts", "resources", "tools", "completions"
  name?: string;  // MCP tool/resource name
  skill?: string;  // A2A skill
  task?: string;  // A2A task
}

// Feedback ID types
export type FeedbackIdTuple = [AgentId, Address, number];
export type FeedbackId = string;  // "agentId:clientAddress:feedbackIndex"
```

</TabItem>
</Tabs>

**Note:** In TypeScript, `Feedback.id` is a tuple `[AgentId, Address, number]` rather than a string. The string format `"agentId:clientAddress:feedbackIndex"` is represented by the `FeedbackId` type.

## SearchFilters / SearchOptions / FeedbackFilters

The unified `searchAgents(filters, options)` API uses `SearchFilters` + `SearchOptions`, and reputation filters live under `SearchFilters.feedback` as `FeedbackFilters`.

See:
- [`/2-usage/2-5-search/`](/2-usage/2-5-search/) for examples
- [`/5-reference/5-1-sdk/`](/5-reference/5-1-sdk/) for the method signature

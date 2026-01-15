---
title: "Install"
description: "Install Agent0 SDK"
---
## Prerequisites

### Python SDK

- Python 3.8 or higher
- pip package manager
- Private key for signing transactions (or run in read-only mode)
- Access to an Ethereum RPC endpoint (e.g., Alchemy, Infura)
- (Optional) IPFS provider account (Pinata, Filecoin, or local IPFS node)
- Subgraph: Automatically configured with default URL (optional override for custom subgraph endpoints)
### TypeScript SDK

- Node.js 22 or higher
- npm or yarn package manager
- For writes: configure either a **server-side** `privateKey` or a **browser** `walletProvider` (EIP-1193)
- Access to an Ethereum RPC endpoint (e.g., Alchemy, Infura)
- (Optional) IPFS provider account (Pinata, Filecoin, or local IPFS node)
- Subgraph: Automatically configured with default URL (optional override for custom subgraph endpoints)
## Installation

<Tabs>
<TabItem label="Python">

```bash
pip install agent0-sdk
```

```bash
git clone https://github.com/agent0lab/agent0-py.git
cd agent0-py
pip install -e .
```

</TabItem>
<TabItem label="TypeScript">

```bash
npm install agent0-sdk
```

```bash
git clone https://github.com/agent0lab/agent0-ts.git
cd agent0-ts
npm install
npm run build
```

</TabItem>
</Tabs>

## Required Dependencies

<Tabs>
<TabItem label="Python">

Agent0 SDK depends on:

- `web3` - Ethereum blockchain interaction
- `eth-account` - Account management and signing
- `requests` - HTTP requests
- `ipfshttpclient` - IPFS integration
- `pydantic` - Data validation and settings management
- `python-dotenv` - Environment variable management
- `aiohttp` - Async HTTP client
All dependencies are installed automatically with pip.

</TabItem>
<TabItem label="TypeScript">

Agent0 SDK depends on:

- `viem` / EVM client stack (bundled via npm dependencies)
- `graphql-request` / GraphQL tooling for subgraph queries (bundled via npm dependencies)

All dependencies are installed automatically with npm/yarn.

</TabItem>
</Tabs>

## Optional Dependencies

For enhanced functionality:

- **Subgraph**: Automatically configured with default URL for fast search queries (override with `subgraphOverrides` for custom endpoints)
- **IPFS Providers**: Pinata JWT or Filecoin private key for decentralized file storage
## Next Steps

- Configure your [Agent](/2-usage/2-2-configure-agents/)
- Start with [Registration](/2-usage/2-3-registration-ipfs/)
- Use wallets in the browser: [Browser wallets (ERC-6963)](/2-usage/2-8-browser-wallets/)
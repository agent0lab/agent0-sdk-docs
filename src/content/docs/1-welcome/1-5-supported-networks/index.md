---
title: "Supported Networks"
description: "Supported chains and default subgraph endpoints"
---

This page is the **single source of truth** for which networks are enabled in the SDK **by default** for discovery/search (via subgraph).

## Currently supported (SDK defaults)

- **Ethereum Mainnet** (Chain ID: `1`)
  - Default (SDK): `https://gateway.thegraph.com/api/7fd2e7d89ce3ef24cd0d4590298f0b2c/subgraphs/id/FV6RR6y13rsnCxBAicKuQEwDp8ioEGiNaWaZUmvr1F8k`
- **Ethereum Sepolia** (Chain ID: `11155111`)
  - Default (SDK): `https://gateway.thegraph.com/api/00a452ad3cd1900273ea62c1bf283f93/subgraphs/id/6wQRC7geo9XYAhckfmfo8kbMRLeWU8KQd3XsJqFKmZLT`
- **Polygon Mainnet** (Chain ID: `137`)
  - Default (SDK): `https://gateway.thegraph.com/api/782d61ed390e625b8867995389699b4c/subgraphs/id/9q16PZv1JudvtnCAf44cBoxg82yK9SSsFvrjCY9xnneF`

## Notes

- The Graph Gateway endpoints require authentication (API key / authorization header). If you’re querying manually, use `https://gateway.thegraph.com/api/<API_KEY>/subgraphs/id/<SUBGRAPH_ID>`.
- You can override subgraph URLs per chain via `subgraphOverrides` when initializing the SDK.

## Coming soon

- Base Sepolia
- Base Mainnet
- BNB Chain (Binance)
- Monad
- Additional networks


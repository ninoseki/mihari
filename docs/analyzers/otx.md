---
tags:
  - IP address
  - Domain
  - Passive DNS
---

# OTX

- [https://otx.alienvault.com/](https://otx.alienvault.com/dashboard/new)

This analyzer uses [OTX API v1](https://otx.alienvault.com/api) (`/api/v1/indicators/`) API to search.

```yaml
analyzer: otx
query: ...
api_key: ...
```

## Components

### Query

`query` is a passive DNS search query. Domain or IP address.

### API Key

`api_key` is an API key. Optional. Defaults to `ENV[”OTX_API_KEY”"]`.

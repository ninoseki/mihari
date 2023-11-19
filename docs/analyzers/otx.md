---
tags:
  - Artifact:IP
  - Artifact:Domain
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

`query` (`string`) is a passive DNS search query. Domain or IP address.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `OTX_API_KEY` environment variable.

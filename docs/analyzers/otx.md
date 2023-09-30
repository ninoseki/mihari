---
tags:
  - IP address
  - Domain
  - Passive DNS
---

# OTX

- [https://otx.alienvault.com/](https://otx.alienvault.com/dashboard/new)

This analyzer uses [OTX API v1](https://otx.alienvault.com/api) (`/api/v1/indicators/`) API endpoints to search.

```yaml
analyzer: otx
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default            | Desc.                |
| ------- | ------ | --------- | ------------------ | -------------------- |
| query   | String | Yes       |                    | Domain or IP address |
| api_key | String | No        | ENV[”OTX_API_KEY”] | API key              |

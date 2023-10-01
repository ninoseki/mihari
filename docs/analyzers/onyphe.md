---
tags:
  - IP address
---

# ONYPHE

- [https://www.onyphe.io/](https://www.onyphe.io/)

This analyzer uses ONYPHE API v2 (`/api/v2/simple/datascan`) to search.

```yaml
analyzer: onyphe
query: ...
api_key: ...
```

## Components

### Query

`query` is a search query.

### API Key

`api_key` is an API key. Optional. Defaults to `ENV[”ONYPHE_API_KEY”"]`.

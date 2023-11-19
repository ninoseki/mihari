---
tags:
  - Artifact:IP
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

`query` (`string`) is a search query.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `ONYPHE_API_KEY` environment variable.

---
tags:
  - IP address
---

# BinaryEdge

- [https://www.binaryedge.io/](https://www.binaryedge.io/)

This analyzer uses [BinaryEdge API V2](https://docs.binaryedge.io/api-v2/) (`/v2/query/search`) to search. Pagination is supported.

```yaml
analyzer: binaryedge
query: ...
api_key: ...
```

## Components

### Query

`query` (`string`) is a search query.

### API Key

`api_key` (`string`) is an API key. Optional. Defaults to `ENV[”BINARYEDGE_API_KEY"]`.

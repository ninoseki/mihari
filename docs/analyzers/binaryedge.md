---
tags:
  - IP address
---

# BinaryEdge

- [https://www.binaryedge.io/](https://www.binaryedge.io/)

This analyzer uses [BinaryEdge API V2](https://docs.binaryedge.io/api-v2/) and [/v2/query/search](https://docs.binaryedge.io/api-v2/#v2querysearch) API endpoint to search.

```yaml
analyzer: binaryedge
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default                   | Desc.        |
| ------- | ------ | --------- | ------------------------- | ------------ |
| query   | String | Yes       |                           | Search query |
| api_key | String | No        | ENV[”BINARYEDGE_API_KEY"] | API key      |

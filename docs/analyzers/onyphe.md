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

| Name    | Type   | Required? | Default               | Desc.        |
| ------- | ------ | --------- | --------------------- | ------------ |
| query   | String | Yes       |                       | Search query |
| api_key | String | No        | ENV[”ONYPHE_API_KEY”] | API key      |

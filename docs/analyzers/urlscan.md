---
tags:
  - IP address
  - Domain
  - URL
---

# urlscan.io

- [https://urlscan.io/](https://urlscan.io/)

This analyzer uses [urlscan.io](http://urlscan.io) API (`/api/v1/search`) to search.

```yaml
analyzer: urlscan
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default                | Desc.        |
| ------- | ------ | --------- | ---------------------- | ------------ |
| query   | String | Yes       |                        | Search query |
| api_key | String | No        | ENV[”URLSCAN_API_KEY"] | API key      |

---
tags:
  - IP address
---

# Shodan

- [https://shodan.io/](https://shodan.io/)

This analyzer uses [Shodan REST AP](https://developer.shodan.io/api) (`/shodan/host/search`) API to search.

```yaml
analyzer: shodan
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default               | Desc.        |
| ------- | ------ | --------- | --------------------- | ------------ |
| query   | String | Yes       |                       | Search query |
| api_key | String | No        | ENV[”SHODAN_API_KEY"] | API key      |

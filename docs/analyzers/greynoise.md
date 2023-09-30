---
tags:
  - IP address
---

# GreyNoise

- [https://www.greynoise.io/](https://www.greynoise.io/)

This analyzer uses GreyNoise API and `[https://api.greynoise.io/v2/experimental/gnql](https://api.greynoise.io/v2/experimental/gnql)` API endpoint to search.

```yaml
analyzer: greynoise
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default                  | Desc.        |
| ------- | ------ | --------- | ------------------------ | ------------ |
| query   | String | Yes       |                          | Search query |
| api_key | String | No        | ENV[”GREYNOISE_API_KEY"] | API key      |

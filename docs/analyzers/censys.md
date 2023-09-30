---
tags:
  - IP address
---

# Censys

- [https://censys.io/](https://censys.io/)

The analyzer uses [Censys Search 2.0 REST API](https://search.censys.io/api) to search.

```yaml
analyzer: censys
query: ...
id: ...
secret: ...
```

| Name   | Type   | Required? | Default              | Desc.         |
| ------ | ------ | --------- | -------------------- | ------------- |
| query  | String | Yes       |                      | Search query  |
| id     | String | No        | ENV[”CENSYS_ID”]     | Censys ID     |
| secret | String | No        | ENV[”CENSYS_SECRET”] | Censys secret |

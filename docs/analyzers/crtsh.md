---
tags:
  - Artifact:Domain
---

# crt.sh

- [https://crt.sh/](https://crt.sh/)

This analyzer uses [crt.sh](http://crt.sh)'s (unofficial?) REST API.

```yaml
analyzer: crtsh
query: ...
exclude_expired: ...
match: ...
```

## Components

### Query

`query` (`string`) is a search query.

### Exclude Expired

`exclude_expired` (`boolean`) determines whether to exclude expired domains or not. Optional. Defaults to `true`.

### Match

`match` (`string`) is an identity matching option. `=`, `ILIKE`, `LIKE`, `single`, `any` or `FTS`. Optional.

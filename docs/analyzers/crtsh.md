---
tags:
  - Domain
---

# crt.sh

- [https://crt.sh/](https://crt.sh/)

This analyzer uses [crt.sh](http://crt.sh)'s (unofficial?) REST API.

```yaml
analyzer: crtsh
query: ...
exclude_expired: ...
```

| Name            | Type               | Default | Desc.                                     |
| --------------- | ------------------ | ------- | ----------------------------------------- |
| query           | String             |         | Search query                              |
| exclude_expired | Boolean (optional) | True    | Whether to exclude expired domains or not |

!!! tip

    if `exclude_expired` is set as `true`, expired domains are excluded from search results.

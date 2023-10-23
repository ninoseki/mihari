---
tags:
  - Artifact:Domain
---

# dnstwister

- [https://dnstwister.report/](https://dnstwister.report/)

This analyzer uses [dnstwister API](https://dnstwister.report/api/) to search.

```yaml
analyzer: dnstwister
query: ...
```

## Components

### Query

`query` (`string`) is a search query.

!!! tip

    There is no need to input a domain in hexadecimal format. This analyzer automatically converts a domain (in string format) into a hexadecimal value.

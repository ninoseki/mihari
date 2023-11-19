---
tags:
  - Artifact:IP
---

# Censys

- [https://censys.io/](https://censys.io/)

This analyzer uses [Censys Search 2.0 REST API](https://search.censys.io/api) to search. Pagination is supported.

```yaml
analyzer: censys
query: ...
id: ...
secret: ...
```

## Components

### Query

`query` (`string`) is a search query.

### ID

`id` (`string`) is a Cencys ID. Optional. Configurable via `CENSYS_ID` environment variable.

### Secret

`secret` (`string`) is a Cencys secret. Optional. Configurable via `CENSYS_SECRET` environment variable.

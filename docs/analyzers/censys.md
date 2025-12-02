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
version: 2
# v2
id: ...
secret: ...
# v3
api_key: ...
organization_id: ...
```

## Components

### Query

`query` (`string`) is a search query.

## Version

`version` (`integer`) indicates an API version. 2 or 3. Defaults to 2. Configurable via `CENSYS_VERSION` environment variable.

### ID

`id` (`string`) is a Cencys ID for the v2 API. Optional. Configurable via `CENSYS_ID` environment variable.

### Secret

`secret` (`string`) is a Cencys secret for the v2 API. Optional. Configurable via `CENSYS_SECRET` environment variable.

### PAT

`pat` (`string`) is a Personal Access Token for the v3 API. Optional. Configurable via `CENSYS_PAT` environment variable.

### Organization ID

`organization_id` (`string`) is an organization ID for the v3 API. Optional. Configurable via `CENSYS_ORGANIZATION_ID` environment variable.

### Examples

**v2**

```yaml
analyzer: censys
query: "ip:1.1.1.1"
version: 2
```

**v3**

```yaml
analyzer: censys
query: "host.ip:1.1.1.1"
version: 3
```

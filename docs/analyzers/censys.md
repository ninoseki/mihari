---
tags:
  - Artifact:IP
---

# Censys Search API (Version 2)

- [https://censys.io/](https://censys.io/)

> Looking for the new Platform API? See [Censys Platform API (Version 3)](censys_v3.md).

This document covers the legacy [Censys Search 2.0 REST API](https://search.censys.io/api). The unified analyzer still defaults to `version: 2` for backward compatibility, but emits a warning so you can migrate to version 3.

```yaml
analyzer: censys
query: ...
id: ...
secret: ...
options:
  version: 2   # defaults to 2 when omitted, emits a warning about upcoming deprecation
```

## Components

### Query

`query` (`string`) is a search query sent to the selected API version.

### Version

`options.version` (`integer`) selects the backend:

- `2` (default) uses legacy ID/secret authentication. A warning is emitted when this default is applied so you can migrate before the Search 2.0 API sunsets.
- `3` uses the Platform API via Personal Access Token.

### Legacy Credentials (version 2)

- `id` maps to the `CENSYS_ID` environment variable.
- `secret` maps to the `CENSYS_SECRET` environment variable.

Both values are required when targeting version 2; you can inline them in the rule or set them as config.

### Platform Credentials (version 3)

See [Censys Platform API (Version 3)](censys_v3.md) for PAT-based authentication.

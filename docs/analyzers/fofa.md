---
tags:
  - Artifact:IP
---

# Fofa

- https://en.fofa.info/

This analyzer uses Fofa API (`/api/v1/search/all`) to search. Pagination is supported.

```yaml
analyzer: fofa
query: ...
api_key: ...
email: ...
```

## Components

### Query

`query` (`string`) is a search query.

### API Key

`api_key` (`string`) is an API key. Optional. Defaults to `ENV[”FOFA_API_KEY"]`.

### Email

`email` (`string`) is an email. Optional. Defaults to `ENV[”FOFA_EMAIL"]`.

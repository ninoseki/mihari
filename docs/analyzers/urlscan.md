---
tags:
  - Artifact:IP
  - Artifact:Domain
  - Artifact:URL
---

# urlscan.io

- [https://urlscan.io/](https://urlscan.io/)

This analyzer uses [urlscan.io](http://urlscan.io) API (`/api/v1/search`) to search. Pagination is supported.

```yaml
analyzer: urlscan
query: ...
api_key: ...
data_types: ...
```

## Components

### Query

`query` (`string`) is a search query.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `URLSCAN_API_KEY` environment variable.

### Data Types

A list of data types allowed.

Defaults to:

- `ip`
- `domain`
- `url`

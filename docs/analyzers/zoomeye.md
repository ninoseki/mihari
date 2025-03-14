---
tags:
  - Artifact:IP
---

# ZoomEye

- [https://zoomeye.ai/](https://zoomeye.ai/)

This analyzer uses ZoomEye API v2 (`/v2/search`) to search.

```yaml
analyzer: zoomeye
query: ...
api_key: ...
data_types: ...
```

## Components

### Query

`query` (`string`) is a search query.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `ZOOMEYE_API_KEY` environment variable.

### Data Types

A list of data types allowed.

Defaults to:

- `ip`
- `domain`
- `url`

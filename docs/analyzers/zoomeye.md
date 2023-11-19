---
tags:
  - Artifact:IP
---

# ZoomEye

- [https://zoomeye.org/](https://zoomeye.org/)

This analyzer uses ZoomEye API v3. Pagination is supported.

An API endpoint to use is changed based on a `type` option.

| Type | API endpoint   | Artifact type |
| ---- | -------------- | ------------- |
| web  | `/web/search`  | IP address    |
| host | `/host/search` | IP address    |

```yaml
analyzer: zoomeye
query: ...
type: ...
api_key: ...
```

## Components

### Query

`query` (`string`) is a search query.

### Type

`type` (`string`) determines a search type. `web` or `host`.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `ZOOMEYE_API_KEY` environment variable.

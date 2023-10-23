---
tags:
  - Artifact:IP
---

# Shodan

- [https://shodan.io/](https://shodan.io/)

This analyzer uses [Shodan REST AP](https://developer.shodan.io/api) (`/shodan/host/search`) API to search. Pagination is supported.

```yaml
analyzer: shodan
query: ...
api_key: ...
```

## Components

### Query

`query` (`string`) is a search query.

### API Key

`api_key` (`string`) is an API key. Optional. Defaults to `ENV[”SHODAN_API_KEY"]`.

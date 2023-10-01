---
tags:
  - IP address
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

`query` is a search query.

### API Key

`api_key` is an API key. Optional. Defaults to `ENV[”SHODAN_API_KEY"]`.

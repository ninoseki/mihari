---
tags:
  - IP address
  - Domain
  - Passive DNS
---

# Pulsedive

- [https://pulsedive.com/](https://pulsedive.com/)

This analyzer uses [Pulsedive API](https://pulsedive.com/api/) (`/api/info.php`) to search.

```yaml
analyzer: pulsedive
query: ...
api_key: ...
```

## Components

### Query

`query` is a passive DNS search query. Domain or IP address.

### API Key

`api_key` is an API key. Optional. Defaults to `ENV[”PULSEDIVE_API_KEY"]`.
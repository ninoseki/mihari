---
tags:
  - Artifact:IP
  - Artifact:Domain
  - Passive DNS
  - Reverse Whois
---

# Validin

- https://www.validin.com/

This analyzer uses [Validin API](https://app.validin.com/docs).

An API endpoint to use is changed based on a type of a query.

| Query type | API endpoint                             | Artifact   |
| ---------- | ---------------------------------------- | ---------- |
| IP address | `/api/axon/domain/dns/history/:domain/A` | Domain     |
| Domain     | `/api/axon/ip/dns/history/:ip`           | IP address |

```yaml
analyzer: validin
query: ...
api_key: ...
```

## Components

### Query

`query` (`string`) is a domain or an IP address.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `VALIDIN_API_KEY` environment variable.

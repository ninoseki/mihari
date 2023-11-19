---
tags:
  - Artifact:IP
  - Artifact:Domain
  - Passive DNS
  - Reverse Whois
---

# SecurityTrails

- [https://securitytrails.com/](https://securitytrails.com/)

This analyzer uses [SecurityTrails API](https://docs.securitytrails.com/docs).

An API endpoint to use is changed based on a type of a query.

| Query type | API endpoint       | Artifact   |
| ---------- | ------------------ | ---------- |
| IP address | `/v1/domains/list` | Domain     |
| Domain     | `/v1/history/`     | IP address |
| Mail       | `/v1/domains/list` | Domain     |

```yaml
analyzer: securitytrails
query: ...
api_key: ...
```

## Components

### Analyzer

`analyzer` (`string`) should be either of `securitytrails` and `st`.

### Query

`query` (`string`) is a passive DNS search/reverse whois query. Domain, IP address or mail.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `SECURITYTRAILS_API_KEY` environment variable.

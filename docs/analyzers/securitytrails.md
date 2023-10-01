---
tags:
  - IP address
  - Domain
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

### Query

`query` is a passive DNS search/reverse whois query. Domain, IP address or mail.

### API Key

`api_key` is an API key. Optional. Defaults to `ENV[”SECURITYTRAILS_API_KEY"]`.

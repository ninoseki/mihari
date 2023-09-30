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

| Name    | Type   | Required? | Default                       | Desc.                              |
| ------- | ------ | --------- | ----------------------------- | ---------------------------------- |
| query   | String | Yes       |                               | Domain, IP address or mail address |
| api_key | String | No        | ENV[”SECURITYTRAILS_API_KEY"] | API key                            |

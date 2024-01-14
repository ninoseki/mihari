---
tags:
  - Artifact:IP
  - Passive DNS
  - Passive SSL
---

# CIRCL Passive DNS/SSL

- [https://www.circl.lu/services/passive-dns/](https://www.circl.lu/services/passive-dns/)
- [https://www.circl.lu/services/passive-ssl/](https://www.circl.lu/services/passive-ssl/)

This analyzer uses CIRCL passive DNS API or passive SSL API:

- Use passive DNS API if a query is a domain.
- Use passive SSL API if a query is a SHA1 certificate fingerprint.

```yaml
analyzer: circl
query: ...
password: ...
username: ...
```

## Components

### Query

`query` (`string`) is a domain or SHA1 certificate fingerprint.

### Username

`username` (`string`) is a username. Optional. Configurable via `CIRCL_PASSIVE_USERNAME`.

### Password

`password` (`string`) is a password. Optional. Configurable via `CIRCL_PASSIVE_PASSWORD`.

---
tags:
  - IP address
  - Passive DNS
  - Passive SSL
---

# CIRCL Passive DNS/SSL

- [https://www.circl.lu/services/passive-dns/](https://www.circl.lu/services/passive-dns/)
- [https://www.circl.lu/services/passive-ssl/](https://www.circl.lu/services/passive-ssl/)

This analyzer uses CIRCL passive DNS API or passive SSL API:

- Use passive DNS API if a query(input) is a domain
- Use passive SSL API if a query(input) is a SHA1 certificate fingerprint

```yaml
analyzer: circl
query: ...
password: ...
username: ...
```

## Components

### Query

`query` is a domain or SHA1 certificate fingerprint.

### Username

`username` is a username. Optional. Defaults to `ENV[”CIRCL_PASSIVE_USERNAME”]`.

### Password

`password` is a password. Optional. Defaults to `ENV[”CIRCL_PASSIVE_PASSWORD”]`.

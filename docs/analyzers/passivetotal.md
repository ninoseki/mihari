---
tags:
  - IP address
  - Domain
  - Passive DNS
  - Passive SSL
  - Reverse Whois
---

# PassiveTotal

- [https://community.riskiq.com/](https://community.riskiq.com/home)

This analyzer uses [PassvieTotal API](https://api.passivetotal.org/index.html).

An API endpoint to use is changed based on a type of a query.

| Query                                   | API endpoint                  | Artifact   |
| --------------------------------------- | ----------------------------- | ---------- |
| IP address                              | `/v2/dns/passive`             | Domain     |
| Domain                                  | `/v2/dns/passive`             | IP address |
| Mail                                    | `/v2/whois/search`            | Domain     |
| Hash (SSL certificate SHA1 fingerprint) | `/v2/ssl-certificate/history` | IP address |

```yaml
analyzer: passivetotal
query: ...
username: ...
api_key: ...
```

## Components

### Query

`query` (`string`) is a passive DNS/SSL or reverse whois search query. Domain, IP address, mail or SHA1 certificate fingerprint.

- Passive DNS: Domain, IP Address
- Passive SSL: SHA1 certificate fingerprint
- Reverse whois: mail

### Username

`username` (`string`) is a username. Optional. Defaults to `ENV[”PASSIVETOTAL_USERNAME"]`.

### API Key

`api_key` (`string`) is an API key. Optional. Defaults to `ENV[”PASSIVETOTAL_API_KEY"]`.

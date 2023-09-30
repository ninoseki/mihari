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

| Name     | Type   | Required? | Default                      | Desc.                                                            |
| -------- | ------ | --------- | ---------------------------- | ---------------------------------------------------------------- |
| query    | String | Yes       |                              | Domain, IP address, mail address or SHA1 certificate fingerprint |
| username | String | No        | ENV[”PASSIVETOTAL_USERNAME"] | Username                                                         |
| api_key  | String | No        | ENV[”PASSIVETOTAL_API_KEY"]  | API key                                                          |

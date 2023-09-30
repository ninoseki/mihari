---
tags:
  - IP address
  - Domain
  - Passive DNS
---

# VirusTotal

- [https://www.virustotal.com](https://www.virustotal.com/gui/home/search)

The analyzer uses VirusTotal API v3.

An API endpoint to use is changed based on a type of a query.

::: top

    Note that this analyzer only checks passive DNS data of a given query (domain or IP address).

| Query      | API endpoint            | Artifact   |
| ---------- | ----------------------- | ---------- |
| IP address | `/api/v3/ip_addresses/` | Domain     |
| Domain     | `/api/v3/domains/`      | IP address |

```yaml
analyzer: virustotal
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default                   | Desc.                |
| ------- | ------ | --------- | ------------------------- | -------------------- |
| query   | String | Yes       |                           | Domain or IP address |
| api_key | String | No        | ENV[”VIRUSTOTAL_API_KEY"] | API key              |

---
tags:
  - Artifact:IP
  - Artifact:Domain
  - Passive DNS
---

# VirusTotal

- [https://www.virustotal.com](https://www.virustotal.com/gui/home/search)

This analyzer uses VirusTotal API v3.

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

## Components

### Analyzer

`analyzer` (`string`) should be either of `virustoal` and `vt`.

### Query

`query` (`string`) is a passive DNS search query. Domain or IP address.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `VIRUSTOTAL_API_KEY` environment variable.

---
tags:
  - IP address
  - Domain
  - URL
  - Hash
---

# VirusTotal Intelligence

- [https://www.virustotal.com](https://www.virustotal.com/gui/home/search)

This analyzer uses VirusTotal Intelligence API. Pagination is supported.

```yaml
analyzer: virustotal_intelligence
query: ...
api_key: ...
```

## Components

### Query

`query` is a search query.

### API Key

`api_key` is an API key. Optional. Defaults to `ENV[”VIRUSTOTAL_API_KEY"]`.

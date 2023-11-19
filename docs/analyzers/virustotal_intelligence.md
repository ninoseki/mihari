---
tags:
  - Artifact:IP
  - Artifact:Domain
  - Artifact:URL
  - Artifact:Hash
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

### Analyzer

`analyzer` (`string`) should be either of `virustotal_intelligence` and `vt_intel`.

### Query

`query` (`string`) is a search query.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `VIRUSTOTAL_API_KEY` environment variable.

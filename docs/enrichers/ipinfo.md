---
tags:
  - Enrichment:Autonomous_System
  - Enrichment:Geolocation
---

# ipinfo.io

- [https://ipinfo.io/](https://ipinfo.io/)

This enricher uses ipinfo.io API to enrich an IP artifact.

```yaml
enricher: ipinfo
api_key: ...
```

## Components

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `IPINFO_API_KEY` environment variable.

## Supported Artifacts

- IP address

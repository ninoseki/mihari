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

`api_key` (`string`) is an API key. Optional. Defaults to `ENV[”IPINFO_API_KEY”]`.

## Supported Artifacts

- IP address

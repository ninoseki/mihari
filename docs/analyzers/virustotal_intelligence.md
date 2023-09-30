---
tags:
  - IP address
  - Domain
  - URL
  - Hash
---

# VirusTotal Intelligence

- [https://www.virustotal.com](https://www.virustotal.com/gui/home/search)

```yaml
analyzer: virustotal_intelligence
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default                   | Desc.        |
| ------- | ------ | --------- | ------------------------- | ------------ |
| query   | String | Yes       |                           | Search query |
| api_key | String | No        | ENV[”VIRUSTOTAL_API_KEY"] | API key      |

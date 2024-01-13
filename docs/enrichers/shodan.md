---
tags:
  - Enrichment:Port
  - Enrichment:CPE
  - Enrichment:Reverse_DNS_Name
  - Enrichment:Vulnerability
---

# Shodan (The InternetDB API)

- [https://www.shodan.io/](https://www.shodan.io/dashboard)

This enricher uses Shodan InternetDB API to enrich an artifact.

[https://internetdb.shodan.io/](https://internetdb.shodan.io/)

```yaml
enricher: shodan
```

This enricher can add the following components:

- Ports
- CPEs
- Reverse DNS names
- Vulnerabilities

## Supported Artifacts

- IP address

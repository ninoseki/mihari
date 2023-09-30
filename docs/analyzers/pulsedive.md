---
tags:
  - IP address
  - Domain
  - Passive DNS
---

# Pulsedive

- [https://pulsedive.com/](https://pulsedive.com/)

This analyzer uses [Pulsedive API](https://pulsedive.com/api/) (`/api/info.php`) to search.

```yaml
analyzer: pulsedive
query: ...
api_key: ...
```

| Name    | Type   | Required? | Default                  | Desc.                |
| ------- | ------ | --------- | ------------------------ | -------------------- |
| query   | String | Yes       |                          | Domain or IP address |
| api_key | String | No        | ENV[”PULSEDIVE_API_KEY"] | API key              |

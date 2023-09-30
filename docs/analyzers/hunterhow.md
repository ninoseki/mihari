---
tags:
  - IP address
---

# Hunter How

- [https://hunter.how/](https://hunter.how/)

This analyzer uses `https://api.hunter.how/search` API endpoint to search.

```yaml
analyzer: hunterhow
query: ...
api_key: ...
start_time: ...
end_time: ...
```

| Name       | Type   | Required? | Default                  | Desc.        |
| ---------- | ------ | --------- | ------------------------ | ------------ |
| query      | String | Yes       |                          | Search query |
| start_time | Date   | Yes       |                          |              |
| end_time   | Date   | Yes       |                          |              |
| api_key    | String | No        | ENV[”HUNTERHOW_API_KEY"] | API key      |

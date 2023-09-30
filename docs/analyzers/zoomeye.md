# ZoomEye

- [https://zoomeye.org/](https://zoomeye.org/)

The analyzer uses ZoomEye API v3.

An API endpoint to use is changed based on a `type` option.

| Type | API endpoint   | Artifact type |
| ---- | -------------- | ------------- |
| web  | `/web/search`  | IP address    |
| host | `/host/search` | IP address    |

```yaml
analyzer: zoomeye
query: ...
type: ...
api_key: ...
```

| Name    | Type                     | Required? | Default                | Desc.        |
| ------- | ------------------------ | --------- | ---------------------- | ------------ |
| query   | String                   | Yes       |                        | Search query |
| type    | String (`web` or `host`) | Yes       |                        | Query type   |
| api_key | String                   | No        | ENV[”ZOOMEYE_API_KEY"] | API key      |

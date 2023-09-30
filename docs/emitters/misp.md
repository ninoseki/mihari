# MISP

- [https://www.misp-project.org/](https://www.misp-project.org/)

This emitter creates an event on MISP based on an alert.

```yaml
emitter: misp
url: ...
api_key: ...
```

| Name    | Type   | Required? | Default             | Desc.        |
| ------- | ------ | --------- | ------------------- | ------------ |
| url     | String | No        | ENV[”MISP_URL”]     | MISP API URL |
| api_key | String | No        | ENV[”MISP_API_KEY”] | MISP API key |

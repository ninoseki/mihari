# TheHive

- [https://thehive-project.org/](https://thehive-project.org/)

This emitter creates an alert on TheHive. TheHive v4 & v5 are supported.

```yaml
emitter: the_hive
url: ...
api_key: ...
api_version: ...
```

| Name        | Type   | Required? | Default                    | Desc.               |
| ----------- | ------ | --------- | -------------------------- | ------------------- |
| url         | String | No        | ENV[”THEHIVE_URL”]         | TheHive API URL     |
| api_key     | String | No        | ENV[”THEHIVE_API_KEY”]     | TheHive API key     |
| api_version | String | No        | ENV[”THEHIVE_API_VERSION”] | TheHive API version |

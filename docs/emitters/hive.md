# TheHive

- [https://thehive-project.org/](https://thehive-project.org/)

This emitter creates an alert on TheHive. TheHive v4 & v5 are supported.

```yaml
emitter: the_hive
url: ...
api_key: ...
api_version: ...
```

## Components

### URL

`url` is a TheHive URL. Optional. Defaults to `ENV[”THEHIVE_URL”]`.

### API Key

`api_key` is an API key. Optional. Defaults to `ENV[”THEHIVE_API_KEY”]`.

### API Version

`api_version` is a version of The Hive API. Optional. Defaults to `ENV[”THEHIVE_API_VERSION”]`.

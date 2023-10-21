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

`url` (`string`) is a TheHive URL. Optional. Defaults to `ENV[”THEHIVE_URL”]`.

### API Key

`api_key` (`string`) is an API key. Optional. Defaults to `ENV[”THEHIVE_API_KEY”]`.

### API Version

`api_version` (`string`) is a version of The Hive API. Optional. `v4` or `v5`. Defaults to `ENV[”THEHIVE_API_VERSION”]`.

# TheHive

- [https://thehive-project.org/](https://thehive-project.org/)

This emitter creates an alert on TheHive. TheHive v5 is supported.

```yaml
emitter: thehive
url: ...
api_key: ...
```

## Components

### URL

`url` (`string`) is a TheHive URL. Optional. Configurable via `THEHIVE_URL` environment variable.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `THEHIVE_API_KEY` environment variable.

### Observable Tags

`observable_tags` (`array[:string]`) is a list of observable tags. Optional. Defaults to `[]`.

!!! note

    `tags` of a rule are set as tags of an alert.

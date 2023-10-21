# MISP

- [https://www.misp-project.org/](https://www.misp-project.org/)

This emitter creates an event on MISP based on an alert. MISP v2 is supported.

```yaml
emitter: misp
url: ...
api_key: ...
```

## Components

### URL

`url` (`string`) is a MISP URL. Optional. Defaults to `ENV[MISP_URL]`.

### API Key

`api_key` (`string`) is an API key. Optional. Defaults to `ENV[”MISP_API_KEY”]`.

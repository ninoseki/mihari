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

`url` (`string`) is a MISP URL. Optional. Configurable via `MISP_URL` environment variable.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `MISP_API_KEY` environment variable.

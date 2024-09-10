# MISP

- [https://www.misp-project.org/](https://www.misp-project.org/)

This emitter creates an event on MISP based on an alert. MISP v2 is supported.

```yaml
emitter: misp
url: ...
api_key: ...
attribute_tags: ...
```

## Components

### URL

`url` (`string`) is a MISP URL. Optional. Configurable via `MISP_URL` environment variable.

### API Key

`api_key` (`string`) is an API key. Optional. Configurable via `MISP_API_KEY` environment variable.

### Attribute Tags

`attribute_tags` (`array[:string]`) is a list of attribute tags. Optional. Defaults to `[]`.

!!! note

    `tags` of a rule are set as tags of an event.

    ```yaml
    id: ...
    title: ...
    description: ...
    tags: # tags for an event
      - foo
    queries:
      - analyzer: ...
        query: ...
    emitters:
      - emitter: database
      - emitter: misp
        url: ...
        api_key: ...
        attribute_tags: # tags for attribute(s)
          - bar
    ```

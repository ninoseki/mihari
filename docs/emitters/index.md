# Emitters

- [Database](database.md)
- [TheHive](hive.md)
- [MISP](misp.md)
- [Slack](slack.md)
- [Webhook](webhook.md)

## Options

All the emitters can have optional `options`.

```yaml
emitter: ...
options:
  retry_times: ...
  retry_interval: ...
  retry_exponential_backoff: ...
```

### Retry Times

`retry_times` (`integer`) is a number of times of retry when something goes wrong. Optional. Defaults to 3.

### Retry Interval

`retry_interval` (`integer`) is an interval in seconds between retries. Optional. Defaults to 5.

### Retry Exponential Backoff

`retry_exponential_backoff` (`bool`) controls whether to do exponential backoff. Optional. Defaults to `true`.

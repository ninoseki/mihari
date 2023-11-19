# Enrichers

- [Google Public DNS](google_public_dns.md)
- [IPInfo](ipinfo.md)
- [Shodan](shodan.md)
- [Whois](whois.md)

## Options

All the emitters can have optional `options`.

```yaml
enricher: ...
options:
  timeout: ...
  retry_times: ...
  retry_interval: ...
  retry_exponential_backoff: ...
```

### Timeout

`timeout` (`integer`) is an HTTP timeout in seconds. Optional.

### Retry Times

`retry_times` (`integer`) is a number of times of retry when something goes wrong. Optional. Defaults to 3. Configurable via `RETRY_TIMES` environment variable.

### Retry Interval

`retry_interval` (`integer`) is an interval in seconds between retries. Optional. Defaults to 5. Configurable via `RETRY_INTERVAL` environment variable.

### Retry Exponential Backoff

`retry_exponential_backoff` (`bool`) controls whether to do exponential backoff. Optional. Defaults to `true`. Configurable via `RETRY_EXPONENTIAL_BACKOFF` environment variable.

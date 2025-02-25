# Analyzers

- [BinaryEdge](binaryedge.md)
- [Censys](censys.md)
- [Circle Passive DNS/SSL](circl.md)
- [crt.sh](crtsh.md)
- [dnstwister](dnstwister.md)
- [Feed](feed.md)
- [Fofa](fofa.md)
- [GreyNoise](greynoise.md)
- [HunterHow](hunterhow.md)
- [Onyphe](onyphe.md)
- [OTX](otx.md)
- [PassiveTotal](passivetotal.md)
- [PulseDive](pulsedive.md)
- [SecurityTrails](securitytrails.md)
- [Shodan](shodan.md)
- [urlscan.io](urlscan.md)
- [Validin](validin.md)
- [VirusTotal](virustotal.md)
- [VirusTotal Intelligence](virustotal_intelligence.md)
- [ZoomEye](zoomeye.md)

## Options

All the analyzers can have optional `options`.

```yaml
analyzer: ...
query: ...
options:
  retry_times: ...
  retry_interval: ...
  retry_exponential_backoff: ...
  timeout: ...
  ignore_error: ...
  parallel: ...
```

Also the following analyzers can have pagination options.

- [BinaryEdge](binaryedge.md)
- [Censys](censys.md)
- [Fofa](fofa.md)
- [GreyNoise](greynoise.md)
- [HunterHow](hunterhow.md)
- [Onyphe](onyphe.md)
- [Shodan](shodan.md)
- [urlscan.io](urlscan.md)
- [VirusTotal Intelligence](virustotal_intelligence.md)

```yaml
options:
  pagination_interval: ...
  pagination_limit: ...
```

### Retry Times

`retry_times` (`integer`) is a number of times of retry when something goes wrong. Optional. Defaults to 3. Configurable via `RETRY_TIMES` environment variable.

### Retry Interval

`retry_interval` (`integer`) is an interval in seconds between retries. Optional. Defaults to 5. Configurable via `RETRY_INTERVAL` environment variable.

### Retry Exponential Backoff

`retry_exponential_backoff` (`bool`) controls whether to do exponential backoff. Optional. Defaults to `true`. Configurable via `RETRY_EXPONENTIAL_BACKOFF` environment variable.

### Timeout

`timeout` (`integer`) is an HTTP timeout in seconds. Optional.

### Ignore Error

`ignore_error` (`bool`) controls whether to ignore an error or not. Optional. Defaults to `false`.

Mihari uses fail-fast approach. For example, if the first Shodan analyzer fails, the second Censys analyzer will not be triggered because Mihari will fail before it.

```yaml
queries:
  - analyzer: shodan
    query: ip:1.1.1.1
  - analyzer: censys
    query: ip:8.8.8.8
```

You can set `ignore_error` option to make it fault-tolerant.

```yaml
queries:
  - analyzer: shodan
    query: ip:1.1.1.1
    options:
      ignore_error: true
  - analyzer: censys
    query: ip:8.8.8.8
```

### Parallel

`parallel` (`bool`) controls whether to allow parallel execution or not. Optional. Defaults to `false`. Configurable via `ANALYZER_PARALLELISM` environment variable.

### Pagination Interval

`pagination_interval` (`integer`) is an interval in seconds between pagination. Optional. Defaults to 0. Configurable via `PAGINATION_INTERVAL` environment variable.

### Pagination Limit

`pagination_limit` (`integer`) is an limit for pagination. Optional. Defaults to 100. Configurable via `PAGINATION_LIMIT` environment variable.

In the worst case, if something wrong with Mihari or a service, Mihari can drain API quota by doing pagination forever.
`pagination_limit` is a safety valve for that. A number of pagination is limited as `pagination_limit` times.

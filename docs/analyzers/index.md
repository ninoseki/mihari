# Analyzers

- [BinaryEdge](binaryedge.md)
- [Censys](censys.md)
- [Circle Passive DNS/SSL](circl.md)
- [crt.sh](crtsh.md)
- [dnstwister](dnstwister.md)
- [Feed](feed.md)
- [GreyNoise](greynoise.md)
- [HunterHow](hunterhow.md)
- [Onyphe](onyphe.md)
- [OTX](otx.md)
- [PassiveTotal](passivetotal.md)
- [PulseDive](pulsedive.md)
- [SecurityTrails](securitytrails.md)
- [Shodan](shodan.md)
- [urlscan.io](urlscan.md)
- [VirusTotal](virustotal.md)
- [VirusTotal Intelligence](virustotal_intelligence.md)

## Options

All the analyzers can have optional `options`.

```yaml
analyzer: ...
query: ...
options:
  timeout: ...
  interval: ...
  pagination_limit: ...
  retry_times: ...
  retry_interval: ...
  retry_exponential_backoff: ...
  ignore_error: ...
```

### Timeout

`timeout` is an HTTP timeout in seconds. Optional.

### Interval

`interval` is an interval in seconds between pagination. (If an analyzer does pagination). Optional.

### Pagination Limit

`pagination_limit` is an limit for pagination. Defaults to 100.

In the worst case, if something wrong with Mihari or a service, Mihari can drain API quota by doing pagination forever.
`pagination_limit` is a safety valve for that. A number of pagination is limited as `pagination_limit` times.

### Retry Times

`retry_times` is a number of times of retry when something goes wrong. Defaults to 3.

### Retry Interval

`retry_interval` is an interval in seconds between retries. Defaults to 5.

### Retry Exponential Backoff

`retry_exponential_backoff` (`bool`) controls whether to do exponential backoff. Defaults to `true`.

### Ignore Error

`ignore_error` controls whether to ignore an error or not. Defaults to `false`.

Mihari uses fail-fast approach. For example, if Shodan returns an error, the Censys query next is not triggered because Mihari raises an error before it.

```yaml
queries:
  - analyzer: shodan
    query: ip:1.1.1.1
  - analyzer: censys
    query: ip:8.8.8.8
```

You can set `ignore_error` option to make it fault tolerance.

```yaml
queries:
  - analyzer: shodan
    query: ip:1.1.1.1
    options:
      ignore_error: true
  - analyzer: censys
    query: ip:8.8.8.8
```

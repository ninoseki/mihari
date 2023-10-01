# Feed

This analyzer can ingest a feed (JSON or CSV) by specifying conditions.

Note that you should write a selector to get proper IoCs from a feed. A selector is based on [jr](https://github.com/yuya-takeyama/jr).

```yaml
analyzer: feed
query: ...
selector: ...
method: ...
headers: ...
params: ...
data: ...
json: ...
```

## Components

### Query

`query` is a URL of a feed.

!!! note

    I know this is a strange naming. It's just for keeping the convention with other analyzers.

### Method

`method` is an HTTP method. Defaults to `GET`.

### Selector

`selector` is a `jr` selector.

### Headers

`headers` (hash) is an HTTP headers. Optional.

### Params

`params` (hash) is an HTTP query params. Optional.

### Data

`data` (hash) is an HTTP form data. Optional.

### JSON

`json` (hash) is an JSON body. Optional.

## Examples

### ThreatFox

```yaml
analyzer: feed
query: "https://threatfox-api.abuse.ch/api/v1/"
method: POST
json:
  query: get_iocs
  days: 1
headers:
selector: "map(&:data).unwrap.map(&:ioc).map { |v| v.start_with?('http://', 'https://') ? v :  v.split(':').first }"
```

### URLhaus

```yaml
analyzer: feed
query: "https://urlhaus.abuse.ch/feeds/country/JP/"
selector: "map { |v| v[1] }"
```

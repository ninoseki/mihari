# Feed

This analyzer can ingest a feed (JSON or CSV) by specifying conditions.

Note that you should write a selector to get proper IoCs from a feed. A selector is based on [jq](https://jqlang.github.io/jq/).

```yaml
analyzer: feed
query: ...
selector: ...
method: ...
headers: ...
params: ...
form: ...
json: ...
```

## Components

### Query

`query` (`string`) is a URL of a feed.

!!! note

    I know this is a strange naming. It's just for keeping the convention with other analyzers.

### Method

`method` (`string`) is an HTTP method. Defaults to `GET`.

### Selector

`selector` (`string`) is a `jq` selector.

### Headers

`headers` (`hash`) is an HTTP headers. Optional.

### Params

`params` (`hash`) is an HTTP query params. Optional.

### Form

`form` (`hash`) is an HTTP form data. Optional.

### JSON

`json` (`hash`) is an JSON body. Optional.

## Examples

### ThreatFox

**Get URL IoCs**

```yaml
analyzer: feed
query: "https://threatfox-api.abuse.ch/api/v1/"
method: POST
json:
  query: get_iocs
  days: 1
headers:
selector: '.data[] | select(.ioc_type == "url") | .ioc'
```

**Get IP IoCs**

```yaml
analyzer: feed
query: "https://threatfox-api.abuse.ch/api/v1/"
method: POST
json:
  query: get_iocs
  days: 1
headers:
selector: '.data[] | select(.ioc_type == "ip:port") | .ioc | split(":")[0]'
```

!!! tip

    Mihari does not support `ip:port` format. So you have to split a value by `:`.

### URLhaus

```yaml
analyzer: feed
query: "https://urlhaus.abuse.ch/feeds/country/JP/"
selector: ".[][1]"
```

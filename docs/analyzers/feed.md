# Feed

This analyzer can ingest a feed (JSON or CSV) by specifying conditions.

Note that you should write a selector to get proper IoCs from a feed. A selector is based on [jr](https://github.com/yuya-takeyama/jr).

```yaml
analyzer: feed
query: ...
http_request_method: ...
http_request_payload: ...
http_request_payload_type: ...
http_request_headers: ...
selector: ...
```

| Name                      | Type   | Required? | Default | Desc.                                |
| ------------------------- | ------ | --------- | ------- | ------------------------------------ |
| query                     | String | Yes       |         | URL                                  |
| http_request_method       | String | No        | GET     | HTTP request method (GET or POST)    |
| http_request_headers      | Hash   | No        |         | HTTP request headers                 |
| http_request_payload      | Hash   | No        |         | HTTP request payload                 |
| http_request_payload_type | String | No        |         | Content-type of HTTP request payload |
| selector                  | String | Yes       |         | `jr` selector                        |

## Examples

**ThreatFox**

```yaml
analyzer: feed
query: "https://threatfox-api.abuse.ch/api/v1/"
http_request_method: "POST"
http_request_payload:
  query: "get_iocs"
  days: 1
http_request_payload_type: "application/json"
http_request_headers:
  "api-key": "YOUR_API_KEY"
selector: "map(&:data).unwrap.map(&:ioc).map { |v| v.start_with?('http://', 'https://') ? v :  v.split(':').first }"
```

**URLhaus**

```yaml
analyzer: feed
query: "https://urlhaus.abuse.ch/feeds/country/JP/"
selector: "map { |v| v[1] }"
```

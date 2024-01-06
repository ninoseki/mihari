# Webhook

This emitter creates an HTTP request payload based on the specified conditions.

```yaml
emitter: webhook
url: ...
method: ...
headers: ...
template: ...
```

## Components

### URL

`url` (`string`) is a webhook URL.

### Method

`method` (`string`)is an HTTP method. Optional. Defaults to `POST`.

### Headers

`headers` (`hash`) are HTTP headers. Optional.

### Template

`template` (`string`) is a [Jbuilder](https://github.com/rails/jbuilder) template string (or a path to a Jbuilder template file) to customize JSON payload to send.

You can use the following attributes inside a JBuilder template.

- `rule`: a rule (= `Mihari::Rule`)
- `artifacts`: a list of artifacts (= `Array<Mihari::Models::Artifact>`)

## Examples

### ThreatFox

```yaml
- emitter: webhook
  url: https://threatfox-api.abuse.ch/api/v1/
  headers:
    api-key: YOUR_API_KEY
  template: /path/to/threatfox.json.jbuilder
```

**threatfox.json.jbuilder**

```ruby
json.query "submit_ioc"
json.threat_type  "payload_delivery"
json.ioc_type "domain"
json.malware "foobar"
json.confidence_level 100
json.anonymous 0
json.iocs artifacts.map(&:data)
```

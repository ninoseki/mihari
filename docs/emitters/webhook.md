# Webhook

This emitter creates an HTTP request with a JSON body based on the specified conditions.

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

`template` (`string`) is a [Jbuilder](https://github.com/rails/jbuilder) template string (or a path to a Jbuilder template file) to customize a JSON body to send.

You can use the following attributes inside a Jbuilder template.

| Key         | Type                              | Desc.               |
| ----------- | --------------------------------- | ------------------- |
| `rule`      | `Mihari::Rule`                    | A rule              |
| `artifacts` | `Array[Mihari::Models::Artifact]` | A list of artifacts |

## Examples

### ThreatFox

```yaml
- emitter: webhook
  url: https://threatfox-api.abuse.ch/api/v1/
  headers:
    auth-key: YOUR_AUTH_KEY
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

!!! warning

    With great power comes great responsibility.

    Jbuilder can execute anything with the same privilege Mihari has. Do not use untrusted template.

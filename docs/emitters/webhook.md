# Webhook

This emitter creates an HTTP request payload based on the specified conditions.

```yaml
emitter: webhook
url: ...
method: ...
headers: ...
template: ...
```

| Name     | Type   | Required? | Default | Desc.                                                |
| -------- | ------ | --------- | ------- | ---------------------------------------------------- |
| url      | String | Yes       |         | URL                                                  |
| method   | String | No        | POST    | HTTP request method (GET or POST)                    |
| headers  | Hash   | No        |         | HTTP request headers                                 |
| template | String | No        |         | ERB template to customize the payload in JSON format |

You can customize the payload by using **template**.

A template is an ERB template. It should generate a valid JSON.

- [https://github.com/ruby/erb](https://github.com/ruby/erb)

You can use the following variables to build the JSON.

| Name        | Type                    | Default | Desc.        |
| ----------- | ----------------------- | ------- | ------------ |
| title       | String                  |         |              |
| description | String                  |         |              |
| source      | String                  |         | ID of a rule |
| tags        | Array<String>           | []      |              |
| artifacts   | Array<Mihari::Artifact> |         |              |

## Example

**ThreatFox**

```yaml
- emitter: webhook
  url: https://threatfox-api.abuse.ch/api/v1/
  headers:
    api-key: YOUR_API_KEY
  template: threatfox.erb
```

```ruby
{
	"query": "submit_ioc",
	"threat_type": "payload_delivery",
	"ioc_type": "ip:port",
	"malware": "foobar",
	"confidence_level": 100,
	"anonymous": 0,
	"iocs": [
		<% @artifacts.select { |artifact| artifact.data_type == "ip" }.each_with_index do |artifact, idx| %>
			"<%= artifact.data %>:80"
			<%= ',' if idx < (@artifacts.length - 1) %>
		<% end %>
	]
}
```

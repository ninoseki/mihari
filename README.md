# mihari

[![Build Status](https://travis-ci.org/ninoseki/mihari.svg?branch=master)](https://travis-ci.org/ninoseki/mihari)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/mihari/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/mihari?branch=master)

mihari(`見張り`) is a framework for continuous malicious hosts (C2 / landing page / phishing, etc.) monitoring backended with [TheHive](https://github.com/TheHive-Project/TheHive).

## How it works

- mihari checks whether a TheHive instance contains a given artifact or not.
  - If it doesn't contain a given artifact:
    - mihari creates an alert on the TheHive instance.
    - mihari sends a notification to Slack. (Optional)

## Installation

```bash
gem install mihari
```

## Configuration

All configuration is done via ENV variables.

| Key                  | Desc.              | Required or optional           |
|----------------------|--------------------|--------------------------------|
| THEHIVE_API_ENDPOINT | TheHive URL        | Required                       |
| THEHIVE_API_KEY      | TheHive API key    | Required                       |
| SLACK_WEBHOOK_URL    | Slack Webhook URL  | Optional                       |
| SLACK_CHANNEL        | Slack channel name | Optional (default: `#general`) |

## Basic usage

### Censys

```bash
mihari censys "YOUR_QUERY"
```

### Import from JSON

```bash
echo '{ "title": "test", "description": "test", "artifacts": ["1.1.1.1", "github.com", "2.2.2.2"] }' | mihari import_from_json
```

The input is a JSON data should have `title`, `description` and `artifacts` key.

```json
{
  "title": "test",
  "description": "test",
  "artifacts": ["1.1.1.1", "github.com"]
}
```

| Key         | Desc.                                                                      |
|-------------|----------------------------------------------------------------------------|
| title       | A title of an alert                                                        |
| description | A description of an alert                                                  |
| artifacts   | An array of artifacts (supported data types: ip, domain, url, email, hash) |

## How to create a custom analyzer

Create a class which extends `Mihari::Analyzers::Base` and implements the following methods.

| Name           | Desc.                                                                      | @return       |
|----------------|----------------------------------------------------------------------------|---------------|
| `#title`       | A title of an alert                                                        | String        |
| `#description` | A description of an alert                                                  | String        |
| `#artifacts`   | An array of artifacts (supported data types: ip, domain, url, email, hash) | Array<String> |

```ruby
require "mihari"

module Mihari
  module Analyzers
    class Example < Base
      def title
        "example"
      end

      def description
        "example"
      end

      def artifacts
        ["9.9.9.9", "example.com"]
      end
    end
  end
end

example = Mihari::Analyzers::Example.new
example.run
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

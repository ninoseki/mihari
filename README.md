# mihari

mihari(`見張り`) is a framework for continuous malicious hosts (C2 / landing page / phishing, etc.) monitoring backended with [TheHive](https://github.com/TheHive-Project/TheHive).

## How it works

- mihari checks whether a TheHive instance contains a given artifact or not.
  - If it doesn't contain a given artifact:
    - mihari creates an alert on the TheHive instance.
    - mihari sends a notifiaction to Slack. (optional)

## Installation

```bash
gem install mihari
```

## Basic usage

### Input

The input is a JSON data should have `title`, `description` and `artifacts` key.

```json
{
  "title": "test",
  "description": "test",
  "artifacts": ["1.1.1.1", "github.com"]
}
```

| Key         | Desc.                                                                     |
|-------------|---------------------------------------------------------------------------|
| title       | A title of an alert                                                       |
| description | A description of an alert                                                 |
| artifacts   | AN array of artifacts. Supported data types: ip, domain, url, email, hash |

```bash
$ echo '{ "title": "test", "description": "test", "artifacts": ["1.1.1.1", "github.com"] }' | mihari
A new alret is created: id = 7585e892636419a25af2a327ae14c91b
```

## How to create a custom analyzer

Create a class which:

- extends `Mihari::Analyzer`
- implements the following methods:
  - `#title`
  - `#description`
  - `#artifacts`

```ruby
require "mihari"

module Mihari
  class ExampleAnalyzer < Analyzer
    def title
      "example"
    end

    def description
      "example"
    end

    def artifacts
      [
        Aritfact.new("9.9.9.9"),
        Artifact.new("example.com")
      ]
    end
  end
end

example_analyzer = Mihari::ExampleAnalyzer.new
example_analyzer.run
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

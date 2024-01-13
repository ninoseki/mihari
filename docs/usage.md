# Usage

## CLI

```bash
$ mihari
Commands:
  mihari --version, -v        # Print the version
  mihari alert                # Sub commands for alert
  mihari artifact             # Sub commands for artifact
  mihari config               # Sub commands for config
  mihari db                   # Sub commands for DB
  mihari help [COMMAND]       # Describe available commands or one specific command
  mihari rule                 # Sub commands for rule
  mihari search [PATH_OR_ID]  # Search by a rule
  mihari sidekiq              # Start Sidekiq
  mihari tag                  # Sub commands for tag
  mihari web                  # Start the web app

Options:
  -d, [--debug], [--no-debug]  # Set up debug mode
```

### `mihari alert`

```bash
$ mihari alert
Commands:
  mihari alert create PATH                                   # Create an alert
  mihari alert delete ID                                     # Delete an alert
  mihari alert get ID                                        # Get an alert
  mihari alert help [COMMAND]                                # Describe subcommands or one specific subcommand
  mihari alert list QUERY                                    # List/search alerts
  mihari alert list-transform QUERY -t, --template=TEMPLATE  # List/search alerts with transformation
```

### `mihari artifact`

```bash
$ mihari artifact
Commands:
  mihari artifact delete ID                                     # Delete an artifact
  mihari artifact enrich ID                                     # Enrich an artifact
  mihari artifact get ID                                        # Get an artifact
  mihari artifact help [COMMAND]                                # Describe subcommands or one specific subcommand
  mihari artifact list QUERY                                    # List/search artifacts
  mihari artifact list-transform QUERY -t, --template=TEMPLATE  # List/search artifacts with transformation
```

!!! note

### `mihari db`

This subcommand is for initializing/migrating database.

```bash
$ mihari db
Commands:
  mihari db help [COMMAND]  # Describe subcommands or one specific subcommand
  mihari db migrate         # Migrate DB schemas
```

See [Database](./emitters/database.md) for detailed database configuration.

### `mihari rule`

```bash
$ mihari rule
Commands:
  mihari rule delete ID                                     # Delete a rule
  mihari rule get ID                                        # Get a rule
  mihari rule help [COMMAND]                                # Describe subcommands or one specific subcommand
  mihari rule init PATH                                     # Initialize a new rule file
  mihari rule list QUERY                                    # List/search rules
  mihari rule list-transform QUERY -t, --template=TEMPLATE  # List/search rules with transformation
  mihari rule search PATH_OR_ID                             # Search by a rule
  mihari rule validate PATH                                 # Validate a rule file
```

### `mihari search`

This is a command to execute a rule. A shorthand for `mihari rule search`.

```bash
mihari search /path/to/rule.yml
```

Mihari asks whether really you want to update a rule if there is a diff by default.

```bash
$ mihari search /path/to/rule.yml
Are you sure you want to overwrite this rule? (y/n)
```

It can be suppressed by providing `-f`.

```bash
mihari search -f /path/to/rule.yml
```

### `mihari tag`

```bash
$ mihari tag
Commands:
  mihari tag delete ID                                     # Delete a tag
  mihari tag help [COMMAND]                                # Describe subcommands or one specific subcommand
  mihari tag list QUERY                                    # List/search tags
  mihari tag list-transform QUERY -t, --template=TEMPLATE  # List/search tags with transformation
```

### `mihari web`

This command is for starting the built-in web app.

```bash
mihari web
```

It stars the app with `localhost:9292`. You can configure it by providing following options:

```bash
$ mihari help web
Usage:
  mihari web

Options:
      [--port=N]                   # Port to listen on
                                   # Default: 9292
      [--host=HOST]                # Hostname to listen on
                                   # Default: localhost
      [--threads=THREADS]          # min:max threads to use
                                   # Default: 0:5
      [--verbose], [--no-verbose]  # Don't report each request
                                   # Default: false
      [--worker-timeout=N]         # Worker timeout value (in seconds)
                                   # Default: 60
      [--open], [--no-open]        # Whether to open the app in browser or not
                                   # Default: true
      [--env=ENV]                  # Environment
                                   # Default: production
  -d, [--debug], [--no-debug]      # Set up debug mode
```

!!! tip

    The built-in web app offers API to interact with Mihari.
    The API docs are available on `/redoc-static.html`.

### `mihari sidekiq`

This command is for starting Sidekiq. See [Sidekiq](./tips/sidekiq.md) for details.

```bash
$ mihari help sidekiq
Usage:
  mihari sidekiq

Options:
      [--env=ENV]              # Environment
                               # Default: production
  -c, [--concurrency=N]        # Sidekiq concurrency
                               # Default: 5
```

## Hints

### Search

Mihari provides listing/search feature via CLI & API.

Search query supports `AND`, `OR`, `:`, `=`, `!=`, `<`, `<=`, `>`, `>=`, `NOT` and `()`.

Searchable fields are:

| Type       | Searchable fields                                                                                                                                                                                                                    |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `alert`    | `id`, `tag`, `created_at`, `rule.id`, `rule.title`, `rule.description`, `artifact.data`, `artifact.data_type`, `artifact.source` and `artifact.query`                                                                                |
| `artifact` | `id`, `data`, `data_type`, `source`, `query`, `tag`, `rule.id`, `rule.title`, `rule.description`, `tag`,`created_at`, `asn`, `country_code`, `dns_record.value`, `dns_record.resource`, `reverse_dns_name`, `cpe`, `vuln` and `port` |
| `rule`     | `id`, `title`, `description`, `tag`, `created_at` and `updated_at`                                                                                                                                                                   |
| `tag`      | `id` and `name`                                                                                                                                                                                                                      |

**Examples**

```bash
mihari rule list "description:foo OR title:bar"
mihari alert list "rule.id:foo"
mihari artifact list "rule.id: foo AND data_type:ip"
```

### Search With Transformation

Additionally you can search rules, alerts and artifacts with transformation by using [Jbuilder](https://github.com/rails/jbuilder).

```bash
mihari rule list-transform -t /path/to/template
mihari alert list-transform -t /path/to/template
mihari artifact list-transform -t /path/to/template
```

For example, you can combine IP addresses and ports by using the following template.

**ip_port.json.jbuilder**

```ruby
artifacts = results.map(&:artifacts).flatten

ip_ports = artifacts.map do |artifact|
  artifact.ports.map do |port|
    "#{artifact.data}:#{port.port}"
  end
end.flatten

json.array! ip_ports
```

```bash
mihari artifact list-transform -t /path/to/ip_port.json.jbuilder
```

A template can use the following attributes.

| Key            | Type                                                                                                                             | Desc.                            |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `results`      | `Array[Mihari::Models::Rule]`, `Array[Mihari::Models::Alert]`, `Array[Mihari::Models::Artifact]` or `Array[Mihari::Models::Tag]` | A list of search results         |
| `total`        | Integer                                                                                                                          | A total number of search results |
| `page_size`    | Integer                                                                                                                          | A page size                      |
| `current_page` | Integer                                                                                                                          | A current page number            |

!!! warning

    With great power comes great responsibility.

    Jbuilder can execute anything with the same privilege Mihari has. Do not use untrusted template.

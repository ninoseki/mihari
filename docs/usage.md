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
  mihari delete [ID]          # Delete a tag
  mihari enrich [ID]          # Enrich an artifact
  mihari get [ID]             # Get an artifact
  mihari help [COMMAND]       # Describe available commands or one specific command
  mihari list                 # List/search tags
  mihari rule                 # Sub commands for rule
  mihari search [PATH_OR_ID]  # Search by a rule (Outputs null if there is no new finding)
  mihari tag                  # Sub commands for tag
  mihari web                  # Launch the web app

Options:
  -d, [--debug], [--no-debug]  # Sets up debug mode
```

## `mihari alert`

```bash
$ mihari alert
Commands:
  mihari alert create [PATH]   # Create an alert
  mihari alert delete [ID]     # Delete an alert
  mihari alert get [ID]        # Get an alert
  mihari alert help [COMMAND]  # Describe subcommands or one specific subcommand
  mihari alert list [QUERY]    # List/search alerts
```

## `mihari artifact`

```bash
$ mihari artifact
Commands:
  mihari artifact delete [ID]     # Delete an artifact
  mihari artifact enrich [ID]     # Enrich an artifact
  mihari artifact get [ID]        # Get an artifact
  mihari artifact help [COMMAND]  # Describe subcommands or one specific subcommand
  mihari artifact list [QUERY]    # List/search artifac
```

!!! note

## `mihari db`

This subcommand is for initializing/migrating database.

```bash
$ mihari db
Commands:
  mihari db help [COMMAND]  # Describe subcommands or one specific subcommand
  mihari db migrate         # Migrate DB schemas
```

See [Database](./emitters/database.md) for detailed database configuration.

## `mihari rule`

```bash
$ mihari rule
Commands:
  mihari rule delete [ID]      # Delete a rule
  mihari rule get [ID]         # Get a rule
  mihari rule help [COMMAND]   # Describe subcommands or one specific subcommand
  mihari rule init [PATH]      # Initialize a new rule file
  mihari rule list [QUERY]     # List/search rules
  mihari rule validate [PATH]  # Validate a rule file
```

## `mihari search`

This is a command for running a rule.

```bash
mihari search /path/to/rule.yml
```

Mihari asks whether really you want to update a rule if there is a diff by default.

```bash
$ mihari search /path/to/rule.yml
There is a diff in the rule. Are you sure you want to overwrite the rule? (y/n)
```

It can be suppressed by providing `-f`.

```bash
mihari search -f /path/to/rule.yml
```

## `mihari tag`

```bash
$ mihari tag                                                                                                                                 20:31:05
Commands:
  mihari tag delete [ID]     # Delete a tag
  mihari tag help [COMMAND]  # Describe subcommands or one specific subcommand
  mihari tag list            # List/search tags
```

## `mihari web`

This command is for launching the built-in web app.

```bash
mihari web
```

It stars the app with `localhost:9292`. You can configure it by providing following options:

```bash
$ mihari help web
Usage:
  mihari web

Options:
  [--port=N]                                         # Hostname to listen on
                                                     # Default: 9292
  [--host=HOST]                                      # Port to listen on
                                                     # Default: localhost
  [--threads=THREADS]                                # min:max threads to use
                                                     # Default: 0:5
  [--verbose], [--no-verbose]                        # Report each request
                                                     # Default: true
  [--worker-timeout=N]                               # Worker timeout value (in seconds)
                                                     # Default: 60
  [--open], [--no-open]                              # Whether to open the app in browser or not
                                                     # Default: true
  [--rack-env=RACK_ENV]                              # Rack environment
                                                     # Default: production
```

!!! tip

    The built-in web app offers API to interact with Mihari.
    The API docs are available on `/redoc-static.html`

## Search

Mihari provides listing/search feature via CLI & API.

Search query supports `AND`, `OR`, `:`, `=`, `!=`, `<`, `<=`, `>`, `>=`, `NOT` and `()`.

Searchable fields are

| Type       | Searchable fields                                                                                                                                                   |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `alert`    | `id`, `tag`, `created_at`, `updated_at`, `rule.id`, `rule.title`, `rule.description`, `artifact.data`, `artifact.data_type`, `artifact.source` and `artifact.query` |
| `artifact` | `id`, `data`, `data_type`, `source`, `query`, `tag`, `rule.id`, `rule.title`, `rule.description`, `tag`, `created_at` and `updated_at`                              |
| `rule`     | `id`, `title`, `description`, `tag`, `created_at` and `updated_at`                                                                                                  |
| `tag`      | `id` and `name`                                                                                                                                                     |

## Examples

```bash
mihari alert list "rule.id:foo"
mihari artifact list "rule.id: foo AND data_type:ip"
mihari rule list "description:foo OR title:bar"
```

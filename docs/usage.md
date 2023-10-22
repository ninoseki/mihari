# Usage

```bash
$ mihari
Commands:
  mihari --version, -v        # Print the version
  mihari alert                # Sub commands for alert
  mihari db                   # Sub commands for DB
  mihari help [COMMAND]       # Describe available commands or one specific command
  mihari rule                 # Sub commands for rule
  mihari search [PATH_OR_ID]  # Search by a rule (Outputs null if there is no new finding)
  mihari web                  # Launch the web app

Options:
  -d, [--debug], [--no-debug]  # Sets up debug mode
```

## `mihari db`

This sub command is for initializing/migrating database.

```bash
mihari db migrate
```

See [Database](./emitters/database.md) for detailed database configuration.

## `mihari rule`

This sub command is for validating/initializing a rule.

```bash
mihari rule init /path/to/rule.yml
mihari rule validate /path/to/rule.yml
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

## `mihari add`

You may want to add an alert manually. You can do that by this command.

```bash
mihari alert /path/to/alert.yml
```

## `mihari web`

This command is for launching the built-in web app.

```bash
mihari web
```

It stars the app with `localhost:9292`. You can configure it by providing options.

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
  [--hide-config-values], [--no-hide-config-values]  # Whether to hide config values or not
                                                     # Default: true
  [--open], [--no-open]                              # Whether to open the app in browser or not
                                                     # Default: true
  [--rack-env=RACK_ENV]                              # Rack environment
                                                     # Default: production
```

!!! tip

    The built-in web app offers API to interact with Mihari.
    The API docs are available on `/redoc-static.html`

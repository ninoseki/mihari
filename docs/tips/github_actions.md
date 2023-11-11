# GitHub Actions

GitHub Actions is a good way to run Mihari searches continuously.

The following is an example of a GitHub Actions workflow to run Mihari.

```yaml
name: Mihari searches

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install dependencies
        run: sudo apt-get -yqq install sqlite3 libsqlite3-dev
      - name: Set up Ruby 3.2
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.2"
          bundler-cache: true
      - name: Run Mihari
        run: |
          mihari search /path/to/rule.yml
```

!!! tip

    You need to install `libpq-dev` for PostgreSQL, `libmysqlclient-dev` for MySQL.

This example assumes that you have `Gemfile` in your repository.

```ruby
source "https://rubygems.org"

gem "pg"     # if you use PostgresSQL
gem "mysql2" # if you use MySQL

gem "mihari"
```

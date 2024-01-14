# Installation

Mihari is packaged as a Ruby Gem. Thus you can install it via `gem` command.

```bash
gem install mihari
```

Mihari uses SQLite3 as a primary database by default. Thus a gem for SQLite (`sqlite3`) is installed by default.

If you want to use MySQL or PostgreSQL instead of SQLite3, please install a gem for that by yourself.

**MySQL**

```bash
gem install mysql2
```

!!! note

    - Mihari is tested with `mysql2` v0.5+.
    - Please check [brianmario/mysql2](https://github.com/brianmario/mysql2) if you have a problem with installing `mysql2`.

**PostgreSQL**

```bash
gem install pg
```

!!! note

    - Mihari is tested with `pg` v1.5+.
    - Please check [ged/ruby-pg](https://github.com/ged/ruby-pg) if you have a problem with installing `pg`.

## With Bundler

Alternatively you can use [Bundler](https://bundler.io/) to manage dependencies.

**Gemfile**

```ruby
source 'https://rubygems.org'

gem 'mihari'

# Remove mysql2 or pg if you don't use MySQL or PostgreSQL
gem "mysql2", "~> 0.5"
gem "pg", "~> 1.5"
```

`mihari` and `mysql2` or `pg` will be installed by `bundle install`.

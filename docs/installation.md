# Installation

## Ruby Gem

Mihari is packaged as a Ruby Gem.

```bash
gem install mihari
```

Mihari uses SQLite3 as a primary database by default. Thus a gem for SQLite (`sqlite3`) is installed by default.

If you want to use MySQL or PostgreSQL instead of SQLite3, please install a gem for that by yourself.

**MySQL**

```bash
gem install mysql2
```

**PostgreSQL**

```bash
gem install pg
```

# Docker

You can built the Docker image by yourself.

`Dockerfile` is available at [https://github.com/ninoseki/mihari/tree/master/docker](https://github.com/ninoseki/mihari/tree/master/docker).

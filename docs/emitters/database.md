# Database

This emitter stores data in a database. This emitter uses SQLite3 by default but you can change to use MySQL or PostgreSQL. The database is a primary database of Mihari. Each data generated by Mihari is stored in the database. You can view the data via the built-in web app.

```yaml
emitter: database
```

!!! note

    You have to initialize the database by `mihari db migrate`.

## Components

### Database URL

`database_url` (`string`) is a database URL. Defaults to `sqlite3:mihari.db`. Configurable via `DATABASE_URL` environment variable.

If you want to use MySQL or PostgreSQL, please set a database URL for that.

- MySQL: `mysql2://username:password@host:port/database` (+ `gem install mysql2`)
- PostgreSQL: `postgres://username:password@host:port/database` (+ `gem install pg`)

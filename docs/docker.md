# Docker

You can use Mihari with Docker Compose.

```bash
git clone https://github.com/ninoseki/mihari
cd mihari/docker
docker compose up -d
```

Mihari's web app is running at `localhost:9292`.

!!! note

    - PostgreSQL is used as a database.
    - `.env` file is used for configuring environment variables.

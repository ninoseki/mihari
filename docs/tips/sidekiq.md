# Sidekiq

You can offload a time-consuming task (e.g, searching by a rule) to [Sidekiq](https://github.com/sidekiq/sidekiq) in the web app.

Mihari executes a search inside the web app by default. In this case, a search may fail due to a request timeout error. Sidekiq can solve this problem.

More specifically, the following API endpoints use Sidekiq when Sidekiq is running.

- `POST /api/rules/:id/search`
- `POST /api/artifacts/:id/enrich`

!!! note

    Please make sure that you have a running Redis & `REDIS_URL` environment variable is set.

```bash
# Start Sidekiq
$ mihari sidekiq
# Then the web app is able to use Sidekiq
$ mihari web
```

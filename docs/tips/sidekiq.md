# Sidekiq

You can offload a time-consuming task (searching by a rule) to [Sidekiq](https://github.com/sidekiq/sidekiq) in the web app.

Mihari executes a search inside the web app by default. In this case, a search may fail due to a request timeout error. Sidekiq can solve this problem.

!!! note

    Please make sure that you have a running Redis & `REDIS_URL` environment variable is set.

```bash
# Start Sidekiq
$ mihari sidekiq
# Then the web app is able to use Sidekiq
$ mihari web
```

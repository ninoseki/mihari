# Configuration

Configuration can be done via environment variables.

Alternatively you can set values through `.env` file. Values in `.env` file will be automatically loaded.

## Analyzers, Emitters And Enrichers

| Environment Variable   | Description                    | Default             |
| ---------------------- | ------------------------------ | ------------------- |
| BINARYEDGE_API_KEY     | BinaryEdge API key             |                     |
| CENSYS_ID              | Censys API ID                  |                     |
| CENSYS_SECRET          | Censys secret                  |                     |
| CIRCL_PASSIVE_PASSWORD | CIRCL passive DNS/SSL password |                     |
| CIRCL_PASSIVE_USERNAME | CIRCL passive DNS/SSL username |                     |
| DATABASE_URL           | Database URL                   | `sqlite3:mihari.db` |
| IPINFO_API_KEY         | IPInfo API key (token)         |                     |
| MISP_API_KEY           | MISP API key                   |                     |
| MISP_URL               | MISP URL                       |                     |
| ONYPHE_API_KEY         | Onyphe API key                 |                     |
| OTX_API_KEY            | OTX API key                    |                     |
| PASSIVETOTAL_API_KEY   | PassiveTotal API key           |                     |
| PASSIVETOTAL_USERNAME  | PassiveTotal username          |                     |
| PULSEDIVE_API_KEY      | Pulsedive API key              |                     |
| SECURITYTRAILS_API_KEY | SecurityTrails API key         |                     |
| SHODAN_API_KEY         | Shodan API key                 |                     |
| SLACK_CHANNEL          | Slack channel name             | `#general`          |
| SLACK_WEBHOOK_URL      | Slack Webhook URL              |                     |
| THEHIVE_API_KEY        | TheHive API key,               |                     |
| THEHIVE_URL            | TheHive URL                    |                     |
| URLSCAN_API_KEY        | urlscan.io API key             |                     |
| VIRUSTOTAL_API_KEY     | VirusTotal API key             |                     |
| ZOOMEYE_API_KEY        | ZoomEye API key                |                     |

## Others

| Environment Variable      | Description                               | Default                  |
| ------------------------- | ----------------------------------------- | ------------------------ |
| HIDE_CONFIG_VALUES        | Whether to hide config values from output | `true`                   |
| IGNORE_ERROR              | Whether to ignore error while querying    | `false`                  |
| PAGINATION_INTERVAL       | Pagination interval                       | `0`                      |
| PAGINATION_LIMIT          | Pagination limit                          | `100`                    |
| PARALLEL                  | Whether to run queries in parallel        | `false`                  |
| REDIS_URL                 | Redis URL for Sidekiq                     | `redis://localhost:6379` |
| RETRY_EXPONENTIAL_BACKOFF | Retry exponential back off                | `true`                   |
| RETRY_INTERVAL            | Retry interval                            | `5`                      |
| RETRY_TIMES               | Retry times                               | `3`                      |
| SENTRY_DSN                | Sentry DSN                                |                          |
| SENTRY_TRACE_SAMPLE_RATE  | Sentry trace sample rate                  | `0.25`                   |

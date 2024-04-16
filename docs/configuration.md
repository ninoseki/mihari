# Configuration

Configuration can be done via environment variables.

Alternatively you can set values through `.env` file. Values in `.env` file will be automatically loaded.

## Analyzers

| Environment Variable   | Type   | Description                    | Default |
| ---------------------- | ------ | ------------------------------ | ------- |
| BINARYEDGE_API_KEY     | String | BinaryEdge API key             |         |
| CENSYS_ID              | String | Censys API ID                  |         |
| CENSYS_SECRET          | String | Censys secret                  |         |
| CIRCL_PASSIVE_PASSWORD | String | CIRCL passive DNS/SSL password |         |
| CIRCL_PASSIVE_USERNAME | String | CIRCL passive DNS/SSL username |         |
| ONYPHE_API_KEY         | String | Onyphe API key                 |         |
| OTX_API_KEY            | String | OTX API key                    |         |
| PASSIVETOTAL_API_KEY   | String | PassiveTotal API key           |         |
| PASSIVETOTAL_USERNAME  | String | PassiveTotal username          |         |
| PULSEDIVE_API_KEY      | String | Pulsedive API key              |         |
| SECURITYTRAILS_API_KEY | String | SecurityTrails API key         |         |
| SHODAN_API_KEY         | String | Shodan API key                 |         |
| URLSCAN_API_KEY        | String | urlscan.io API key             |         |
| VALIDIN_API_KEY        | String | Validin API key                |         |
| VIRUSTOTAL_API_KEY     | String | VirusTotal API key             |         |
| ZOOMEYE_API_KEY        | String | ZoomEye API key                |         |

## Emitters

| Environment Variable | Type   | Description        | Default             |
| -------------------- | ------ | ------------------ | ------------------- |
| DATABASE_URL         | String | Database URL       | `sqlite3:mihari.db` |
| MISP_API_KEY         | String | MISP API key       |                     |
| MISP_URL             | String | MISP URL           |                     |
| SLACK_CHANNEL        | String | Slack channel name | `#general`          |
| SLACK_WEBHOOK_URL    | String | Slack Webhook URL  |                     |
| THEHIVE_API_KEY      | String | TheHive API key,   |                     |
| THEHIVE_URL          | String | TheHive URL        |                     |

!!! tip

    A typical form of a database URL is `dialect+driver://username:password@host:port/database`. See [Database](./emitters/database.md) for details.

## General Analyzers/Enrichers/Emitters Options

| Environment Variable      | Type    | Description                               | Default |
| ------------------------- | ------- | ----------------------------------------- | ------- |
| ANALYZER_PARALLELISM      | Boolean | Whether to run analyzers in parallel      | `false` |
| EMITTER_PARALLELISM       | Boolean | Whether to run emitters in parallel       | `true`  |
| IGNORE_ERROR              | Boolean | Whether to ignore error while querying    | `false` |
| PAGINATION_INTERVAL       | Integer | Pagination interval                       | `0`     |
| PAGINATION_LIMIT          | Integer | Pagination limit                          | `100`   |
| RETRY_EXPONENTIAL_BACKOFF | Boolean | Whether to use retry exponential back off | `true`  |
| RETRY_INTERVAL            | Integer | Retry interval                            | `5`     |
| RETRY_TIMES               | Integer | Retry times                               | `3`     |

## Sidekiq

| Environment Variable | Type   | Description           | Default |
| -------------------- | ------ | --------------------- | ------- |
| SIDEKIQ_REDIS_URL    | String | Redis URL for Sidekiq |         |

!!! tip

    A typical form of a Redis URL is `redis://username:password@host:port`. (e.g. `redis://localhost:6379`)

## Others

| Environment Variable     | Type    | Description                               | Default |
| ------------------------ | ------- | ----------------------------------------- | ------- |
| HIDE_CONFIG_VALUES       | Boolean | Whether to hide config values from output | `true`  |
| SENTRY_DSN               | String  | Sentry DSN                                |         |
| SENTRY_TRACE_SAMPLE_RATE | Float   | Sentry trace sample rate                  | `0.25`  |

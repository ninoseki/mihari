# Configuration

Configuration can be done via environment variables.

| Environmental Variable | Description                     | Default              |
| ---------------------- | ------------------------------- | -------------------- |
| DATABASE_URL           | Database URL                    | sqlite3:///mihari.db |
| BINARYEDGE_API_KEY     | BinaryEdge API key              |                      |
| CENSYS_ID              | Censys API ID                   |                      |
| CENSYS_SECRET          | Censys secret                   |                      |
| CIRCL_PASSIVE_PASSWORD | CIRCL passive DNS/SSL password  |                      |
| CIRCL_PASSIVE_USERNAME | CIRCL passive DNS/SSL username, |                      |
| IPINFO_API_KEY         | IPInfo API key (token)          |                      |
| MISP_URL               | MISP URL                        |                      |
| MISP_API_KEY           | MISP API key                    |                      |
| ONYPHE_API_KEY         | Onyphe API key                  |                      |
| OTX_API_KEY            | OTX API key                     |                      |
| PASSIVETOTAL_API_KEY   | PassiveTotal API key            |                      |
| PASSIVETOTAL_USERNAME  | PassiveTotal username           |                      |
| PULSEDIVE_API_KEY      | Pulsedive API key               |                      |
| SECURITYTRAILS_API_KEY | SecurityTrails API key          |                      |
| SHODAN_API_KEY         | Shodan API key                  |                      |
| SLACK_CHANNEL          | Slack channel name              | #general             |
| SLACK_WEBHOOK_URL      | Slack Webhook URL               |                      |
| THEHIVE_URL            | TheHive URL,                    |                      |
| THEHIVE_API_KEY        | TheHive API key,                |                      |
| URLSCAN_API_KEY        | urlscan.io API key,             |                      |
| VIRUSTOTAL_API_KEY     | VirusTotal API key              |                      |
| ZOOMEYE_API_KEY        | ZoomEye API key                 |                      |
| SENTRY_DSN             | Sentry DSN                      |                      |
| RETRY_INTERVAL         | Retry interval                  | 5                    |
| RETRY_TIMES            | Retry times                     | 3                    |
| PAGINATION_LIMIT       | Pagination limit                | 100                  |

Or you can set values through `.env` file. Values in `.env` file will be automatically loaded.

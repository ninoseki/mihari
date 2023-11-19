# Slack

- [https://slack.com/](https://slack.com/intl/ja-jp/)

This emitter post a message to Slack via incoming webhook.

```yaml
emitter: slack
webhook_url: ...
channel: ...
```

## Components

### Webhook URL

`url` (`string`) is a Slack's incoming webhook URL. Optional. Configurable via `SLACK_WEBHOOK_URL` environment variable.

### Channel

`channel` (`string`) is a Slack channel to post a message. Defaults to `#general`. Configurable via `SLACK_CHANNEL` environment variable.

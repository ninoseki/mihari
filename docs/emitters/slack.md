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

`url` (`string`) is a Slack's incoming webhook URL. Optional. Defaults to `ENV[SLACK_WEBHOOK_URL]`.

### API Key

`channel` (`string`) is a Slack channel to sent a message. Optional. Defaults to `ENV[SLACK_CHANNEL]` or `#general`.

# Slack

- [https://slack.com/](https://slack.com/intl/ja-jp/)

This emitter post a message to Slack via incoming webhook.

```yaml
emitter: slack
webhook_url: ...
channel: ...
```

| Name        | Type   | Required? | Default                         | Desc.             |
| ----------- | ------ | --------- | ------------------------------- | ----------------- |
| webhook_url | String | No        | ENV[SLACK_WEBHOOK_URL]          | Slack webhook URL |
| channel     | String | No        | ENV[SLACK_CHANNEL] / `#general` | Slack channel     |

## Components

### Webhook URL

`url` is a Slack's incoming webhook URL. Optional. Defaults to `ENV[SLACK_WEBHOOK_URL]`.

### API Key

`channel` is a Slack channel to sent a message. Optional. Defaults to `ENV[SLACK_CHANNEL]` or `#general`.

# mihari

[![Gem Version](https://badge.fury.io/rb/mihari.svg)](https://badge.fury.io/rb/mihari)
[![Build Status](https://travis-ci.org/ninoseki/mihari.svg?branch=master)](https://travis-ci.org/ninoseki/mihari)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ninoseki/mihari)](https://hub.docker.com/r/ninoseki/mihari)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/mihari/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/mihari?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/mihari/badge)](https://www.codefactor.io/repository/github/ninoseki/mihari)

mihari(`見張り`) is a sidekick tool for [TheHive](https://github.com/TheHive-Project/TheHive) for monitoring malicious hosts (C2 / landing page / phishing, etc.) continuously.

## How it works

- mihari makes a query against Shodan, Censys, VirusTotal, SecurityTrails, etc. and extracts artifacts from the results.
- mihari checks whether TheHive contains the artifacts or not.
  - If it doesn't contain the artifacts:
    - mihari creates an alert on TheHive.
    - mihari sends a notification to Slack. (Optional)
    - mihari creates an event on MISP. (Optional)

![img](https://github.com/ninoseki/mihari/blob/master/screenshots/eyecatch.png)

Check this blog post for more details: [Continuous C2 hunting with Censys, Shodan, Onyphe and TheHive](https://hackmd.io/s/SkUaSrqoE).

You can use mihari without TheHive. But note that mihari depends on TheHive to manage artifacts. It means mihari might make duplications when without TheHive.

### Screenshots

- TheHive alert example

![img](https://github.com/ninoseki/mihari/raw/master/screenshots/alert.png)

- Slack notification example

![img](https://github.com/ninoseki/mihari/raw/master/screenshots/slack.png)

- MISP event example

![img](https://github.com/ninoseki/mihari/raw/master/screenshots/misp.png)

## Installation

```bash
gem install mihari
```

Or you can use this tool with Docker.

```bash
docker pull ninoseki/mihari
```

## Basic usage

mihari supports the following services by default.

- [BinaryEdge](https://www.binaryedge.io/)
- [Censys](http://censys.io)
- [CIRCL passive DNS](https://www.circl.lu/services/passive-dns/) / [passive SSL](https://www.circl.lu/services/passive-ssl/)
- [crt.sh](https://crt.sh/)
- [Onyphe](https://onyphe.io)
- [PassiveTotal](https://community.riskiq.com/)
- [SecurityTrails](https://securitytrails.com/)
- [Shodan](https://shodan.io)
- [urlscan.io](https://urlscan.io)
- [VirusTotal](http://virustotal.com)
- [ZoomEye](https://zoomeye.org)

```bash
$ mihari
Commands:
  mihari alerts                               # Show the alerts on TheHive
  mihari binaryedge [QUERY]                   # BinaryEdge host search by a query
  mihari censys [QUERY]                       # Censys IPv4 search by a query
  mihari circl [DOMAIN|SHA1]                  # CIRCL passive DNS/SSL lookup by a domain / SHA1 certificate fingerprint
  mihari crtsh [QUERY]                        # crt.sh search by a query
  mihari dnpedia [QUERY]                      # DNPedia domain search by a query
  mihari free_text [TEXT]                     # Cross search with search engines by a free text
  mihari help [COMMAND]                       # Describe available commands or one specific command
  mihari http_hash                            # Cross search with search engines by a hash of an HTTP response (SHA256, MD5 and MurmurHash3)
  mihari import_from_json                     # Give a JSON input via STDIN
  mihari onyphe [QUERY]                       # Onyphe datascan search by a query
  mihari passive_dns [IP|Domain]              # Cross search with passive DNS services by an ip / domain
  mihari passive_ssl [SHA1]                   # Cross search with passive SSL services by an SHA1 certificate fingerprint
  mihari passivetotal [IP|DOMAIN|EMAIL|SHA1]  # PassiveTotal lookup by an ip / domain / email / SHA1 certificate fingerprint
  mihari reverse_whois [email]                # Cross search with reverse whois services by an email
  mihari securitytrails [IP|DOMAIN|EMAIL]     # SecurityTrails lookup by an ip, domain or email
  mihari securitytrails_domain_feed [REGEXP]  # SecurityTrails new domain feed search by a regexp
  mihari shodan [QUERY]                       # Shodan host search by a query
  mihari ssh_fingerprint [FINGERPRINT]        # Cross search with search engines by an SSH fingerprint
  mihari status                               # Show the current configuration status
  mihari urlscan [QUERY]                      # urlscan search by a given query
  mihari virustotal [IP|DOMAIN]               # VirusTotal resolutions lookup by an ip or domain
  mihari zoomeye [QUERY]                      # ZoomEye search by a query

```

### Cross searches

mihari has cross search features. A cross search is a search across a number of services.

You can get aggregated results by using the following commands.

| Command         | Desc.                                                                                                   |
| --------------- | ------------------------------------------------------------------------------------------------------- |
| passive_dns     | Passive DNS lookup with CIRCL passive DNS, PassiveTotal, SecurityTrails and VirusTotal                  |
| passive_ssl     | Passive SSL lookup with CIRCL passive SSL and PassiveTotal                                              |
| reverse_whois   | Revese Whois lookup with PassiveTotal and SecurityTrails                                                |
| http_hash       | HTTP response hash lookup with BinaryEdge(SHA256), Censys(SHA256), Onyphpe(MD5) and Shodan(MurmurHash3) |
| free_text       | Free text lookup with BinaryEdge and Censys                                                             |
| ssh_fingerprint | SSH fingerprint lookup with BinaryEdge and Shodan                                                       |

#### http_hash command

The usage of `http_hash` command is little bit tricky.

```bash
$ mihari help http_hash
Usage:
  mihari http_hash

Options:
  [--title=TITLE]              # title
  [--description=DESCRIPTION]  # description
  [--tags=one two three]       # tags
  [--md5=MD5]                  # MD5 hash
  [--sha256=SHA256]            # SHA256 hash
  [--mmh3=N]                   # MurmurHash3 hash

Cross search with search engines by a hash of an HTTP response (SHA256, MD5 and MurmurHash3)

```

There are 2 ways to use this command.

First one is passing `--md5`, `--sha256` and `--mmh3` parameters.

```bash
mihari http_hash --md5=881191f7736b5b8cfad5959ca99d2a51 --sha256=b064187ebdc51721708ad98cd89dacc346017cb0fb0457d530032d387f1ff20e --mmh3=-1467534799
```

Another one is passing `--html` parameter. In this case, hashes of an HTML file are automatically calculated.

````bash
wget http://example.com -O /tmp/index.html
mihari http_hash --html /tmp/index.html
```

### Example usages

```bash
# Censys lookup for PANDA C2
$ mihari censys '("PANDA" AND "SMAdmin" AND "layui")' --title "PANDA C2"
{
  "title": "PANDA C2",
  "description": "query = (\"PANDA\" AND \"SMAdmin\" AND \"layui\")",
  "artifacts": [
    "154.223.165.223",
    "154.194.2.31",
    "45.114.127.119",
    "..."
  ],
  "tags": []
}

# VirusTotal passive DNS lookup of a FAKESPY host
$ mihari virustotal "jppost-hi.top" --title "FAKESPY host passive DNS results"
{
  "title": "FAKESPY host passive DNS results",
  "description": "indicator = jppost-hi.top",
  "artifacts": [
    "185.22.152.28",
    "192.236.200.44",
    "193.148.69.12",
    "..."
  ],
  "tags": []
}

# You can pass a "defanged" indicator as an input
$ mihari virustotal "jppost-hi[.]top" --title "FAKESPY host passive DNS results"

# SecurityTrails domain feed lookup for finding (possibly) Apple phishing websites
$ mihari securitytrails_domain_feed "apple-" --type new
{
  "title": "SecurityTrails domain feed lookup",
  "description": "Regexp = /apple-/",
  "artifacts": [
    "apple-sign.online",
    "apple-log-in.com",
    "apple-locator-id.info",
    "..."
  ],
  "tags": []
}
````

### Import from JSON

```bash
echo '{ "title": "test", "description": "test", "artifacts": ["1.1.1.1", "github.com", "2.2.2.2"] }' | mihari import_from_json
```

The input is a JSON data should have `title`, `description` and `artifacts` key. `tags` key is an optional parameter.

```json
{
  "title": "test",
  "description": "test",
  "artifacts": ["1.1.1.1", "github.com"],
  "tags": ["test"]
}
```

| Key         | Desc.                                                                      | Required or optional |
| ----------- | -------------------------------------------------------------------------- | -------------------- |
| title       | A title of an alert                                                        | Required             |
| description | A description of an alert                                                  | Required             |
| artifacts   | An array of artifacts (supported data types: ip, domain, url, email, hash) | Required             |
| tags        | An array of tags                                                           | Optional             |

## Configuration

All configuration is done via ENV variables.

| Key                    | Desc.                          | Required or optional           |
| ---------------------- | ------------------------------ | ------------------------------ |
| THEHIVE_API_ENDPOINT   | TheHive URL                    | Required                       |
| THEHIVE_API_KEY        | TheHive API key                | Required                       |
| MISP_API_ENDPOINT      | MISP URL                       | Optional                       |
| MISP_API_KEY           | MISP API key                   | Optional                       |
| SLACK_WEBHOOK_URL      | Slack Webhook URL              | Optional                       |
| SLACK_CHANNEL          | Slack channel name             | Optional (default: `#general`) |
| BINARYEDGE_API_KEY     | BinaryEdge API key             | Optional                       |
| CENSYS_ID              | Censys API ID                  | Optional                       |
| CENSYS_SECRET          | Censys secret                  | Optional                       |
| CIRCL_PASSIVE_PASSWORD | CIRCL passive DNS/SSL password | Optional                       |
| CIRCL_PASSIVE_USERNAME | CIRCL passive DNS/SSL username | Optional                       |
| ONYPHE_API_KEY         | Onyphe API key                 | Optional                       |
| PASSIVETOTAL_API_KEY   | PassiveTotal API key           | Optional                       |
| PASSIVETOTAL_USERNAME  | PassiveTotal username          | Optional                       |
| SECURITYTRAILS_API_KEY | SecurityTrails API key         | Optional                       |
| SHODAN_API_KEY         | Shodan API key                 | Optional                       |
| VIRUSTOTAL_API_KEY     | VirusTotal API key             | Optional                       |
| ZOOMEYE_USERNAMME      | ZoomEye username               | Optional                       |
| ZOOMEYE_PASSWORD       | ZoomEye password               | Optional                       |

You can check the configuration status via `status` command.

```bash
mihari status
```

## How to create a custom script

Create a class which extends `Mihari::Analyzers::Base` and implements the following methods.

| Name           | Desc.                                                                      | @return       | Required or optional |
| -------------- | -------------------------------------------------------------------------- | ------------- | -------------------- |
| `#title`       | A title of an alert                                                        | String        | Required             |
| `#description` | A description of an alert                                                  | String        | Required             |
| `#artifacts`   | An array of artifacts (supported data types: ip, domain, url, email, hash) | Array<String> | Required             |
| `#tags`        | An array of tags                                                           | Array<String> | Optional             |

```ruby
require "mihari"

module Mihari
  module Analyzers
    class Example < Base
      def title
        "example"
      end

      def description
        "example"
      end

      def artifacts
        ["9.9.9.9", "example.com"]
      end

      def tags
        ["example"]
      end
    end
  end
end

example = Mihari::Analyzers::Example.new
example.run
```

See `/examples` for more.

## Caching

mihari caches execution results in `/tmp/mihari` and the default cache duration is 7 days. If you want to clear the cache, please clear `/tmp/mihari`.

## Using it with Docker

```bash
$ docker run --rm ninoseki/mihari
# Note that you should pass configurations via environment variables
$ docker run --rm ninoseki/mihari -e THEHIVE_API_ENDPOINT="http://THEHIVE_URL" -e THEHIVE_API_KEY="API KEY" mihari
# or
$ docker run --rm ninoseki/mihari --env-file ~/.mihari.env mihari
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

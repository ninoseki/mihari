# mihari

[![Gem Version](https://badge.fury.io/rb/mihari.svg)](https://badge.fury.io/rb/mihari)
[![Ruby CI](https://github.com/ninoseki/mihari/actions/workflows/test.yml/badge.svg)](https://github.com/ninoseki/mihari/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/mihari/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/mihari?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/mihari/badge)](https://www.codefactor.io/repository/github/ninoseki/mihari)

---

<p align="center">
  <img src="https://github.com/ninoseki/mihari/raw/master/images/logo.png"/>
  <br/>
  <a href="https://tines.io?utm_source=github&utm_medium=sponsorship&utm_campaign=ninoseki">
    <img src="https://github.com/ninoseki/mihari/raw/master/images/Tines-Full_Logo-Tines_Black.png"/>
  </a>
  <br/>
  Mihari is proudly supported by <a href="https://tines.io?utm_source=github&utm_medium=sponsorship&utm_campaign=ninoseki">Tines</a>
</p>

---

Mihari is a tool for OSINT based threat hunting.

## How it works

![img](https://github.com/ninoseki/mihari/raw/master/images/overview.jpg)

- Mihari makes a query against Shodan, Censys, VirusTotal, SecurityTrails, etc. and extracts artifacts (IP addresses, domains, URLs or hashes).
- Mihari checks whether the database (SQLite3, PostgreSQL or MySQL) contains the artifacts or not.
  - If it doesn't contain the artifacts:
    - Mihari saves artifacts in the database.
    - Mihari creates an alert on TheHive.
    - Mihari sends a notification to Slack.
    - Mihari creates an event on MISP.

Also, you can check the alerts on a built-in web app.

![img](https://github.com/ninoseki/mihari/raw/master/images/web_alerts.png)

## Supported services

Mihari supports the following services by default.

- [BinaryEdge](https://www.binaryedge.io/)
- [Censys](http://censys.io)
- [CIRCL passive DNS](https://www.circl.lu/services/passive-dns/) / [passive SSL](https://www.circl.lu/services/passive-ssl/)
- [crt.sh](https://crt.sh/)
- [DN Pedia](https://dnpedia.com/)
- [dnstwister](https://dnstwister.report/)
- [GreyNoise](https://www.greynoise.io/)
- [Onyphe](https://onyphe.io)
- [OTX](https://otx.alienvault.com/)
- [PassiveTotal](https://community.riskiq.com/)
- [Pulsedive](https://pulsedive.com/)
- [SecurityTrails](https://securitytrails.com/)
- [Shodan](https://shodan.io)
- [urlscan.io](https://urlscan.io)
- [VirusTotal](http://virustotal.com) & [VirusTotal Intelligence](https://www.virustotal.com/gui/intelligence-overview)
- [ZoomEye](https://zoomeye.org)

## Docs

- [Mihari Knowledge Base](https://www.notion.so/Mihari-Knowledge-Base-266994ff61204428ba6cfcebe40b0bd1)

## Presentations

- [Adversary Infrastructure Tracking with Mihari](https://ninoseki.github.io/presentations/Adversary%20Infrastructure%20Tracking%20with%20Mihari.pdf)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgement

Mihari is proudly supported by [Tines.io](https://tines.io?utm_source=github&utm_medium=sponsorship&utm_campaign=ninoseki), The SOAR Platform for Enterprise Security Teams.

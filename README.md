# mihari

[![Gem Version](https://badge.fury.io/rb/mihari.svg)](https://badge.fury.io/rb/mihari)
[![Ruby CI](https://github.com/ninoseki/mihari/actions/workflows/ruby.yml/badge.svg)](https://github.com/ninoseki/mihari/actions/workflows/ruby.yml)
[![Node.js CI](https://github.com/ninoseki/mihari/actions/workflows/node.yml/badge.svg)](https://github.com/ninoseki/mihari/actions/workflows/node.yml)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/mihari/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/mihari?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/mihari/badge)](https://www.codefactor.io/repository/github/ninoseki/mihari)

A query aggregator for OSINT based threat hunting.

Mihari can aggregate multiple searches across multiple services in a single rule & persist findings in a database.

Mihari supports the following services by default.

- [BinaryEdge](https://www.binaryedge.io/)
- [Censys](http://censys.io)
- [CIRCL passive DNS](https://www.circl.lu/services/passive-dns/) / [passive SSL](https://www.circl.lu/services/passive-ssl/)
- [crt.sh](https://crt.sh/)
- [dnstwister](https://dnstwister.report/)
- [Fofa](https://en.fofa.info/)
- [GreyNoise](https://www.greynoise.io/)
- [HunterHow](https://hunter.how/)
- [Onyphe](https://onyphe.io)
- [OTX](https://otx.alienvault.com/)
- [PassiveTotal](https://community.riskiq.com/)
- [Pulsedive](https://pulsedive.com/)
- [SecurityTrails](https://securitytrails.com/)
- [Shodan](https://shodan.io)
- [urlscan.io](https://urlscan.io)
- [Validin](https://validin.com)
- [VirusTotal](http://virustotal.com) & [VirusTotal Intelligence](https://www.virustotal.com/gui/intelligence-overview)
- [ZoomEye](https://zoomeye.org)

See [documentation](https://ninoseki.github.io/mihari/) for more details.

You can also refer to [JSAC2024 workshop materials](https://ninoseki.github.io/jsac_mihari_workshop/) to learn how Mihari works through some exercises.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

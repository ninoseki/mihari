# frozen_string_literal: true

require "mem"

module Mihari
  class << self
    include Mem

    def emitters
      []
    end
    memoize :emitters

    def analyzers
      []
    end
    memoize :analyzers
  end
end

require "mihari/version"
require "mihari/errors"

require "mihari/config"

require "mihari/database"
require "mihari/type_checker"

require "mihari/models/alert"
require "mihari/models/artifact"
require "mihari/models/tag"
require "mihari/models/tagging"

require "mihari/serializers/alert"
require "mihari/serializers/artifact"
require "mihari/serializers/tag"

require "mihari/html"

require "mihari/configurable"
require "mihari/retriable"

require "mihari/analyzers/base"
require "mihari/analyzers/basic"

require "mihari/analyzers/binaryedge"
require "mihari/analyzers/censys"
require "mihari/analyzers/circl"
require "mihari/analyzers/crtsh"
require "mihari/analyzers/dnpedia"
require "mihari/analyzers/dnstwister"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/otx"
require "mihari/analyzers/passivetotal"
require "mihari/analyzers/pulsedive"
require "mihari/analyzers/securitytrails_domain_feed"
require "mihari/analyzers/securitytrails"
require "mihari/analyzers/shodan"
require "mihari/analyzers/spyse"
require "mihari/analyzers/urlscan"
require "mihari/analyzers/virustotal"
require "mihari/analyzers/zoomeye"

require "mihari/analyzers/free_text"
require "mihari/analyzers/http_hash"
require "mihari/analyzers/passive_dns"
require "mihari/analyzers/passive_ssl"
require "mihari/analyzers/reverse_whois"
require "mihari/analyzers/ssh_fingerprint"

require "mihari/notifiers/base"
require "mihari/notifiers/slack"
require "mihari/notifiers/exception_notifier"

require "mihari/emitters/base"
require "mihari/emitters/database"
require "mihari/emitters/misp"
require "mihari/emitters/slack"
require "mihari/emitters/stdout"
require "mihari/emitters/the_hive"

require "mihari/status"

require "mihari/web/app"

require "mihari/cli"

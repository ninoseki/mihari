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

require "mihari/artifact"
require "mihari/cache"
require "mihari/config"
require "mihari/type_checker"

require "mihari/html"

require "mihari/configurable"
require "mihari/retriable"

require "mihari/the_hive/base"
require "mihari/the_hive/alert"
require "mihari/the_hive/artifact"
require "mihari/the_hive"

require "mihari/analyzers/base"
require "mihari/analyzers/basic"

require "mihari/analyzers/binaryedge"
require "mihari/analyzers/censys"
require "mihari/analyzers/circl"
require "mihari/analyzers/crtsh"
require "mihari/analyzers/dnpedia"
require "mihari/analyzers/dnstwister"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/passivetotal"
require "mihari/analyzers/pulsedive"
require "mihari/analyzers/securitytrails_domain_feed"
require "mihari/analyzers/securitytrails"
require "mihari/analyzers/shodan"
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
require "mihari/emitters/misp"
require "mihari/emitters/slack"
require "mihari/emitters/stdout"
require "mihari/emitters/the_hive"

require "mihari/alert_viewer"

require "mihari/status"

require "mihari/cli"

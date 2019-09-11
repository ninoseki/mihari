# frozen_string_literal: true

require "mem"

module Mihari
  class << self
    include Mem

    def emitters
      []
    end
    memoize :emitters
  end
end

require "mihari/version"

require "mihari/errors"

require "mihari/type_checker"
require "mihari/artifact"

require "mihari/the_hive/base"
require "mihari/the_hive/alert"
require "mihari/the_hive/artifact"
require "mihari/the_hive"

require "mihari/analyzers/base"
require "mihari/analyzers/basic"
require "mihari/analyzers/censys"
require "mihari/analyzers/crtsh"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/securitytrails"
require "mihari/analyzers/securitytrails_domain_feed"
require "mihari/analyzers/shodan"
require "mihari/analyzers/urlscan"
require "mihari/analyzers/virustotal"

require "mihari/notifiers/base"
require "mihari/notifiers/slack"
require "mihari/notifiers/exception_notifier"

require "mihari/emitters/base"
require "mihari/emitters/slack"
require "mihari/emitters/stdout"
require "mihari/emitters/the_hive"

require "mihari/alert_viewer"

require "mihari/status"

require "mihari/cli"

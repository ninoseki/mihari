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

require "mihari/the_hive"

require "mihari/analyzers/base"
require "mihari/analyzers/basic"
require "mihari/analyzers/censys"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/shodan"
require "mihari/analyzers/urlscan"

require "mihari/emitters/base"
require "mihari/emitters/slack"
require "mihari/emitters/the_hive"

require "mihari/cli"

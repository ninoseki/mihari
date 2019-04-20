# frozen_string_literal: true

require "mem"

module Mihari
  class << self
    include Mem

    def notifiers
      []
    end
    memoize :notifiers
  end
end

require "mihari/version"

require "mihari/errors"

require "mihari/type_checker"
require "mihari/artifact"

require "mihari/the_hive"

require "mihari/analyzer"

require "mihari/notifiers/base"
require "mihari/notifiers/slack"
require "mihari/notifiers/the_hive"

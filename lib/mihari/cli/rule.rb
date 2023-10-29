# frozen_string_literal: true

require "mihari/commands/rule"

module Mihari
  module CLI
    #
    # Rule CLI class (mihari rule ...)
    #
    class Rule < Base
      include Mihari::Commands::Rule
    end
  end
end

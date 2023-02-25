# frozen_string_literal: true

require "mihari/commands/rule"

module Mihari
  module CLI
    class Rule < Base
      include Mihari::Commands::Rule
    end
  end
end

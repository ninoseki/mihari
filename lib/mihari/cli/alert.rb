# frozen_string_literal: true

require "mihari/commands/alert"

module Mihari
  module CLI
    #
    # Alert CLI class (mihari alert ...)
    #
    class Alert < Base
      include Mihari::Commands::Alert
    end
  end
end

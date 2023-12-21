# frozen_string_literal: true

require "mihari/commands/config"

module Mihari
  module CLI
    #
    # Config CLI class (mihari config ...)
    #
    class Config < Base
      include Mihari::Commands::Config
    end
  end
end

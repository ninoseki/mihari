# frozen_string_literal: true

require "mihari/commands/tag"

module Mihari
  module CLI
    #
    # Tag CLI class (mihari rule ...)
    #
    class Tag < Base
      include Mihari::Commands::Tag
    end
  end
end

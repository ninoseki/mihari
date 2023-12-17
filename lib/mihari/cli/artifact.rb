# frozen_string_literal: true

require "mihari/commands/artifact"

module Mihari
  module CLI
    #
    # Artifact CLI class (mihari artifact ...)
    #
    class Artifact < Base
      include Mihari::Commands::Artifact
    end
  end
end

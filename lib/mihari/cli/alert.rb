# frozen_string_literal: true

require "mihari/commands/alert"

module Mihari
  module CLI
    class Alert < Base
      include Mihari::Commands::Alert
    end
  end
end

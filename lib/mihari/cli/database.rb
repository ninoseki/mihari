# frozen_string_literal: true

require "mihari/commands/database"

module Mihari
  module CLI
    #
    # Database CLI class (mihari db ...)
    #
    class Database < Base
      include Mihari::Commands::Database
    end
  end
end

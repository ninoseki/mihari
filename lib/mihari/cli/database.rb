# frozen_string_literal: true

require "mihari/commands/database"

module Mihari
  module CLI
    class Database < Base
      include Mihari::Commands::Database
    end
  end
end

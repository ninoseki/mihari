# frozen_string_literal: true

require "mihari/commands/validator"

module Mihari
  module CLI
    class Validator < Base
      include Mihari::Commands::Validator
    end
  end
end

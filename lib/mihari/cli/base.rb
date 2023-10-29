# frozen_string_literal: true

module Mihari
  module CLI
    #
    # Base class for Thor classes
    #
    class Base < Thor
      class << self
        def exit_on_failure?
          true
        end
      end
    end
  end
end

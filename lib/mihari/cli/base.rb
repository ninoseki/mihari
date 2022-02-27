# frozen_string_literal: true

module Mihari
  module CLI
    class Base < Thor
      class << self
        def exit_on_failure?
          true
        end
      end
    end
  end
end

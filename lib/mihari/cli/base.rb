# frozen_string_literal: true

require "mihari/cli/mixins/utils"

module Mihari
  module CLI
    class Base < Thor
      include Mixins::Utils

      class << self
        def exit_on_failure?
          true
        end
      end
    end
  end
end

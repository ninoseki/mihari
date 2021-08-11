# frozen_string_literal: true

require "thor"

require "mihari/mixins/hash"

require "mihari/cli/mixins/utils"

module Mihari
  module CLI
    class Base < Thor
      include Mihari::Mixins::Hash
      include Mixins::Utils

      class << self
        def exit_on_failure?
          true
        end
      end
    end
  end
end

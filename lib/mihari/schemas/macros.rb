# frozen_string_literal: true

module Dry
  module Schema
    module Macros
      #
      # Macros DSL for options with default values
      # (see https://github.com/dry-rb/dry-schema/issues/70)
      #
      class DSL
        def default(value)
          schema_dsl.before(:rule_applier) do |result|
            result.update(name => value) unless result[name]
          end
        end
      end
    end
  end
end

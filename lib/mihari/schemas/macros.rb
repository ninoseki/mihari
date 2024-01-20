# frozen_string_literal: true

module Dry
  module Schema
    module Macros
      #
      # Macros DSL for options with default values
      # (see https://github.com/dry-rb/dry-schema/issues/70)
      #
      class DSL
        def default(artifact)
          schema_dsl.before(:rule_applier) do |result|
            result.update(name => artifact) if result.output && !result[name]
          end
        end
      end
    end
  end
end

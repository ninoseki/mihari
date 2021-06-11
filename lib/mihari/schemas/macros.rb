# frozen_string_literal: true

require "dry/types"

module Dry
  module Schema
    module Macros
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

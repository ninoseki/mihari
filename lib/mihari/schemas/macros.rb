require "dry/types"

class Dry::Schema::Macros::DSL
  def default(value)
    schema_dsl.before(:rule_applier) do |result|
      result.update(name => value) unless result[name]
    end
  end
end

module Mihari
  module Services
    #
    # Alert creator
    #
    class AlertCreator < Service
      #
      # @param [Hash] params
      #
      # @return [Mihari::Models::Alert]
      #
      def call(params)
        normalized = params.to_snake_keys
        proxy = Services::AlertProxy.new(**normalized)
        emitter = Emitters::Database.new(rule: proxy.rule)
        emitter.call proxy.artifacts
      end
    end

    #
    # Rule creator
    #
    class RuleCreator < Service
      #
      # @params [String] yaml
      # @params [Boolean] overwrite
      #
      # @return [Mihari::Models::Rule]
      #
      def call(yaml, overwrite: false)
        rule = Rule.from_yaml(yaml)

        found = Mihari::Models::Rule.find(rule.id)
        raise if found && !overwrite

        rule.model.save
        rule
      end
    end
  end
end

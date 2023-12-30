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
  end
end

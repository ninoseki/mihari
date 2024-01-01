# frozen_string_literal: true

module Mihari
  module Services
    #
    # Rule builder
    #
    class RuleBuilder < Service
      #
      # @param [String] path_or_id
      #
      # @return [Mihari::Rule]
      #
      def call(path_or_id)
        res = Try { Rule.from_model Mihari::Models::Rule.find(path_or_id) }
        return res.value! if res.value?

        raise ArgumentError, "#{path_or_id} not found" unless Pathname(path_or_id).exist?

        Rule.from_yaml ERB.new(File.read(path_or_id)).result
      end
    end
  end
end

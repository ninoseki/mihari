# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # False positive normalizable concern
    #
    module FalsePositiveNormalizable
      extend ActiveSupport::Concern

      prepend MemoWise

      #
      # Normalize a falsepositive value
      #
      # @param [String] value
      #
      # @return [String, Regexp]
      #
      def normalize_falsepositive(value)
        return value if !value.start_with?("/") || !value.end_with?("/")

        # if a value is surrounded by slashes, take it as a regexp
        value_without_slashes = value[1..-2]
        Regexp.compile value_without_slashes.to_s
      end
      memo_wise :normalize_falsepositive
    end
  end
end

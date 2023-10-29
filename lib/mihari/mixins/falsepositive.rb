# frozen_string_literal: true

module Mihari
  module Mixins
    #
    # False positive mixins
    #
    module FalsePositive
      include Memist::Memoizable

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
      memoize :normalize_falsepositive

      #
      # Check whether a value is valid format as a disallowed data value
      #
      # @param [String] value Data value
      #
      # @return [Boolean] true if it is valid, otherwise false
      #
      def valid_falsepositive?(value)
        begin
          normalize_falsepositive value
        rescue RegexpError
          return false
        end
        true
      end
    end
  end
end

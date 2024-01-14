# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # False positive validatable concern
    #
    module FalsePositiveValidatable
      extend ActiveSupport::Concern

      include FalsePositiveNormalizable

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

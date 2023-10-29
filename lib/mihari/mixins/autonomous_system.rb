# frozen_string_literal: true

module Mihari
  module Mixins
    #
    # Autonomous System mixin
    #
    module AutonomousSystem
      #
      # Normalize ASN value
      #
      # @param [String, Integer] asn
      #
      # @return [Integer]
      #
      def normalize_asn(asn)
        return asn if asn.is_a?(Integer)
        return asn.to_i unless asn.start_with?("AS")

        asn.delete_prefix("AS").to_i
      end
    end
  end
end

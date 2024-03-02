# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # Autonomous System concern
    #
    module AutonomousSystemNormalizable
      extend ActiveSupport::Concern

      #
      # Normalize ASN value
      #
      # @param [String, Integer] asn
      #
      # @return [Integer]
      #
      def normalize_asn(asn)
        asn.to_s.delete_prefix("AS").to_i
      end
    end
  end
end

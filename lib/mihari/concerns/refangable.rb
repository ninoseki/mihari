# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # Refangable concern
    #
    module Refangable
      extend ActiveSupport::Concern

      #
      # Refang defanged indicator
      #
      # @param [String] indicator
      #
      # @return [String]
      #
      def refang(indicator)
        indicator.gsub("[.]", ".").gsub("(.)", ".")
      end
    end
  end
end

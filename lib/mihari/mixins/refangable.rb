# frozen_string_literal: true

module Mihari
  module Mixins
    #
    # Refangable mixin
    #
    module Refangable
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

# frozen_string_literal: true

module Mihari
  module Mixins
    module Refang
      #
      # Refang defanged indicator
      #
      # @param [String] indicator
      #
      # @return [String]
      #
      def refang(indicator)
        return indicator.gsub("[.]", ".").gsub("(.)", ".") if indicator.is_a?(String)

        # for RSpec & Ruby 2.7
        indicator
      end
    end
  end
end

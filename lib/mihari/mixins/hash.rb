# frozen_string_literal: true

require "cymbal"

module Mihari
  module Mixins
    module Hash
      #
      # Symbolize hash keys
      #
      # @param [Hash] hash
      #
      # @return [Hash]
      #
      def symbolize_hash(hash)
        Cymbal.symbolize hash
      end
    end
  end
end

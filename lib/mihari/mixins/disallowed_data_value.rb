require "mem"

module Mihari
  module Mixins
    module DisallowedDataValue
      include Mem

      #
      # Normalize a value as a disallowed data value
      #
      # @param [String] value Data value
      #
      # @return [String, Regexp] Normalized value
      #
      def normalize_disallowed_data_value(value)
        return value if !value.start_with?("/") || !value.end_with?("/")

        # if a value is surrounded by slashes, take it as a regexp
        value_without_slashes = value[1..-2]
        Regexp.compile value_without_slashes
      end

      memoize :normalize_disallowed_data_value

      #
      # Check whetehr a value is valid format as a disallowed data value
      #
      # @param [String] value Data value
      #
      # @return [Boolean] true if it is valid, otherwise false
      #
      def valid_disallowed_data_value?(value)
        begin
          normalize_disallowed_data_value value
        rescue RegexpError
          return false
        end
        true
      end
    end
  end
end

# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # Error unwrappable concern
    #
    module ErrorUnwrappable
      extend ActiveSupport::Concern

      def unwrap_error(err)
        return err unless err.is_a?(Dry::Monads::UnwrapError)

        # NOTE: UnwrapError's receiver can be either of:
        #       - Dry::Monads::Try::Error
        #       - Dry::Monads::Result::Failure
        receiver = err.receiver
        case receiver
        when Dry::Monads::Try::Error
          receiver.exception
        when Dry::Monads::Failure
          receiver.failure
        else
          err
        end
      end
    end
  end
end
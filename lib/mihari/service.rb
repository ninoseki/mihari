module Mihari
  #
  # Base class for services
  #
  class Service
    include Dry::Monads[:result, :try]

    def call(*args, **kwargs)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def result
      Try[StandardError] { call }.to_result
    end

    class << self
      def call(...)
        new(...).call
      end

      def result(...)
        new(...).result
      end
    end
  end
end

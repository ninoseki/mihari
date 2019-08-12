# frozen_string_literal: true

require "hachi"

module Mihari
  class TheHive
    class Base
      # @return [Hachi::API]
      def api
        @api ||= Hachi::API.new
      end
    end
  end
end

# frozen_string_literal: true

module Mihari
  class ReverseDnsName < ActiveRecord::Base
    belongs_to :artifact

    class << self
      include Dry::Monads[:result]

      #
      # Build reverse DNS names
      #
      # @param [String] ip
      #
      # @return [Array<Mihari::ReverseDnsName>]
      #
      def build_by_ip(ip)
        result = Enrichers::Shodan.query_result(ip).bind do |res|
          if res.nil?
            Success []
          else
            Success(res.hostnames.map { |name| new(name: name) })
          end
        end
        result.value_or []
      end
    end
  end
end

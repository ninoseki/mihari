# frozen_string_literal: true

module Mihari
  class ReverseDnsName < ActiveRecord::Base
    belongs_to :artifact

    class << self
      #
      # Build reverse DNS names
      #
      # @param [String] ip
      #
      # @return [Array<Mihari::ReverseDnsName>]
      #
      def build_by_ip(ip)
        names = Resolv.getnames(ip)
        names.map { |name| new(name: name) }
      rescue Resolv::ResolvError
        []
      end
    end
  end
end

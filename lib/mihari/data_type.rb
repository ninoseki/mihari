# frozen_string_literal: true

module Mihari
  #
  # (Artifact) Data Type
  #
  class DataType
    include Dry::Monads[:try]

    # @return [String]
    attr_reader :data

    #
    # @param [String] data
    #
    def initialize(data)
      raise ArgumentError if data.is_a?(Hash)

      @data = data.to_s
    end

    # @return [Boolean]
    def hash?
      md5? || sha1? || sha256? || sha512?
    end

    # @return [Boolean]
    def ip?
      Try[IPAddr::InvalidAddressError] do
        IPAddr.new(data).to_s == data
      end.to_result.value_or(false)
    end

    # @return [Boolean]
    def domain?
      Try[Addressable::URI::InvalidURIError] do
        uri = Addressable::URI.parse("http://#{data}")
        uri.host == data && PublicSuffix.valid?(uri.host)
      end.to_result.value_or(false)
    end

    # @return [Boolean]
    def url?
      Try[Addressable::URI::InvalidURIError] do
        uri = Addressable::URI.parse(data)
        uri.scheme && uri.host && uri.path && PublicSuffix.valid?(uri.host)
      end.to_result.value_or(false)
    end

    # @return [Boolean]
    def mail?
      EmailAddress.valid? data, host_validation: :syntax
    end

    # @return [String, nil]
    def type
      found = %i[hash? ip? domain? url? mail?].find { |method| send(method) if respond_to?(method) }
      return nil if found.nil?

      found[...-1].to_s
    end

    # @return [String, nil]
    def detailed_type
      found = %i[md5? sha1? sha256? sha512?].find { |method| send(method) if respond_to?(method) }
      return found[...-1].to_s unless found.nil?

      type
    end

    # @return [Boolean]
    def md5?
      data.match?(/^[A-Fa-f0-9]{32}$/)
    end

    # @return [Boolean]
    def sha1?
      data.match?(/^[A-Fa-f0-9]{40}$/)
    end

    # @return [Boolean]
    def sha256?
      data.match?(/^[A-Fa-f0-9]{64}$/)
    end

    # @return [Boolean]
    def sha512?
      data.match?(/^[A-Fa-f0-9]{128}$/)
    end

    class << self
      # @return [String, nil]
      def type(data)
        new(data).type
      end

      # @return [String, nil]
      def detailed_type(data)
        new(data).detailed_type
      end
    end
  end
end

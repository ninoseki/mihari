# frozen_string_literal: true

module Mihari
  class TypeChecker
    extend Dry::Initializer

    param :data

    def initialize(*args, **kwargs)
      super

      raise ArgumentError if data.is_a?(Hash)

      @data = data.to_s
    end

    # @return [Boolean]
    def hash?
      md5? || sha1? || sha256? || sha512?
    end

    # @return [Boolean]
    def ip?
      IPAddr.new data
      true
    rescue IPAddr::InvalidAddressError => _e
      false
    end

    # @return [Boolean]
    def domain?
      uri = Addressable::URI.parse("http://#{data}")
      uri.host == data && PublicSuffix.valid?(uri.host)
    rescue Addressable::URI::InvalidURIError => _e
      false
    end

    # @return [Boolean]
    def url?
      uri = Addressable::URI.parse(data)
      uri.scheme && uri.host && uri.path && PublicSuffix.valid?(uri.host)
    rescue Addressable::URI::InvalidURIError => _e
      false
    end

    # @return [Boolean]
    def mail?
      EmailAddress.valid? data, host_validation: :syntax
    end

    # @return [String, nil]
    def type
      return "hash" if hash?
      return "ip" if ip?
      return "domain" if domain?
      return "url" if url?
      return "mail" if mail?
    end

    # @return [String, nil]
    def detailed_type
      return "md5" if md5?
      return "sha1" if sha1?
      return "sha256" if sha256?
      return "sha512" if sha512?

      type
    end

    # @return [String, nil]
    def self.type(data)
      new(data).type
    end

    # @return [String, nil]
    def self.detailed_type(data)
      new(data).detailed_type
    end

    private

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
  end
end

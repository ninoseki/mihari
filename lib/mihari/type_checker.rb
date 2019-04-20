# frozen_string_literal: true

require "addressable/uri"
require "ipaddr"
require "public_suffix"

module Mihari
  class TypeChecker
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def hash?
      md5? || sha1? || sha256? || sha512?
    end

    def ip?
      IPAddr.new value
      true
    rescue IPAddr::InvalidAddressError => _
      false
    end

    def domain?
      PublicSuffix.valid? value
    end

    def url?
      uri = Addressable::URI.parse(value)
      uri.scheme && uri.host && uri.path && PublicSuffix.valid?(uri.host)
    rescue Addressable::URI::InvalidURIError => _
      false
    end

    def type
      return "hash" if hash?
      return "ip" if ip?
      return "domain" if domain?
      return "url" if url?
    end

    def self.type(value)
      new(value).type
    end

    private

    def md5?
      value.match? /^[A-Fa-f0-9]{32}$/
    end

    def sha1?
      value.match? /^[A-Fa-f0-9]{40}$/
    end

    def sha256?
      value.match? /^[A-Fa-f0-9]{64}$/
    end

    def sha512?
      value.match? /^[A-Fa-f0-9]{128}$/
    end
  end
end

# frozen_string_literal: true

require "digest/sha2"
require "murmurhash3"

module Mihari
  class HTML
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def exists?
      return false unless path

      File.exist? path
    end

    def sha256
      Digest::SHA256.hexdigest data
    end

    def md5
      Digest::MD5.hexdigest data
    end

    def mmh3
      hash = MurmurHash3::V32.str_hash(data)
      if (hash & 0x80000000).zero?
        hash
      else
        -((hash ^ 0xFFFFFFFF) + 1)
      end
    end

    private

    def data
      File.read path
    end
  end
end

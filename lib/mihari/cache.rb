# frozen_string_literal: true

require "lightly"

module Mihari
  class Cache
    DEFAULT_CACHE_DIR = "/tmp/mihari"

    def initialize
      @data = Lightly.new(life: "7d", dir: DEFAULT_CACHE_DIR)
    end

    def cached?(key)
      return false unless @data.enabled?

      begin
        @data.cached? key
      rescue Errno::ENOENT => _e
        false
      end
    end

    def save(*keys)
      return unless @data.enabled?

      begin
        keys.flatten.each do |key|
          @data.save key, true
        end
      rescue Errno::ENOENT => _e
        nil
      end
    end
  end
end

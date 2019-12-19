# frozen_string_literal: true

require "yaml"

module Mihari
  class Config
    class << self
      def load_from_yaml(path)
        raise ArgumentError, "#{path} does not exist." unless File.exist?(path)

        data = File.read(path)
        begin
          yaml = YAML.safe_load(data)
        rescue TypeError => _e
          return
        end

        yaml.each do |key, value|
          ENV[key.upcase] = value
        end
      end
    end
  end
end

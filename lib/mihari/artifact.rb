# frozen_string_literal: true

module Mihari
  class Artifact
    attr_reader :value

    def initialize(value)
      @value = value

      raise ArgumentError, "Input not supported. Supported types are ip, domain, url and hash." unless type
    end

    def type
      TypeChecker.type value
    end
  end
end

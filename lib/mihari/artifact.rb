# frozen_string_literal: true

require "hachi"

module Mihari
  class Artifact
    attr_reader :data

    def initialize(data, message: nil)
      @data = data
      @message = message
    end

    def data_type
      TypeChecker.type data
    end

    def message
      @mesasge || data
    end

    def valid?
      !data_type.nil?
    end

    def to_h
      { data: data, data_type: data_type, message: message }
    end
  end
end

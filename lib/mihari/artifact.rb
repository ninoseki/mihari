# frozen_string_literal: true

require "hachi"

module Mihari
  class Artifact
    attr_reader :data

    #
    # @param [String] data
    # @param [String, nil] message
    #
    def initialize(data, message: nil)
      @data = data
      @message = message
    end

    # @return [String, nil]
    def data_type
      TypeChecker.type data
    end

    # @return [String]
    def message
      @mesasge || data
    end

    # @return [true, false]
    def valid?
      !data_type.nil?
    end

    # @return [Hash]
    def to_h
      { data: data, data_type: data_type, message: message }
    end
  end
end

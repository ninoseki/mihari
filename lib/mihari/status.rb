# frozen_string_literal: true

module Mihari
  class Status
    def check
      statuses.map do |key, value|
        [key, convert(**value)]
      end.to_h
    end

    def self.check
      new.check
    end

    private

    def convert(status:, message:)
      {
        status: status ? "OK" : "Bad",
        message: message
      }
    end

    def statuses
      (Mihari.analyzers + Mihari.emitters).map do |klass|
        name = klass.to_s.downcase.split("::").last.to_s

        [name, build_status(klass)]
      end.to_h.compact
    end

    def build_status(klass)
      is_analyzer = klass.ancestors.include?(Mihari::Analyzers::Base)

      instance = is_analyzer ? klass.new("dummy") : klass.new
      status = instance.configured?
      message = instance.configuration_status

      message ? {status: status, message: message} : nil
    rescue ArgumentError => _e
      nil
    end
  end
end

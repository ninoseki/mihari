# frozen_string_literal: true

module Mihari
  class Status
    def check
      statuses.map do |key, value|
        [key, convert(value)]
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
        full_name = klass.to_s.downcase
        name = full_name.split("::").last.to_s

        instance = full_name.include?("analyzers") ? klass.new("dummy") : klass.new
        status = instance.configured?
        message = instance.configuration_status

        message ? [name, { status: status, message: message }] : nil
      end.compact.to_h
    end
  end
end

# frozen_string_literal: true

module Mihari
  class Status
    def check
      statuses
    end

    def self.check
      new.check
    end

    private

    def statuses
      (Mihari.analyzers + Mihari.emitters).map do |klass|
        name = klass.to_s.split("::").last.to_s

        [name, build_status(klass)]
      end.to_h.compact
    end

    def build_status(klass)
      is_analyzer = klass.ancestors.include?(Mihari::Analyzers::Base)

      instance = is_analyzer ? klass.new("dummy") : klass.new
      is_configured = instance.configured?
      values = instance.configuration_values
      type = is_analyzer ? "Analyzer" : "Emitter"

      values ? { is_configured: is_configured, values: values, type: type } : nil
    rescue ArgumentError => _e
      nil
    end
  end
end

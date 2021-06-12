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

    #
    # Statuses of analyzers and emitters
    #
    # @return [Array<Hash>]
    #
    def statuses
      (Mihari.analyzers + Mihari.emitters).map do |klass|
        name = klass.to_s.split("::").last.to_s

        [name, build_status(klass)]
      end.to_h.compact
    end

    #
    # Build a status of a class
    #
    # @param [Class<Mihari::Analyzers::Base>, Class<Mihari::Emitters::Base>] klass
    #
    # @return [Hash, nil]
    #
    def build_status(klass)
      return nil if klass == Mihari::Analyzers::Rule

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

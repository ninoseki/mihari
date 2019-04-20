# frozen_string_literal: true

module Mihari
  class Analyzer
    attr_reader :the_hive

    def initialize
      @the_hive = TheHive.new
    end

    def artifacts
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def title
      self.class.to_s.split("::").last
    end

    def description
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def run(reject_exists_ones: true)
      valid_artifacts = artifacts.select(&:valid?)
      unique_artifacts = valid_artifacts.reject do |artifact|
        reject_exists_ones & the_hive.valid? && the_hive.exists?(data: artifact.data, data_type: artifact.data_type)
      end

      Mihari.notifiers.each do |notifier_class|
        notifier = notifier_class.new
        next unless notifier.valid?

        notifier.notify(title: title, description: description, artifacts: unique_artifacts)
      end
    end
  end
end

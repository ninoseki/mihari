# frozen_string_literal: true

require "thor"

require "mihari/mixins/hash"

require "mihari/cli/mixins/utils"

module Mihari
  module CLI
    class Base < Thor
      include Mihari::Mixins::Hash
      include Mixins::Utils

      class_option :config, type: :string, desc: "Path to the config file"

      class_option :ignore_old_artifacts, type: :boolean, default: false, desc: "Whether to ignore old artifacts from checking or not. Only affects with analyze commands."
      class_option :ignore_threshold, type: :numeric, default: 0, desc: "Number of days to define whether an artifact is old or not. Only affects with analyze commands."

      class << self
        def exit_on_failure?
          true
        end
      end
    end
  end
end

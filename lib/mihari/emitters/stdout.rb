# frozen_string_literal: true

require "json"

module Mihari
  module Emitters
    class StandardOutput < Base
      def valid?
        true
      end

      def emit(title:, description:, artifacts:, source:, tags:)
        h = {
          title: title,
          description: description,
          artifacts: artifacts.map(&:data),
          source: source,
          tags: tags
        }
        puts JSON.pretty_generate(h)
      end
    end
  end
end

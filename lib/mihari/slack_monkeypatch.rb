# frozen_string_literal: true

module Slack
  class Notifier
    module Util
      class LinkFormatter
        class << self
          def format(string, opts = {})
            # Resolve warning in Ruby 2.7
            LinkFormatter.new(string, **opts).formatted
          end
        end
      end
    end
  end
end

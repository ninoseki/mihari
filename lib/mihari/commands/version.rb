# frozen_string_literal: true

module Mihari
  module Commands
    module Version
      class << self
        def included(thor)
          thor.class_eval do
            map %w[--version -v] => :__print_version

            desc "--version, -v", "Print the version"
            def __print_version
              puts Mihari::VERSION
            end
          end
        end
      end
    end
  end
end

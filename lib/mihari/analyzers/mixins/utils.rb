# frozen_string_literal: true

module Mihari
  module Analyzers
    module Mixins
      module Utils
        def refang(indicator)
          # for RSpec & Ruby 2.7
          return indicator if indicator.is_a?(Hash)

          indicator.gsub("[.]", ".").gsub("(.)", ".")
        end
      end
    end
  end
end

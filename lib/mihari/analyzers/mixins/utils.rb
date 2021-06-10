module Mihari
  module Analyzers
    module Mixins
      module Utils
        def refang(indicator)
          # for RSpec & Ruby 2.7
          return indicator if indiactor.is_a?(Hash)

          indicator.gsub("[.]", ".").gsub("(.)", ".")
        end
      end
    end
  end
end

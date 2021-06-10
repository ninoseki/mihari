module Mihari
  module Analyzers
    module Mixins
      module Utils
        def refang(indicator)
          indicator.gsub("[.]", ".").gsub("(.)", ".")
        end
      end
    end
  end
end

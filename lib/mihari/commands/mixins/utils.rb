# frozen_string_literal: true

require "cymbal"

module Mihari
  module Commands
    module Mixins
      module Utils
        def symbolize_hash(hash)
          Cymbal.symbolize hash
        end
      end
    end
  end
end

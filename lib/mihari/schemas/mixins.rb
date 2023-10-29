# frozen_string_literal: true

module Mihari
  module Schemas
    #
    # Mixins for schemas
    #
    module Mixins
      def get_or_composition
        schemas = constants.map { |sym| const_get sym }
        return schemas.first if schemas.length <= 1

        base, *others = schemas
        others.each { |other| base = base.or(other) }

        base
      end
    end
  end
end

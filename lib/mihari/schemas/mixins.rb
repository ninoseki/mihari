module Mihari
  module Schemas
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

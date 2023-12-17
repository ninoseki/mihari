module Mihari
  module Models
    module Paginationable
      def search(filter)
        limit = filter.limit.to_i
        raise ArgumentError, "limit should be bigger than zero" unless limit.positive?

        page = filter.page.to_i
        raise ArgumentError, "page should be bigger than zero" unless page.positive?

        offset = (page - 1) * limit

        relation = build_relation(filter.without_pagination)
        relation.limit(limit).offset(offset).order(id: :desc)
      end

      #
      # @return [Integer]
      #
      def count(filter)
        relation = build_relation(filter)
        relation.distinct("alerts.id").count
      end
    end
  end
end

# frozen_string_literal: true

module Mihari
  module Structs
    module Filters
      class PaginationMixin < Dry::Struct
        # @!attribute [r] page
        #   @return [Integer, nil]
        attribute? :page, Types::Int.default(1)

        # @!attribute [r] limit
        #   @return [Integer, nil]
        attribute? :limit, Types::Int.default(10)
      end

      class DateTimeMixin < Dry::Struct
        # @!attribute [r] from_at
        #   @return [DateTime, nil]
        attribute? :from_at, Types::DateTime.optional

        # @!attribute [r] to_at
        #   @return [DateTime, nil]
        attribute? :to_at, Types::DateTime.optional
      end

      module Artifact
        class SearchFilter < Dry::Struct
          # @!attribute [r] data_type
          #   @return [String, nil]
          attribute? :data_type, Types::String.optional

          # @!attribute [r] rule_id
          #   @return [String, nil]
          attribute? :rule_id, Types::String.optional

          # @!attribute [r] tag
          #   @return [String, nil]
          attribute? :tag, Types::String.optional

          attributes_from DateTimeMixin
          # @!attribute [r] from_at
          #   @return [DateTime, nil]

          # @!attribute [r] to_at
          #   @return [DateTime, nil]
        end

        class SearchFilterWithPagination < SearchFilter
          attributes_from PaginationMixin
          # @!attribute [r] page
          #   @return [Integer, nil]

          # @!attribute [r] limit
          #   @return [Integer, nil]

          def without_pagination
            SearchFilter.new(
              data_type: data_type,
              from_at: from_at,
              rule_id: rule_id,
              tag: tag,
              to_at: to_at
            )
          end
        end
      end

      module Alert
        class SearchFilter < Dry::Struct
          # @!attribute [r] artifact
          #   @return [String, nil]
          attribute? :artifact, Types::String.optional

          # @!attribute [r] rule_id
          #   @return [String, nil]
          attribute? :rule_id, Types::String.optional

          # @!attribute [r] tag
          #   @return [String, nil]
          attribute? :tag, Types::String.optional

          attributes_from DateTimeMixin
          # @!attribute [r] from_at
          #   @return [DateTime, nil]

          # @!attribute [r] to_at
          #   @return [DateTime, nil]
        end

        class SearchFilterWithPagination < SearchFilter
          attributes_from PaginationMixin
          # @!attribute [r] page
          #   @return [Integer, nil]

          # @!attribute [r] limit
          #   @return [Integer, nil]

          def without_pagination
            SearchFilter.new(
              artifact: artifact,
              from_at: from_at,
              rule_id: rule_id,
              tag: tag,
              to_at: to_at
            )
          end
        end
      end

      module Rule
        class SearchFilter < Dry::Struct
          # @!attribute [r] description
          #   @return [String, nil]
          attribute? :description, Types::String.optional

          # @!attribute [r] tag
          #   @return [String, nil]
          attribute? :tag, Types::String.optional

          # @!attribute [r] title
          #   @return [String, nil]
          attribute? :title, Types::String.optional

          attributes_from DateTimeMixin
          # @!attribute [r] from_at
          #   @return [DateTime, nil]

          # @!attribute [r] to_at
          #   @return [DateTime, nil]
        end

        class SearchFilterWithPagination < SearchFilter
          attributes_from PaginationMixin
          # @!attribute [r] page
          #   @return [Integer, nil]

          # @!attribute [r] limit
          #   @return [Integer, nil]

          def without_pagination
            SearchFilter.new(
              description: description,
              from_at: from_at,
              tag: tag,
              title: title,
              to_at: to_at
            )
          end
        end
      end
    end
  end
end

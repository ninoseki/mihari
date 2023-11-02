# frozen_string_literal: true

module Mihari
  module Structs
    module Filters
      module Alert
        class SearchFilter < Dry::Struct
          # @!attribute [r] artifact_data
          #   @return [String, nil]
          attribute? :artifact_data, Types::String.optional

          # @!attribute [r] rule_id
          #   @return [String, nil]
          attribute? :rule_id, Types::String.optional

          # @!attribute [r] tag_name
          #   @return [String, nil]
          attribute? :tag_name, Types::String.optional

          # @!attribute [r] from_at
          #   @return [DateTime, nil]
          attribute? :from_at, Types::DateTime.optional

          # @!attribute [r] to_at
          #   @return [DateTime, nil]
          attribute? :to_at, Types::DateTime.optional
        end

        class SearchFilterWithPagination < SearchFilter
          # @!attribute [r] page
          #   @return [Integer, nil]
          attribute? :page, Types::Int.default(1)

          # @!attribute [r] limit
          #   @return [Integer, nil]
          attribute? :limit, Types::Int.default(10)

          def without_pagination
            SearchFilter.new(
              artifact_data: artifact_data,
              from_at: from_at,
              rule_id: rule_id,
              tag_name: tag_name,
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

          # @!attribute [r] tag_name
          #   @return [String, nil]
          attribute? :tag_name, Types::String.optional

          # @!attribute [r] title
          #   @return [String, nil]
          attribute? :title, Types::String.optional

          # @!attribute [r] from_at
          #   @return [DateTime, nil]
          attribute? :from_at, Types::DateTime.optional

          # @!attribute [r] to_at
          #   @return [DateTime, nil]
          attribute? :to_at, Types::DateTime.optional
        end

        class SearchFilterWithPagination < SearchFilter
          # @!attribute [r] page
          #   @return [Integer, nil]
          attribute? :page, Types::Int.default(1)

          # @!attribute [r] limit
          #   @return [Integer, nil]
          attribute? :limit, Types::Int.default(10)

          def without_pagination
            SearchFilter.new(
              description: description,
              from_at: from_at,
              tag_name: tag_name,
              title: title,
              to_at: to_at
            )
          end
        end
      end
    end
  end
end

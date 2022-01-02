# frozen_string_literal: true

require "json"
require "dry/struct"

module Mihari
  module Structs
    module Alert
      class SearchFilter < Dry::Struct
        attribute? :artifact_data, Types::String.optional
        attribute? :description, Types::String.optional
        attribute? :source, Types::String.optional
        attribute? :tag_name, Types::String.optional
        attribute? :title, Types::String.optional
        attribute? :from_at, Types::DateTime.optional
        attribute? :to_at, Types::DateTime.optional
        attribute? :asn, Types::Int.optional
        attribute? :dns_record, Types::String.optional
        attribute? :reverse_dns_name, Types::String.optional

        def valid_artifact_filters?
          !(artifact_data || asn || dns_record || reverse_dns_name).nil?
        end
      end

      class SearchFilterWithPagination < SearchFilter
        attribute? :page, Types::Int.default(1)
        attribute? :limit, Types::Int.default(10)

        def without_pagination
          SearchFilter.new(
            artifact_data: artifact_data,
            description: description,
            from_at: from_at,
            source: source,
            tag_name: tag_name,
            title: title,
            to_at: to_at,
            asn: asn,
            dns_record: dns_record,
            reverse_dns_name: reverse_dns_name
          )
        end
      end
    end
  end
end

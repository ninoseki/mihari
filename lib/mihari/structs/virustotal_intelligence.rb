# frozen_string_literal: true

module Mihari
  module Structs
    module VirusTotalIntelligence
      class ContextAttributes < Dry::Struct
        attribute :url, Types.Array(Types::String).optional

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            url: d["url"]
          )
        end
      end

      class Datum < Dry::Struct
        attribute :type, Types::String
        attribute :id, Types::String
        attribute :context_attributes, ContextAttributes.optional

        def value
          case type
          when "file"
            id
          when "url"
            (context_attributes.url || []).first
          when "domain"
            id
          when "ip_address"
            id
          end
        end

        def self.from_dynamic!(d)
          d = Types::Hash[d]

          context_attributes = nil
          context_attributes = ContextAttributes.from_dynamic!(d.fetch("context_attributes")) if d.key?("context_attributes")

          new(
            type: d.fetch("type"),
            id: d.fetch("id"),
            context_attributes: context_attributes
          )
        end
      end

      class Meta < Dry::Struct
        attribute :cursor, Types::String.optional

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            cursor: d["cursor"]
          )
        end
      end

      class Response < Dry::Struct
        attribute :meta, Meta
        attribute :data, Types.Array(Datum)

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            meta: Meta.from_dynamic!(d.fetch("meta")),
            data: d.fetch("data").map { |x| Datum.from_dynamic!(x) }
          )
        end
      end
    end
  end
end

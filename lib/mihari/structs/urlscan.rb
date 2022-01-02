# frozen_string_literal: true

require "json"
require "dry/struct"

module Mihari
  module Structs
    module Urlscan
      class Page < Dry::Struct
        attribute :domain, Types::String.optional
        attribute :ip, Types::String.optional
        attribute :url, Types::String

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            domain: d["domain"],
            ip: d["ip"],
            url: d.fetch("url")
          )
        end
      end

      class Result < Dry::Struct
        attribute :page, Page
        attribute :id, Types::String
        attribute :sort, Types.Array(Types::String | Types::Integer)

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            page: Page.from_dynamic!(d.fetch("page")),
            id: d.fetch("_id"),
            sort: d.fetch("sort")
          )
        end
      end

      class Response < Dry::Struct
        attribute :results, Types.Array(Result)
        attribute :has_more, Types::Bool

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            results: d.fetch("results").map { |x| Result.from_dynamic!(x) },
            has_more: d.fetch("has_more")
          )
        end
      end
    end
  end
end

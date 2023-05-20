# frozen_string_literal: true

module Mihari
  module Structs
    module Urlscan
      class Page < Dry::Struct
        attribute :domain, Types::String.optional
        attribute :ip, Types::String.optional
        attribute :url, Types::String

        #
        # @return [String, nil]
        #
        def domain
          attributes[:domain]
        end

        #
        # @return [String, nil]
        #
        def ip
          attributes[:ip]
        end

        #
        # @return [String]
        #
        def url
          attributes[:url]
        end

        #
        # @param [Hash] d
        #
        # @return [Page]
        #
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
        attribute :metadata, Types::Hash

        #
        # @return [Page]
        #
        def page
          attributes[:page]
        end

        #
        # @return [String]
        #
        def id
          attributes[:id]
        end

        #
        # @return [Array<String, Integer>]
        #
        def sort
          attributes[:sort]
        end

        #
        # @return [Array<String, Integer>]
        #
        def metadata
          attributes[:metadata]
        end

        #
        # @return [Array<Mihari::Artifact>]
        #
        def to_artifacts
          values = [page.url, page.domain, page.ip].compact
          values.map do |value|
            Mihari::Artifact.new(data: value, metadata: metadata)
          end
        end

        #
        # @param [Hash] d
        #
        # @return [Result]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            page: Page.from_dynamic!(d.fetch("page")),
            id: d.fetch("_id"),
            sort: d.fetch("sort"),
            metadata: d
          )
        end
      end

      class Response < Dry::Struct
        attribute :results, Types.Array(Result)
        attribute :has_more, Types::Bool

        #
        # @return [Array<Result>]
        #
        def results
          attributes[:results]
        end

        #
        # @return [Boolean]
        #
        def has_more
          attributes[:has_more]
        end

        #
        # @return [Array<Mihari::Artifact>]
        #
        def to_artifacts
          results.map(&:to_artifacts).flatten
        end

        #
        # @param [Hash] d
        #
        # @return [Response]
        #
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

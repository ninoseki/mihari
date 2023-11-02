# frozen_string_literal: true

module Mihari
  module Structs
    module Urlscan
      class Page < Dry::Struct
        # @!attribute [r] domain
        #   @return [String]
        attribute :domain, Types::String.optional

        # @!attribute [r] ip
        #   @return [String, nil]
        attribute :ip, Types::String.optional

        # @!attribute [r] url
        #   @return [String]
        attribute :url, Types::String

        class << self
          #
          # @param [Hash] d
          #
          # @return [Page]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              domain: d["domain"],
              ip: d["ip"],
              url: d.fetch("url")
            )
          end
        end
      end

      class Result < Dry::Struct
        # @!attribute [r] page
        #   @return [Page]
        attribute :page, Page

        # @!attribute [r] pid
        #   @return [String]
        attribute :id, Types::String

        # @!attribute [r] sort
        #   @return [Array<String, Integer>]
        attribute :sort, Types.Array(Types::String | Types::Int)

        # @!attribute [r] metadata
        #   @return [Hash]
        attribute :metadata, Types::Hash

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          values = [page.url, page.domain, page.ip].compact
          values.map { |value| Mihari::Models::Artifact.new(data: value, metadata: metadata) }
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Result]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              page: Page.from_dynamic!(d.fetch("page")),
              id: d.fetch("_id"),
              sort: d.fetch("sort"),
              metadata: d
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] results
        #   @return [Array<Result>]
        attribute :results, Types.Array(Result)

        # @!attribute [r] has_more
        #   @return [Boolean]
        attribute :has_more, Types::Bool

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          results.map(&:artifacts).flatten
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Response]
          #
          def from_dynamic!(d)
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
end

# frozen_string_literal: true

module Mihari
  module Structs
    module VirusTotalIntelligence
      class ContextAttributes < Dry::Struct
        # @!attribute [r] url
        #   @return [String, nil]
        attribute :url, Types::String.optional

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(url: d["url"])
          end
        end
      end

      class Datum < Dry::Struct
        # @!attribute [r] type
        #   @return [String]
        attribute :type, Types::String

        # @!attribute [r] id
        #   @return [String]
        attribute :id, Types::String

        # @!attribute [r] context_attributes
        #   @return [ContextAttributes, nil]
        attribute :context_attributes, ContextAttributes.optional

        # @!attribute [r] metadata
        #   @return [Hash]
        attribute :metadata, Types::Hash

        #
        # @return [String, nil]
        #
        def value
          case type
          when "file"
            id
          when "url"
            context_attributes&.url
          when "domain"
            id
          when "ip_address"
            id
          end
        end

        #
        # @return [Mihari::Models::Artifact]
        #
        def artifact
          Models::Artifact.new(data: value, metadata: metadata)
        end

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]

            context_attributes = nil
            if d.key?("context_attributes")
              context_attributes = ContextAttributes.from_dynamic!(d.fetch("context_attributes"))
            end

            new(
              type: d.fetch("type"),
              id: d.fetch("id"),
              context_attributes: context_attributes,
              metadata: d
            )
          end
        end
      end

      class Meta < Dry::Struct
        # @!attribute [r] cursor
        #   @return [String, nil]
        attribute :cursor, Types::String.optional

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              cursor: d["cursor"]
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] meta
        #   @return [Meta]
        attribute :meta, Meta

        # @!attribute [r] data
        #   @return [Array<Datum>]
        attribute :data, Types.Array(Datum)

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          data.map(&:artifact)
        end

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
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
end

# frozen_string_literal: true

module Mihari
  module Structs
    module VirusTotalIntelligence
      class ContextAttributes < Dry::Struct
        attribute :url, Types::String.optional

        #
        # @return [String, nil]
        #
        def url
          attributes[:url]
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [ContextAttributes]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(url: d["url"])
          end
        end
      end

      class Datum < Dry::Struct
        attribute :type, Types::String
        attribute :id, Types::String
        attribute :context_attributes, ContextAttributes.optional
        attribute :metadata, Types::Hash

        #
        # @return [String]
        #
        def type
          attributes[:type]
        end

        #
        # @return [String]
        #
        def id
          attributes[:id]
        end

        #
        # @return [ContextAttributes, nil]
        #
        def context_attributes
          attributes[:context_attributes]
        end

        #
        # @return [Hash, nil]
        #
        def metadata
          attributes[:metadata]
        end

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
          # @return [Datum]
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
        attribute :cursor, Types::String.optional

        #
        # @return [String, nil]
        #
        def cursor
          attributes[:cursor]
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Meta]
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
        attribute :meta, Meta
        attribute :data, Types.Array(Datum)

        #
        # @return [Meta]
        #
        def meta
          attributes[:meta]
        end

        #
        # @return [Array<Datum>]
        #
        def data
          attributes[:data]
        end

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
          # @return [Response]
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

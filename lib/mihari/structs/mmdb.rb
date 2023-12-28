# frozen_string_literal: true

module Mihari
  module Structs
    module MMDB
      class Country < Dry::Struct
        # @!attribute [r] iso_code
        #   @return [String]
        attribute :iso_code, Types::String

        # @!attribute [r] autonomous_system_number
        #   @return [String]
        attribute :autonomous_system_number, Types::String.optional

        class << self
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              iso_code: d.fetch("iso_code"),
              autonomous_system_number: d["AutonomousSystemNumber"]
            )
          end
        end
      end

      class CountryInfo < Dry::Struct
        # @!attribute [r] latitude
        #   @return [String]
        attribute :latitude, Types::String

        # @!attribute [r] longitude
        #   @return [String]
        attribute :longitude, Types::String

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            latitude: d.fetch("Latitude (average)"),
            longitude: d.fetch("Longitude (average)")
          )
        end

        class << self
          def from_json!(json)
            from_dynamic!(JSON.parse(json))
          end
        end
      end

      class Item < Dry::Struct
        # @!attribute [r] country
        #   @return [Country]
        attribute :country, Country

        # @!attribute [r] country_info
        #   @return [CountryInfo]
        attribute :country_info, CountryInfo

        class << self
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              country: Country.from_dynamic!(d.fetch("country")),
              country_info: CountryInfo.from_dynamic!(d.fetch("country_info"))
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] items
        #   @return [Array<Item>]
        attribute :items, Types.Array(Item)

        #
        # @return [Item, nil]
        #
        def item
          items.find { |item| item.country.autonomous_system_number }
        end

        #
        # @return [Integer, nil]
        #
        def asn
          item&.country&.autonomous_system_number&.to_i
        end

        #
        # @return [String, nil]
        #
        def country_code
          item&.country&.iso_code
        end

        #
        # @return [String, nil]
        #
        def loc
          return nil if item.nil?

          [item.country_info.latitude, item.country_info.longitude].join(",")
        end

        class << self
          def from_dynamic!(d)
            new(
              items: d.map { |x| Item.from_dynamic!(x) }
            )
          end
        end
      end
    end
  end
end

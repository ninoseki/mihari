# frozen_string_literal: true

module Mihari
  module Structs
    module GooglePublicDNS
      INT_TYPE_TO_TYPE = {
        1 => "A",
        2 => "NS",
        5 => "CNAME",
        16 => "TXT",
        28 => "AAAA"
      }.freeze

      class Answer < Dry::Struct
        # @!attribute [r] name
        #   @return [String]
        attribute :name, Types::String

        # @!attribute [r] data
        #   @return [String]
        attribute :data, Types::String

        # @!attribute [r] resource_type
        #   @return [String]
        attribute :resource_type, Types::String

        class << self
          #
          # @param [Hash] d
          #
          # @return [Answer]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            resource_type = INT_TYPE_TO_TYPE[d.fetch("type")]
            new(
              name: d.fetch("name"),
              data: d.fetch("data"),
              resource_type: resource_type
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] answers
        #   @return [Array<Answer>]
        attribute :answers, Types.Array(Answer)

        class << self
          #
          # @param [Hash] d
          #
          # @return [Response]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              answers: d.fetch("Answer", []).map { |x| Answer.from_dynamic!(x) }
            )
          end
        end
      end
    end
  end
end

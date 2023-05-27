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
        attribute :name, Types::String
        attribute :data, Types::String
        attribute :resource_type, Types::String

        #
        # @return [String]
        #
        def name
          attributes[:name]
        end

        #
        # @return [String]
        #
        def data
          attributes[:data]
        end

        #
        # @return [String]
        #
        def resource_type
          attributes[:resource_type]
        end

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
        attribute :answers, Types.Array(Answer)

        #
        # @return [Array<Answer>]
        #
        def answers
          attributes[:answers]
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
              answers: d.fetch("Answer", []).map { |x| Answer.from_dynamic!(x) }
            )
          end
        end
      end
    end
  end
end

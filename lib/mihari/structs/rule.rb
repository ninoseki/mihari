# frozen_string_literal: true

module Mihari
  module Structs
    module Rule
      class SearchFilter < Dry::Struct
        attribute? :description, Types::String.optional
        attribute? :tag_name, Types::String.optional
        attribute? :title, Types::String.optional
        attribute? :from_at, Types::DateTime.optional
        attribute? :to_at, Types::DateTime.optional
      end

      class SearchFilterWithPagination < SearchFilter
        attribute? :page, Types::Int.default(1)
        attribute? :limit, Types::Int.default(10)

        def without_pagination
          SearchFilter.new(
            description: description,
            from_at: from_at,
            tag_name: tag_name,
            title: title,
            to_at: to_at
          )
        end
      end

      class Rule
        # @return [Hash]
        attr_reader :data

        # @return [String]
        attr_reader :yaml

        # @return [Array, nil]
        attr_reader :errors

        # @return [String]
        attr_writer :id

        def initialize(data, yaml)
          @data = data.deep_symbolize_keys
          @yaml = yaml

          @errors = nil
          @no_method_error = nil

          validate
        end

        #
        # @return [Boolean]
        #
        def errors?
          return false if @errors.nil?

          !@errors.empty?
        end

        #
        # @return [Array<String>]
        #
        def error_messages
          return [] if @errors.nil?

          @errors.messages.map do |message|
            path = message.path.map(&:to_s).join
            "#{path} #{message.text}"
          end
        end

        def validate
          begin
            contract = Schemas::RuleContract.new
            result = contract.call(data)
          rescue NoMethodError => e
            @no_method_error = e
            return
          end

          @data = result.to_h
          @errors = result.errors
        end

        def validate!
          raise RuleValidationError, "Data should be a hash" unless data.is_a?(Hash)

          raise RuleValidationError, error_messages.join("\n") if errors?

          raise RuleValidationError, "Something wrong with queries or emitters." unless @no_method_error.nil?
        end

        def [](key)
          data[key.to_sym]
        end

        #
        # @return [String]
        #
        def id
          @id ||= data[:id] || UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, data.to_yaml).to_s
        end

        #
        # @return [String]
        #
        def title
          @title ||= data[:title]
        end

        #
        # @return [String]
        #
        def description
          @description ||= data[:description]
        end

        #
        # @return [Mihari::Rule]
        #
        def to_model
          rule = Mihari::Rule.find(id)

          rule.title = title
          rule.description = description
          rule.data = data
          rule.yaml = yaml

          rule
        rescue ActiveRecord::RecordNotFound
          Mihari::Rule.new(
            id: id,
            title: title,
            description: description,
            data: data,
            yaml: yaml
          )
        end

        #
        # @return [Mihari::Analyzers::Rule]
        #
        def to_analyzer
          analyzer = Mihari::Analyzers::Rule.new(
            title: self[:title],
            description: self[:description],
            tags: self[:tags],
            queries: self[:queries],
            allowed_data_types: self[:allowed_data_types],
            disallowed_data_values: self[:disallowed_data_values],
            emitters: self[:emitters],
            enrichers: self[:enrichers],
            id: id
          )
          analyzer.ignore_old_artifacts = self[:ignore_old_artifacts]
          analyzer.ignore_threshold = self[:ignore_threshold]

          analyzer
        end

        class << self
          include Mixins::Rule

          #
          # @param [Mihari::Rule] model
          #
          # @return [Mihari::Structs::Rule::Rule]
          #
          def from_model(model)
            data = model.data.deep_symbolize_keys
            data[:id] = model.id unless data.key?(:id)

            Structs::Rule::Rule.new(data, model.yaml)
          end

          #
          # @param [String] yaml
          #
          # @return [Mihari::Structs::Rule::Rule]
          #
          def from_yaml(yaml)
            data = load_erb_yaml(yaml)
            Structs::Rule::Rule.new(data, yaml)
          end
        end
      end
    end
  end
end

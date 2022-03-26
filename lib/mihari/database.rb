# frozen_string_literal: true

def env
  ENV["APP_ENV"] || ENV["RACK_ENV"]
end

def test_env?
  env == "test"
end

def development_env?
  env == "development"
end

class InitialSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :tags, if_not_exists: true do |t|
      t.string :name, null: false
    end

    create_table :alerts, if_not_exists: true do |t|
      t.string :title, null: false
      t.string :description, null: true
      t.string :source, null: false
      t.timestamps
    end

    create_table :artifacts, if_not_exists: true do |t|
      t.string :data, null: false
      t.string :data_type, null: false
      t.belongs_to :alert, foreign_key: true
      t.timestamps
    end

    create_table :taggings, if_not_exists: true do |t|
      t.integer :tag_id
      t.integer :alert_id
    end

    add_index :taggings, :tag_id, if_not_exists: true
    add_index :taggings, [:tag_id, :alert_id], unique: true, if_not_exists: true
  end
end

class AddeSourceToArtifactSchema < ActiveRecord::Migration[7.0]
  def change
    add_column :artifacts, :source, :string, if_not_exists: true
  end
end

class EnrichmentsSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :autonomous_systems, if_not_exists: true do |t|
      t.integer :asn, null: false
      t.belongs_to :artifact, foreign_key: true
    end

    create_table :geolocations, if_not_exists: true do |t|
      t.string :country, null: false
      t.string :country_code, null: false
      t.belongs_to :artifact, foreign_key: true
    end

    create_table :whois_records, if_not_exists: true do |t|
      t.string :domain, null: false
      t.date :created_on
      t.date :updated_on
      t.date :expires_on
      t.json :registrar
      t.json :contacts
      t.belongs_to :artifact, foreign_key: true
    end

    create_table :dns_records, if_not_exists: true do |t|
      t.string :resource, null: false
      t.string :value, null: false
      t.belongs_to :artifact, foreign_key: true
    end

    create_table :reverse_dns_names, if_not_exists: true do |t|
      t.string :name, null: false
      t.belongs_to :artifact, foreign_key: true
    end
  end
end

class EnrichmentCreatedAtSchema < ActiveRecord::Migration[7.0]
  def change
    # Add created_at column because now it is able to enrich an atrifact after the creation
    add_column :autonomous_systems, :created_at, :datetime, if_not_exists: true
    add_column :geolocations, :created_at, :datetime, if_not_exists: true
    add_column :whois_records, :created_at, :datetime, if_not_exists: true
    add_column :dns_records, :created_at, :datetime, if_not_exists: true
    add_column :reverse_dns_names, :created_at, :datetime, if_not_exists: true
  end
end

class RuleSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :rules, id: :string, if_not_exists: true do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.json :data, null: false
      t.timestamps
    end
  end
end

class AddeMetadataToArtifactSchema < ActiveRecord::Migration[7.0]
  def change
    add_column :artifacts, :metadata, :json, if_not_exists: true
  end
end

class AddYAMLToRulesSchema < ActiveRecord::Migration[7.0]
  def change
    add_column :rules, :yaml, :text, if_not_exists: true
  end
end

def adapter
  return "postgresql" if Mihari.config.database.start_with?("postgresql://", "postgres://")
  return "mysql2" if Mihari.config.database.start_with?("mysql2://")

  "sqlite3"
end

module Mihari
  class Database
    class << self
      include Memist::Memoizable

      #
      # DB migraration
      #
      # @param [Symbol] direction
      #
      def migrate(direction)
        ActiveRecord::Migration.verbose = false

        [
          InitialSchema,
          AddeSourceToArtifactSchema,
          EnrichmentsSchema,
          EnrichmentCreatedAtSchema,
          # v4.0
          RuleSchema,
          AddeMetadataToArtifactSchema,
          # v4.4
          AddYAMLToRulesSchema
        ].each { |schema| schema.migrate direction }
      end
      memoize :migrate unless test_env?

      #
      # Establish DB connection
      #
      def connect
        return if ActiveRecord::Base.connected?

        case adapter
        when "postgresql", "mysql2"
          ActiveRecord::Base.establish_connection(Mihari.config.database)
        else
          ActiveRecord::Base.establish_connection(
            adapter: adapter,
            database: Mihari.config.database
          )
        end

        ActiveRecord::Base.logger = Logger.new($stdout) if development_env?

        migrate :up
      rescue StandardError
        # Do nothing
      end

      #
      # Close DB connection(s)
      #
      def close
        return unless ActiveRecord::Base.connected?

        ActiveRecord::Base.clear_active_connections!
      end

      #
      # Destory DB
      #
      def destroy!
        return unless ActiveRecord::Base.connected?

        migrate :down
      end
    end
  end
end

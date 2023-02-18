# frozen_string_literal: true

# Make possible to use upper case acronyms in class names
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "CPE"
end

def env
  ENV["APP_ENV"] || ENV["RACK_ENV"]
end

def test_env?
  env == "test"
end

def development_env?
  env == "development"
end

class V5Schema < ActiveRecord::Migration[7.0]
  def change
    create_table :rules, id: :string, if_not_exists: true do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.json :data, null: false
      t.timestamps
    end

    create_table :alerts, if_not_exists: true do |t|
      t.timestamps

      t.belongs_to :rule, foreign_key: true, type: :string, null: false
    end

    create_table :artifacts, if_not_exists: true do |t|
      t.string :data, null: false
      t.string :data_type, null: false
      t.string :source
      t.json :metadata
      t.timestamps

      t.belongs_to :alert, foreign_key: true, null: false
    end

    create_table :autonomous_systems, if_not_exists: true do |t|
      t.integer :asn, null: false
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    create_table :geolocations, if_not_exists: true do |t|
      t.string :country, null: false
      t.string :country_code, null: false
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    create_table :whois_records, if_not_exists: true do |t|
      t.string :domain, null: false
      t.date :created_on
      t.date :updated_on
      t.date :expires_on
      t.json :registrar
      t.json :contacts
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    create_table :dns_records, if_not_exists: true do |t|
      t.string :resource, null: false
      t.string :value, null: false
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    create_table :reverse_dns_names, if_not_exists: true do |t|
      t.string :name, null: false
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    create_table :cpes, if_not_exists: true do |t|
      t.string :cpe, null: false
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    create_table :ports, if_not_exists: true do |t|
      t.integer :port, null: false
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    create_table :tags, if_not_exists: true do |t|
      t.string :name, null: false
      t.datetime :created_at
    end

    create_table :taggings, if_not_exists: true do |t|
      t.integer :tag_id
      t.integer :alert_id
      t.datetime :created_at
    end

    add_index :taggings, :tag_id, if_not_exists: true
    add_index :taggings, %i[tag_id alert_id], unique: true, if_not_exists: true
  end
end

def adapter
  return "postgresql" if %w[postgresql postgres].include?(Mihari.config.database_url.scheme)
  return "mysql2" if Mihari.config.database_url.scheme == "mysql2"

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

        [V5Schema].each { |schema| schema.migrate direction }
      end
      memoize :migrate unless test_env?

      #
      # Establish DB connection
      #
      def connect
        return if ActiveRecord::Base.connected?

        case adapter
        when "postgresql", "mysql2"
          ActiveRecord::Base.establish_connection(Mihari.config.database_url)
        else
          ActiveRecord::Base.establish_connection(
            adapter: adapter,
            database: Mihari.config.database_url.path[1..]
          )
        end

        ActiveRecord::Base.logger = Logger.new($stdout) if development_env?

        migrate :up
      rescue StandardError => e
        Mihari.logger.error e
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

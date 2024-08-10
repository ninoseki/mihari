# frozen_string_literal: true

# Make possible to use upper case acronyms in class names
ActiveSupport::Inflector.inflections(:en) { |inflect| inflect.acronym "CPE" }

#
# Mihari v7 DB schema
#
class V7Schema < ActiveRecord::Migration[7.2]
  def change
    create_table :rules, id: :string, if_not_exists: true do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.json :data, null: false
      t.timestamps
    end

    create_table :alerts, if_not_exists: true do |t|
      t.datetime :created_at

      t.belongs_to :rule, foreign_key: true, type: :string, null: false
    end

    create_table :artifacts, if_not_exists: true do |t|
      t.string :data, null: false
      t.string :data_type, null: false
      t.string :source
      t.string :query
      t.json :metadata
      t.datetime :created_at

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
      t.string :rule_id
      t.datetime :created_at
    end

    add_index :taggings, :tag_id, if_not_exists: true
    add_index :taggings, %i[tag_id rule_id], unique: true, if_not_exists: true
  end
end

class V72Schema < ActiveRecord::Migration[7.1]
  def change
    create_table :vulnerabilities, if_not_exists: true do |t|
      t.string :name, null: false
      t.datetime :created_at

      t.belongs_to :artifact, foreign_key: true, null: false
    end

    rename_column :cpes, :cpe, :name if ActiveRecord::Base.connection.column_exists?(:cpes, :cpe)
    rename_column :autonomous_systems, :asn, :number if ActiveRecord::Base.connection.column_exists?(
      :autonomous_systems, :asn
    )
    rename_column :ports, :port, :number if ActiveRecord::Base.connection.column_exists?(:ports, :port)
  end
end

#
# @return [Array<ActiveRecord::Migration>] schemas
#
def schemas
  [V7Schema, V72Schema]
end

module Mihari
  #
  # Database
  #
  class Database
    class << self
      #
      # DB migration
      #
      # @param [Symbol] direction
      #
      def migrate(direction)
        schemas.each { |schema| schema.migrate direction }
      end

      #
      # Establish DB connection
      #
      def connect
        return if connected?

        ActiveRecord::Base.establish_connection Mihari.config.database_url.to_s
        ActiveRecord::Base.logger = Logger.new($stdout) if Mihari.development?
      end

      #
      # @return [Boolean]
      #
      def connected?
        ActiveRecord::Base.connected?
      end

      #
      # Close DB connection(s)
      #
      def close
        return unless connected?

        ActiveRecord::Base.connection_handler.clear_active_connections!
      end

      def with_db_connection
        Mihari::Database.connect unless connected?
        yield
      rescue ActiveRecord::StatementInvalid
        Mihari.logger.error("DB migration is not yet complete. Please run 'mihari db migrate'.")
      ensure
        Mihari::Database.close
      end

      private

      def adapter
        return "postgresql" if %w[postgresql postgres].include?(Mihari.config.database_url.scheme)
        return "mysql2" if Mihari.config.database_url.scheme == "mysql2"

        "sqlite3"
      end
    end
  end
end

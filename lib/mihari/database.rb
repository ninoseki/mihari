# frozen_string_literal: true

require "active_record"

class InitialSchema < ActiveRecord::Migration[6.0]
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

def adapter
  return "postgresql" if Mihari.config.database.start_with?("postgresql://", "postgres://")
  return "mysql2" if Mihari.config.database.start_with?("mysql2://")

  "sqlite3"
end

module Mihari
  class Database
    class << self
      def connect
        case adapter
        when "postgresql", "mysql2"
          ActiveRecord::Base.establish_connection(Mihari.config.database)
        else
          ActiveRecord::Base.establish_connection(
            adapter: adapter,
            database: Mihari.config.database
          )
        end

        ActiveRecord::Migration.verbose = false
        InitialSchema.migrate(:up)
      rescue StandardError
        # Do nothing
      end

      def close
        ActiveRecord::Base.clear_active_connections!
        ActiveRecord::Base.connection.close
      end

      def destroy!
        InitialSchema.migrate(:down) if ActiveRecord::Base.connected?
      end
    end
  end
end

Mihari::Database.connect

require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseEasyOmniauthableInstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      argument :name, type: :string, default: "DeviseEasyOmniauthableAuthentications", desc: "The name of the authentifications table.", banner: "NAME"

      def copy_migration
        migration_template "create_authentications.rb", "db/migrate/create_#{table_name}"
      end
    end
  end
end

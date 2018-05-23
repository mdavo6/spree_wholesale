module SpreeWholesale
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :skip_migrations, :type => :boolean, :default => false, :description => "Skips the `run_migrations` step"

      desc "Installs required stylesheets, javascripts and migrations for spree_wholesale"

      def add_javascripts
        append_file "vendor/assets/javascripts/spree/frontend/all.js", "//= require wholesaler_address_frontend\n"
        append_file "vendor/assets/javascripts/spree/backend/all.js", "//= require wholesaler_address_backend\n"
      end

      def install_migrations
        rake "spree_wholesale:install:migrations"
      end

    end
  end
end

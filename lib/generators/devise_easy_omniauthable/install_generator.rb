module DeviseEasyOmniauthable
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      desc "Add DeviseEasyOmniauthable module, add config variables to the Devise
        initializer and copy locale files and assets to your application."

      argument :name, type: :string, default: "User", desc: "The Devise model this module should be added to.", banner: "NAME"
      class_option :initializer, type: :string, default: 'config/initializers/devise.rb', desc: 'Specify the Devise initializer path.', banner: 'PATH'

      def add_module
        path = File.join("app", "models", "#{file_path}.rb")
        if File.exists?(path)
          inject_into_file(path, "omniauthable, :", after: "devise :")
          inject_into_file(path, "easy_omniauthable, :", after: "devise :")
        else
          say_status "error", "Model not found. Expected to be #{path}.", :red
        end
      end

      def add_config_options_to_initializer
        initializer = options['initializer']

        if File.exist?(initializer)
          old_content = File.read(initializer)

          unless old_content.match(/# ==> Configuration for :easy_omniauthable/)
            puts "add initializer options"
            inject_into_file(initializer, before: "  # ==> Configuration for :confirmable\n") do
<<-CONTENT
  # ==> Configuration for :easy_omniauthable
  # Let your users login and sign-up easily by using social website logins.
  # Visit the following developer websites and get app id and app secret
  # for every service you want to add.

  # https://dev.twitter.com/apps
  # config.omniauth :twitter, 'YOUR_APP_ID', 'YOUR_APP_SECRET'

  # https://developers.facebook.com/apps
  # config.omniauth :facebook, 'YOUR_APP_ID', 'YOUR_APP_SECRET'

  # https://cloud.google.com/console
  # config.omniauth :google_oauth2, 'YOUR_APP_ID', 'YOUR_APP_SECRET'

  # https://github.com/settings/applications
  # config.omniauth :github, 'YOUR_APP_ID', 'YOUR_APP_SECRET', scope: 'user:email'

CONTENT
            end
          end
        end
      end

      hook_for :orm, as: :devise_easy_omniauthable_install
    end
  end
end

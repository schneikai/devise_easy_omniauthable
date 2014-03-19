module DeviseEasyOmniauthable
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) { include DeviseEasyOmniauthable::UrlHelpers }
    ActiveSupport.on_load(:action_view) { include DeviseEasyOmniauthable::UrlHelpers }

    # We use to_prepare instead of after_initialize here because Devise is a
    # Rails engine and its classes are reloaded like the rest of the user's app.
    # Got to make sure that our methods are included each time.
    config.to_prepare do
      Devise::RegistrationsController.send :include, DeviseEasyOmniauthable::RegistrationsController
    end

    # When the mapping was loaded included via "to_prepare" I was getting
    # weired errros on the routes like stack level too deep or routes disappear
    # completely. Trying "after_initialize" now.
    config.after_initialize do
      Devise::Mapping.send :include, DeviseEasyOmniauthable::Mapping
    end
  end
end

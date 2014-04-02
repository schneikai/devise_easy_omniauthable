require 'devise'
require 'devise_easy_omniauthable/devise'
require 'devise_easy_omniauthable/routes'

# require 'devise_easy_omniauthable/omniauth_info'
Dir[File.dirname(__FILE__) + '/devise_easy_omniauthable/providers/*.rb'].each {|file| require file }

module DeviseEasyOmniauthable
  autoload :Controller, 'devise_easy_omniauthable/controller'
  autoload :RegistrationsController, 'devise_easy_omniauthable/registrations_controller'
  autoload :UrlHelpers, 'devise_easy_omniauthable/url_helpers'
  autoload :Mapping, 'devise_easy_omniauthable/mapping'
  autoload :VERSION, 'devise_easy_omniauthable/version'
end

require 'devise_easy_omniauthable/engine'

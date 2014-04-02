module Devise
  # If +true+ it will generate routes to allow the user to view and remove
  # 3rd party authentifications.
  mattr_accessor :omniauth_manageable
  @@omniauth_manageable = true
end

Devise.add_module :easy_omniauthable, model: 'devise_easy_omniauthable/model', route: :easy_omniauthable

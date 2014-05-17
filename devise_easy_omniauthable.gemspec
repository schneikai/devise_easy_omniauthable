$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise_easy_omniauthable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise_easy_omniauthable"
  s.version     = DeviseEasyOmniauthable::VERSION
  s.authors     = ["Kai Schneider"]
  s.email       = ["schneikai@gmail.com"]
  s.homepage    = "https://github.com/schneikai/devise_easy_omniauthable"
  s.summary     = "Devise sign-in and sign-up via Facebook, Twitter, Google+, Github as easy as adding you App-ID and -Secret."
  s.description = s.summary

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "devise", "~> 3.0"

  s.add_dependency "omniauth-twitter", "~> 1.0"
  s.add_dependency "twitter", "~> 5"
  s.add_dependency "omniauth-facebook", "~> 1.6"
  s.add_dependency "fb_graph", "~> 2.7"
  s.add_dependency "omniauth-google-oauth2", "~> 0.2"
  s.add_dependency "omniauth-github", "~> 1.1"

  s.add_development_dependency "jquery-rails"
  s.add_development_dependency "sqlite3"
end

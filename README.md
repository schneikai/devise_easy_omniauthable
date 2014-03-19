# DeviseEasyOmniauthable

DeviseEasyOmniauthable adds sign-in and sign-up with Facebook, Twitter, Google+,
Github and other authorization providers to [Devise](https://github.com/plataformatec/devise).
You simply need to get a App-ID and -Secret for the authorization provider
you want to use and you are ready to go.

DeviseEasyOmniauthable supports Rails 4 and Devise 3.

This implementation was inspired by
http://www.orhancanceylan.com/rails-twitter-and-facebook-authentications-with-omniauth-and-devise/


## Installation

You must have installed and configured Devise first. Follow the guides on
https://github.com/plataformatec/devise.

Add DeviseEasyOmniauthable to your Gemfile and run the bundle command to install it:

```ruby
gem 'devise_easy_omniauthable'
```

After the gem is installed you need to run the install generator:

```console
rails generate devise_easy_omniauthable:install
```

This will add the easy_omniauthable module to Devise, add configuration options
to the Devise initializer and add required javascripts and stylesheets to your
application.

Now open the Devise initializer <tt>config/initializers/devise.rb</tt>, search
for "Configuration for :easy_omniauthable" and add App-ID and -Secret for every
authentification provider you want to use. For example to add Twitter go to
https://dev.twitter.com/apps request APP-ID and -Secret and add it in the
Devise initializer like this:

```ruby
config.omniauth :twitter, 'YOUR_APP_ID', 'YOUR_APP_SECRET'
```

And that's it. The Login and Register views now show links to sign-in and
sign-up via Twitter.


## Show or hide the password fields

When users sign-up or sign-in via Omniauth (Twitter for example)
this becomes their password so when they want to edit their account data like
email address you can't ask for the current password because they don't have one.
To take care of this you need to change the devise default views a little bit.

First, if you haven't already, you need to generate the devise views via

```console
rails generate devise:views
```

Open <tt>app/views/devise/registrations/new.html.erb</tt> and wrap the password
and password confirmation fields to only show when they are required:

```ruby
<% if resource.password_required? %>
  <div><%= f.label :password %><br />
  <%= f.password_field :password %></div>

  <div><%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation %></div>
<% end %>
```

Now open <tt>app/views/devise/registrations/edit.html.erb</tt> and wrap password,
password confirmation (those two fields are used to change the current password)
and current password (this is used to confirm any changes with the current password)
to only show if the user has a password:

```ruby
<% if resource.password? %>
  <div><%= f.label :password %> <i>(leave blank if you don't want to change it)</i><br />
  <%= f.password_field :password, :autocomplete => "off" %></div>

  <div><%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation %></div>

  <div><%= f.label :current_password %> <i>(we need your current password to confirm your changes)</i><br />
  <%= f.password_field :current_password %></div>
<% end %>
```

You might wonder why you need to change the signup form when that is actually supposed
to by done via Omniauth? Imagine a user is signing up through Twitter
and unfortunately the username he uses on Twitter is already taken by another
user on your website. In that case we need to take the user to the signup page
where he can chose another username.


## Let users remove authorizations

TODO: Write about the authorizations controller.


## Security

When users sign up via Omniauth they do not have a password and we can't ask for
a current password when updating account info like the email address.
You have to decide for your App if this is acceptable.


## Translations

DeviseEasyOmniauthable uses the following
[locales](https://github.com/schneikai/devise_easy_omniauthable/blob/master/config/locales).
Add or change translations by adding or overwriting these files in your app.


## TODO
* add tests
* check if this works with multiple Devise models like user and admin. If not, make it work.
* add more providers (LinkedIn, Xing, ...)
* when logged in allow the user to add more authorizations
  so the website can for example post stuff he did there to his Twitter or Facebook
* encrypt Omniauth tokens?


## Licence

MIT-LICENSE. Copyright 2014 Kai Schneider.

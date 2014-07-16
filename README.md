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
https://dev.twitter.com/apps and create a application. If you have problem check
"Supported providers > Twitter" in this README. Now get your  APP-ID and -Secret
and add it in the Devise initializer like this:

```ruby
config.omniauth :twitter, 'YOUR_APP_ID', 'YOUR_APP_SECRET'
```

And that's it. The Login and Register views now show links to sign-in and
sign-up via Twitter.


## Supported providers

* [Twitter](https://dev.twitter.com/apps)
* [Facebook](https://developers.facebook.com/apps)
* [Google+](https://cloud.google.com/console)
* [GitHub](https://github.com/settings/applications)

You are most welcome to add more if you like :)

### Twitter

To get your APP-ID and -Secret go to https://dev.twitter.com/apps. Login to your
existing Twitter account or create a new one. Now create a application.
Fill out all details and make sure you tick "Allow this application to be used
to Sign in with Twitter". If for example your website would be `http://www.example.com`
the Callback URL would be `https://www.example.com/users/auth/twitter` but it doesn't
really matter as long as you have anything there because Twitter allows to send
the Callback URL together with the authentication request what we do.

The Twitter permission model only has three modalities: read-only, read-write,
and read-write plus the ability to read direct messages. You have no finer controls.
For simple "Sign in with Twitter" read-only permission is enough.

When you have everything setup copy APP-ID and -Secret and past it into the Devise
initializer like this:

```ruby
config.omniauth :twitter, 'YOUR_APP_ID', 'YOUR_APP_SECRET'
```

For more information checkout [OmniAuth Twitter](https://github.com/arunagw/omniauth-twitter).

### Facebook

To get your APP-ID and -Secret go to https://developers.facebook.com/apps.
Login to your existing Facebook account or create a new one. Now create a new application.
Fill out all important details. Facebook requires you to to specify a Site URL and
App Domain(s). This is important for the redirect after authentication. For example
if your website is `http://www.example.com` this is your Site URL and the App Domain
would be `example.com`. If you have multiple versions of your website on
different domains just add those to the App Domains list. For example if your
website is available via `https://www.example.de` just add `example.de`
to the App Domains list.

When you have everything setup copy APP-ID and -Secret and past it into the Devise/Hive
initializer like this:

```ruby
config.omniauth :facebook, 'YOUR_APP_ID', 'YOUR_APP_SECRET', scope: 'basic_info, email'
```

This will also setup permissions (aka scope) that controls what data and actions
you request from a user. We added `basic_info, email` which is just fine for
"Sign in with Facebook". For other permissions you can read on here
https://developers.facebook.com/docs/facebook-login/permissions#reference.

If you want to test the Facebook connection in local development mode you need
to change the Site URL to something like "http://localhost:3000" or whatever it
is for your development website. You can't use IP-Addresses though. Remember to
change it back when you go live. You could also consider adding another
application and use those credentials for development.

For more information checkout [OmniAuth Facebook](https://github.com/mkdynamic/omniauth-facebook).

### Google

To get your Client-ID and -Secret go to https://cloud.google.com/console.
Login to your existing Google account or create a new one. Now create a new project.
When that is done click on "APIs & Auth" and then on "Credentials" in the left hand
menu. Now click the "Create new client id" button.

If your website is for example `http://www.example.com` you would fill in
the following for `Authorized JavaScript origins`:

```
https://www.example.com
https://example.de
```

And for `Authorized redirect URI`:

```
https://www.example.com/users/auth/google_oauth2/callback
https://example.com/users/auth/google_oauth2/callback
```

If you are using [Hive](https://github.com/schneikai/hive) the redirect URL
would be `https://www.example.com/account/auth/google_oauth2/callback`.

If you like to test in local development mode just add `http://localhost:3000` to
`Authorized JavaScript origins` and `http://localhost:3000/account/auth/google_oauth2/callback`
to `Authorized redirect URI`.

You also need to enable the Google+ API from under "APIs & Auth > APIs" if it
isn't already enabled.

The default permissions (aka scope) are to allow access on the users email address
and profile info. This is just fine for "Sign in with Google".

For more information checkout [OmniAuth Google](https://github.com/zquestz/omniauth-google-oauth2).


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

DeviseEasyOmniauthable also adds a controller and helper method
<tt>omniauth_authorize_default_params</tt> that allows you to add default parameters
to the authorization url. We have set it up so that the providers authorisation
page is displayed in the same language as your Apps current language.
You can overwrite this method in your ApplicationController to change that.


## TODO
* add tests
* check if this works with multiple Devise models like user and admin. If not, make it work.
* add more providers (LinkedIn, Xing, ...)
* when logged in allow the user to add more authorizations
  so the website can for example post stuff he did there to his Twitter or Facebook
* encrypt Omniauth tokens?
* use avatar images from omniauth providers for current account?


## Licence

MIT-LICENSE. Copyright 2014 Kai Schneider.

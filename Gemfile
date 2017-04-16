source 'https://rubygems.org'

ruby '2.1.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'rspec-rails', '2.14.2'
  gem 'shoulda-matchers', '2.6.1'
  gem 'thin'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1'
end

gem 'faraday'
gem 'faraday_middleware'

# set explicit git commit (e996bb7d - version 0.0.9) because immediate following ref 32aa336e2 breaks (CfA MunciPal GH issue #165)
gem 'geoservices', :git => 'https://github.com/ajturner/geoservices-ruby.git', :ref => 'e996bb7d'

# Use postgresql as the database for Active Record
gem 'pg', '0.17.1'
gem 'rails_12factor', '0.0.2'

# Use SCSS for stylesheets
gem 'sass-rails', '4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.5.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '4.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.1.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '1.5.3'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Geocoding
gem 'geokit', '1.8.4'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development


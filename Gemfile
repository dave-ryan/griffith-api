source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

#use Cors to allow API requests
gem "rack-cors"

# Use Json Web Token (JWT) for token based authentication
gem "jwt"

# Use active model serializer
gem "active_model_serializers", "~> 0.10.0"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  #fake data
  gem "ffaker"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :production do
  # use PostGreSQL in prod
  gem "pg"
end

group :test do
  # Use sqlite3 as the database for Active Record
  gem "sqlite3", "~> 1.4"

  # used to create temp data
  gem "factory_bot_rails"

  # Testing with rspec
  gem "rspec-rails"

  #data clearing
  gem "database_cleaner-active_record"
end

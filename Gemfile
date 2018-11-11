# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.3"

gem "rails", "~> 5.2.1"

gem "bootsnap", require: false
gem "pg"
gem "puma"

gem "dry-monads", require: false

# authentication & authorization
gem "devise"
gem "doorkeeper"
gem "doorkeeper-grants_assertion"
gem "pundit"

# grape
gem "grape"
gem "grape_logging"

gem "rack-attack"
gem "rack-cors"

# jsonapi
gem "grape-jsonapi-resources"
gem "jsonapi-resources"

group :development, :test do
  gem "byebug"
  gem "pry-rails"
  gem "rails-env-credentials"
end

group :development do
  # spring & guard
  gem "guard-rspec", require: false
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  # codestyle
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "rspec-rails"
end

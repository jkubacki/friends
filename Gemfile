# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 5.2.2"

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

gem "oj"

# jsonapi
gem "grape-jsonapi-resources"
gem "jsonapi-resources"

group :development, :test do
  gem "byebug"
  gem "pry-rails"
  gem "rails-env-credentials"
  gem "rspec-rails"
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
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
  gem "jsonapi-resources-matchers", require: false
  gem "shoulda-matchers"
  gem "vcr"
  gem "webmock"
end

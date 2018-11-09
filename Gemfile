# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.3"

gem "rails", "~> 5.2.1"
gem "pg"
gem "puma"
gem "bootsnap", require: false

gem "dry-monads", require: false

# authentication & authorization
gem "devise"
# gem "doorkeeper"
# gem "doorkeeper-grants_assertion"

group :development, :test do
  gem "byebug"
  gem "rails-env-credentials"
end

group :development do
  gem "letter_opener"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

source "https://rubygems.org"

ruby "3.2.2"

gem "bootsnap", require: false
gem "importmap-rails"
gem "jbuilder"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.2"
gem "redis", ">= 4.0.1"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

gem "dry-initializer"
gem "dry-monads"
gem "dry-validation"

gem "tailwindcss-rails"

gem "faraday"
gem "faraday-multipart"
gem "faraday-retry"

gem "jsonapi-serializer"

gem "pg", "~> 1.1"

gem "whenever"

group :development, :test do
  gem "bullet"
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "rspec-benchmark"
  gem "rspec-rails"
  gem "rubocop", "~> 1.57", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false

  gem "web-console"
end

group :test do
  gem "simplecov", require: false
  gem "webmock"
end

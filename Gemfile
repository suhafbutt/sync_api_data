source "https://rubygems.org"

ruby "3.2.2"

# Rails default gems
gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]

  # Rails specific rubocop rules
  gem "rubocop-rails", require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

# For writing specs.
# See https://github.com/rspec/rspec-rails
gem "rspec-rails"

# For mocking HTTP requests in tests
# See https://github.com/bblimke/webmock
gem "webmock"

# For creating test data in tests
# See https://github.com/thoughtbot/factory_bot_rails
gem "factory_bot_rails"

# The gem we use to make HTTP requests
# See https://github.com/lostisland/faraday
gem "faraday"

# This gem allows you to pretty-print objects using `ap` e.g. `ap object`
gem "awesome_print"

source "https://rubygems.org"

ruby "3.2.2"

gem "simplecov"
gem "rspec-rails"

gem "rails", "~> 7.1.3"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"

# Our app's gems (some were already in here by default, some we added ourselves)
gem 'haml'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
# gem "kredis"
gem "bcrypt", "~> 3.1.7"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

# gem "image_processing", "~> 1.2"

group :development, :quiz do
  gem "debug", platforms: %i[ mri windows ]
  gem 'byebug'
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler", require: false
  gem "spring"
end

group :quiz do
  gem "capybara"
  gem "selenium-webdriver"
end

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.1.3"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"

gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 2.3"

gem "devise", "~> 4.9"

gem "chartkick"
gem "groupdate"

gem "rails-i18n", "~> 7.0"
gem "devise-i18n"

gem "resend", "~> 0.11"

gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

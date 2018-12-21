source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.5.3"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1', '>= 1.1.3'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1', '>= 4.1.10'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0', '>= 4.0.2'
# Use ActiveModel has_secure_password

# Alphabetize non-core gems

gem 'airbrake', '~> 7.4'

# For file storage on S3
gem 'aws-sdk', '~> 2'

# Responsive layout with bootstrap 4
gem 'bootstrap', '~> 4.1.3'

# File uploads
gem 'carrierwave', '~> 1.0'

# Devise for authentication
gem 'devise'

# For using CAS authentication with Devise
gem 'devise_cas_authenticatable', '~> 1.10.3'

# carrierwave support for S3
gem "fog-aws"

# font-awesome for iconography
gem 'font-awesome-sass'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'net-sftp'
# SFTP for banner import
gem 'net-ssh'
# SSH for banner import

# For processing excel files
gem "roo", "~> 2.7"

# Email
# gem 'sendgrid-ruby'

gem 'sidekiq'

gem 'smarter_csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', '~> 0.61.0', require: false
end

group :development do
  # Shiny error messages
  gem "better_errors"
  gem "binding_of_caller"
  gem 'brakeman', require: false
  # N+1 finder
  gem "bullet"
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.7'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.12'
  gem 'chromedriver-helper', '~> 2.1'
  gem 'selenium-webdriver', '~> 3.141'
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

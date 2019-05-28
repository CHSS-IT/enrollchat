source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.6.2"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1', '>= 1.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1', '>= 4.1.20'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.8'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.1'
# Use ActiveModel has_secure_password

# Alphabetize non-core gems

gem 'airbrake'

# For file storage on S3
gem 'aws-sdk', '~> 2'

# Responsive layout with bootstrap 4
gem 'bootstrap', '~> 4.3.1'

# File uploads
gem 'carrierwave', '~> 1.3', '>= 1.3.1'

# Devise for authentication
gem 'devise', '~> 4.6', '>= 4.6.1'

# For using CAS authentication with Devise
gem 'devise_cas_authenticatable', '~> 1.10.3'

# carrierwave support for S3
gem 'fog-aws', '~> 3.4'

# font-awesome for iconography
gem 'font-awesome-sass'

gem 'jquery-rails'
gem 'jquery-ui-rails'
# SFTP for banner import
gem 'net-sftp'
# SSH for banner import
gem 'net-ssh'
# simple reporting tools
gem 'report_action', '~> 0.3.0'
# For processing excel files
gem "roo", "~> 2.7"

# Email
# gem 'sendgrid-ruby'

gem 'sidekiq'

gem 'smarter_csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', '~> 0.70.0', require: false
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
  gem 'capybara', '~> 3.21'
  gem 'simplecov', require: false
  gem 'webdrivers', '~> 3.9', '>= 3.9.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.6.5"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1', '>= 1.1.4'
# Use Puma as the app server
gem 'puma', '~> 4.3.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9', '>= 2.9.1'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.1', '>= 4.1.3'
# Use ActiveModel has_secure_password

# Alphabetize non-core gems

gem 'airbrake', '~> 9.5', '>= 9.5.5'

# For file storage on S3
gem 'aws-sdk', '~> 2'

# Responsive layout with bootstrap 4
gem 'bootstrap', '~> 4.3.1'

# File uploads
gem 'carrierwave', '~> 2.0', '>= 2.0.2'

# carrierwave support for S3
gem 'fog-aws', '~> 3.5', '>= 3.5.2'

# font-awesome for iconography
gem 'font-awesome-sass', '~> 5.11', '>= 5.11.2'

gem 'jquery-rails'
gem 'jquery-ui-rails'
# SFTP for banner import
gem 'net-sftp'
# SSH for banner import
gem 'net-ssh'

# For authentication
gem 'rack-cas', '~> 0.16.1'

# simple reporting tools
gem 'report_action', '~> 0.3.0'

# For processing excel files
gem 'roo', '~> 2.8', '>= 2.8.2'

gem 'sidekiq', '~> 5.2', '>= 5.2.7'

gem 'smarter_csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop-rails', '~> 2.4', '>= 2.4.1'
end

group :development do
  # Shiny error messages
  gem "better_errors"
  gem "binding_of_caller"
  gem 'brakeman', '~> 4.7', '>= 4.7.2', require: false
  # N+1 finder
  gem 'bullet', '~> 6.1.0'
  gem 'listen', '~> 3.2'
  gem 'rack-mini-profiler', '~> 1.1', '>= 1.1.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.7'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.30.0'
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'webdrivers', '~> 4.2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

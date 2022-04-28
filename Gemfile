source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.0.4"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.3'
# Use Puma as the app server
gem 'puma', '~> 5.6.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.6'
# Use ActiveModel has_secure_password

# Alphabetize non-core gems

gem 'airbrake', '~> 13.0'

# For file storage on S3
gem 'aws-sdk-s3', '~> 1.113'

# File uploads
gem 'carrierwave', '~> 2.2'

# carrierwave support for S3
gem 'fog-aws', '~> 3.13'

# font-awesome for iconography
gem 'font-awesome-sass', '~> 6.1.1'

# SFTP for banner import
gem 'net-sftp', '~> 3.0'
# SSH for banner import
gem 'net-ssh', '~> 6.1'

# For authentication
gem 'rack-cas', '~> 0.16.1'

# simple reporting tools
gem 'report_action', '~> 0.4.0'

# For processing excel files
# Until Roo releases a new version containing a fix for Ruby 3.0.1+ we need to pull directly
# from the source. https://github.com/roo-rb/roo/issues/551
gem 'roo', '~> 2.9'

gem 'sidekiq', '~> 6.4'

gem 'smarter_csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1', '>= 11.1.3', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop-rails', '~> 2.13'
end

group :development do
  # Shiny error messages
  gem 'better_errors', '~> 2.9'
  gem "binding_of_caller"
  gem 'brakeman', '~> 5.2', require: false
  # N+1 finder
  gem 'bullet', '~> 7.0.1'
  gem 'listen', '~> 3.7'
  gem 'rack-mini-profiler', '~> 3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 4.2'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.36'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'webdrivers', '~> 5.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

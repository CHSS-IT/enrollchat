source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.7.2"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2', '>= 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 4.3.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.2'
# Use ActiveModel has_secure_password

# Alphabetize non-core gems

gem 'airbrake', '~> 11.0'

# For file storage on S3
gem 'aws-sdk-s3', '~> 1.83'

# File uploads
gem 'carrierwave', '~> 2.1'

# carrierwave support for S3
gem 'fog-aws', '~> 3.6', '>= 3.6.6'

# font-awesome for iconography
gem 'font-awesome-sass', '~> 5.15'

# SFTP for banner import
gem 'net-sftp', '~> 3.0'
# SSH for banner import
gem 'net-ssh', '~> 6.1'

# For authentication
gem 'rack-cas', '~> 0.16.1'

# simple reporting tools
gem 'report_action', '~> 0.3.0'

# For processing excel files
gem 'roo', '~> 2.8', '>= 2.8.3'

gem 'sidekiq', '~> 6.0', '>= 6.0.7'

gem 'smarter_csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1', '>= 11.1.3', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop-rails', '~> 2.6'
end

group :development do
  # Shiny error messages
  gem 'better_errors', '~> 2.9'
  gem "binding_of_caller"
  gem 'brakeman', '~> 4.10', require: false
  # N+1 finder
  gem 'bullet', '~> 6.1.0'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 4.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.34'
  gem 'simplecov', '~> 0.19.1', require: false
  gem 'webdrivers', '~> 4.4', '>= 4.4.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

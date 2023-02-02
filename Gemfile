source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.1.3"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.4.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 6.0.2'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1', '>= 2.1.2'
# Use Terser as compressor for JavaScript assets
gem 'terser', '~> 1.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.8'

# Alphabetize non-core gems

gem 'airbrake', '~> 13.0'

# For file storage on S3
gem 'aws-sdk-s3', '~> 1.119'

gem 'bootstrap', '~> 4.6', '>= 4.6.1'

# File uploads
gem 'carrierwave', '~> 2.2'

# carrierwave support for S3
gem 'fog-aws', '~> 3.15'

# font-awesome for iconography
gem 'font-awesome-sass', '~> 6.2.1'

gem "importmap-rails", "~> 1.1"

gem 'jquery-rails'
gem 'jquery-ui-rails'

# SFTP for banner import
gem 'net-sftp', '~> 4.0'
# SSH for banner import
gem 'net-ssh', '~> 6.1'

# For authentication
gem 'rack-cas', '~> 0.16.1'

# simple reporting tools
gem 'report_action', '~> 0.6.0'

# For processing excel files
# Until Roo releases a new version containing a fix for Ruby 3.0.1+ we need to pull directly
# from the source. https://github.com/roo-rb/roo/issues/551
gem 'roo', '~> 2.9'

gem 'scout_apm', '~> 5.3'

gem 'sidekiq', '~> 6.5', '>= 6.5.7'

gem 'smarter_csv', '~> 1.7'

gem 'sprockets-rails', '~> 3.4', '>= 3.4.2'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails', '~> 1.2'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails', '~> 1.3'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'rubocop-rails', '~> 2.16'
end

group :development do
  # Shiny error messages
  gem 'better_errors', '~> 2.9'
  gem "binding_of_caller"
  gem 'brakeman', '~> 5.4', require: false
  # N+1 finder
  gem 'bullet', '~> 7.0.7'
  gem 'listen', '~> 3.8'
  gem 'rack-mini-profiler', '~> 3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 4.2'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.38'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'webdrivers', '~> 5.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

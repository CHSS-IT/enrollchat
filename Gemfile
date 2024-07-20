source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.3.4"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.8.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'
# Use Puma as the app server
gem 'puma', '~> 6.4'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1', '>= 2.1.2'
# Use Terser as compressor for JavaScript assets
gem 'terser', '~> 1.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.2'

# Alphabetize non-core gems

gem 'airbrake', '~> 13.0'

# For file storage on S3
gem 'aws-sdk-s3', '~> 1.156'

gem 'bootstrap', '~> 4.6', '>= 4.6.1'

# File uploads
gem 'carrierwave', '~> 3.0'

# carrierwave support for S3
gem 'fog-aws', '~> 3.22'

# font-awesome for iconography
gem 'font-awesome-sass', '~> 6.5.2'

gem 'importmap-rails', '~> 1.2', '>= 1.2.3'

gem 'jquery-rails'

# SFTP for banner import
gem 'net-sftp', '~> 4.0'
# SSH for banner import
gem 'net-ssh', '~> 7.2'

# For authentication
gem 'rack-cas', '~> 0.16.1'

# simple reporting tools
gem 'report_action', '~> 0.6.0'

# For processing excel files
# Until Roo releases a new version containing a fix for Ruby 3.0.1+ we need to pull directly
# from the source. https://github.com/roo-rb/roo/issues/551
gem 'roo', '~> 2.10'

gem 'scout_apm', '~> 5.3'

gem 'sidekiq', '~> 7.2'

gem 'smarter_csv', '~> 1.9'

gem 'sprockets-rails', '~> 3.4', '>= 3.4.2'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails', '~> 1.3'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails', '~> 1.5'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'rubocop-rails', '2.25.1'
end

group :development do
  # Shiny error messages
  gem 'better_errors', '~> 2.10'
  gem "binding_of_caller"
  gem 'brakeman', '~> 6.1', require: false
  # N+1 finder
  gem 'bullet', '~> 7.1.6'
  gem 'listen', '~> 3.9'
  gem 'rack-mini-profiler', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 4.2'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.21'
  gem 'simplecov', '~> 0.22.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

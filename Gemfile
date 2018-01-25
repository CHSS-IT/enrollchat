source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.4.2"

gem "rake"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password

# Alphabetize non-core gems

gem 'airbrake', '~> 7.0'

# For file storage on S3
gem 'aws-sdk', '~> 2'

# Responsive layout with bootstrap 4
gem 'bootstrap', '~> 4.0.0'

gem 'bootstrap-select-rails'

# File uploads
gem 'carrierwave', '~> 1.0'

# Devise for authentication
gem 'devise'

# For using CAS authentication with Devise
gem 'devise_cas_authenticatable', '~> 1.10.2'

# carrierwave support for S3
gem "fog-aws"

# font-awesome for iconography
gem 'font-awesome-sass'

gem 'jquery-rails'
gem 'jquery-ui-rails'


# For processing excel files
gem "roo", "2.6.0"

# Email
# gem 'sendgrid-ruby'

gem 'sidekiq'

gem 'smarter_csv'

gem 'net-sftp'
# SFTP for banner import
gem 'net-ssh'
# SSH for banner import

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Shiny error messages
  gem "better_errors"
  gem "binding_of_caller"
  # N+1 finder
  gem "bullet"
  gem 'rack-mini-profiler'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

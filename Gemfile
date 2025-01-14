source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'
gem "rumoji"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
gem "nokogiri"
gem 'whenever', require: false
gem 'kaminari'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
   # Test Framework
   gem 'rspec'
   gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

 gem 'rack-cors', :require => 'rack/cors'
gem 'devise'  
 gem 'devise_token_auth'
gem 'geocoder'
gem 'fcm'
gem 'geokit'
gem 'geokit-rails'
gem 'redis-rails'
# Elasticsearch integration
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'axlsx', git: 'https://github.com/randym/axlsx.git'
gem 'axlsx_rails'

# gem 'geokit-rails'


group :test do
  # Clean Database between tests
  gem 'database_cleaner'
  # Programmatically start and stop ES for tests
  gem 'elasticsearch-extensions'
end


gem "roo", "~> 2.8.0"

gem 'time_difference'


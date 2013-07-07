source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'devise'
gem 'cancan'
#gem 'devise_oauth2_providable'
gem 'doorkeeper', '~> 0.6.7'

# testing
group :development, :test do
  gem "rspec-rails", '~> 2.0'
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "database_cleaner"  # for disabling transactions for separate thread js drivers
  gem "poltergeist" # for headless javascript testing that does not require any X server or system libraries, only PhantoJS
end

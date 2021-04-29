source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'aws-sdk-ssm'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'doorkeeper', '~> 5.4'
gem 'dotenv-rails'
gem 'openstax_accounts', '~> 9.6.1'
gem 'openstax_api', '~> 9.4.0'
gem 'openstax_auth', github: 'openstax/auth-rails', ref: 'ed2d7da86ca226b93376955b9474c4cf115c611f'
gem 'openstax_healthcheck', '~> 1.0.0'
gem 'openstax_salesforce'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rack-cors'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'restforce', '~> 5.0.5'
gem 'rspec-rails'
gem 'rswag'
gem 'ruby-pardot'
gem 'sentry-ruby'
gem 'sidekiq'
gem 'sidekiq-cron', github: 'ondrejbartas/sidekiq-cron', ref: '6a0aeff6c900f3b7246734282f6869c61e1d5b4e'
gem 'sidekiq-failures'
gem 'versionist'
gem 'will_paginate', '~> 3.1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rswag-specs'
  gem 'vcr'
  gem 'webmock'
end

group :test do
  gem 'codecov', require: false
  gem 'rspec-sidekiq'
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

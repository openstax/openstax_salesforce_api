source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'aws-sdk-ssm'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'coffee-rails'
gem 'doorkeeper', '~> 5.4'
gem 'dotenv-rails'
gem 'mini_racer'
gem 'openstax_accounts', '~> 9.8.0'
gem 'openstax_api', '~> 9.4.0'
gem 'openstax_auth', github: 'openstax/auth-rails', ref: 'ed2d7da86ca226b93376955b9474c4cf115c611f'
gem 'openstax_healthcheck', '~> 1.0.0'
gem 'openstax_salesforce', github: 'openstax/openstax_salesforce', ref: 'b250271c38a06ce2957d20919f028099f69cf752'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rack-cors'
gem 'rails', '~> 6.1'
gem 'restforce', '~> 5.0.5'
gem 'rspec-rails'
gem 'rswag'
gem 'rexml'
gem 'ruby-pardot'
gem 'sass-rails'
gem 'scout_apm'
gem 'sentry-rails'
gem 'sentry-ruby'
gem "sentry-sidekiq"
gem 'sidekiq'
gem 'sidekiq-cron', github: 'ondrejbartas/sidekiq-cron', ref: '6a0aeff6c900f3b7246734282f6869c61e1d5b4e'
gem 'sidekiq-enqueuer'
gem 'sidekiq-failures'
gem 'sidekiq-status'
gem 'sidekiq-unique-jobs'
gem 'versionist'
gem 'uglifier'
gem 'will_paginate', '~> 3.3.0'

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

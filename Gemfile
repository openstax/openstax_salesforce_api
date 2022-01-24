source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'coffee-rails'
gem 'doorkeeper', '~> 5.4'
gem 'dotenv-rails'
gem 'mini_racer'
gem 'openstax_accounts', '~> 9.8.0'
gem 'openstax_api', '~> 9.4.0'
#TODO: we should not need both openstax_accounts and openstax_auth
gem 'openstax_auth', github: 'openstax/auth-rails', ref: 'ed2d7da86ca226b93376955b9474c4cf115c611f'
gem 'openstax_healthcheck'
gem 'openstax_salesforce'
gem 'openstax_utilities'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma'
gem 'rack-cors'
gem 'rails', '~> 6.1'
gem 'restforce', '~> 5.0.5'
gem 'rswag'
gem 'rexml'
gem 'ruby-pardot'
gem 'sd_notify'
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
  # Run specs in parallel
  gem 'parallel_tests'

  # Show failing parallel specs instantly
  gem 'rspec-instafail'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Use RSpec for tests
  gem 'rspec-rails'

  # Fixture replacement
  gem 'factory_bot_rails'

  # Stubs HTTP requests
  gem 'webmock'

  # Records HTTP requests
  gem 'vcr'

  # Ability to create API docs from specs
  gem 'rswag-specs'

  # clean the database between test runs
  gem 'database_cleaner-active_record'

  # generate fake data for tests
  gem 'faker'

  #
  gem 'listen', '~> 3.2'

  #
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # codecov integration
  gem 'codecov', require: false

  # be able to test sidekiq jobs
  gem 'rspec-sidekiq'
end

group :production do
  # Used to fetch secrets from the AWS parameter store and secrets manager
  gem 'aws-sdk-ssm', require: false

  # Lograge for consistent logging
  gem 'lograge'
end

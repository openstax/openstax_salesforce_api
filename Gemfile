source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Rails framework
gem 'rails', '~> 6.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# OAuth provider
gem 'doorkeeper', '~> 5.4'

# Get env variables from .env file
gem 'dotenv-rails'

# JavaScript asset compiler
gem 'mini_racer'

# JavaScript asset compressor
gem 'uglifier'

# OpenStax Accounts
gem 'openstax_accounts', '~> 9.8.0'

# API versioning and documentation
gem 'openstax_api', '~> 9.4.0'

# OpenStax Accounts SSO
gem 'openstax_auth', github: 'openstax/auth-rails', ref: 'ed2d7da86ca226b93376955b9474c4cf115c611f'

# Respond to ELB healthchecks in /ping and /ping/
gem 'openstax_healthcheck'

# OpenStax Salesforce helpers
gem 'openstax_salesforce'

# Ruby interface to Salesforce
gem 'restforce', '~> 5.0.5'

# Utilities for OpenStax websites
gem 'openstax_utilities'

# PostgreSQL database
gem 'pg'

# Threaded application server
gem 'puma'

# Prevent server memory from growing until OOM
gem 'puma_worker_killer'

# CORS for local testing/dev
gem 'rack-cors'

# Generate API Docs
gem 'rswag'

#XML Utilities
gem 'rexml'

# Pardot integration
gem 'ruby-pardot'

# Support systemd Type=notify services for puma and delayed_job
gem 'sd_notify'
gem 'sass-rails'

# Scout Integration
gem 'scout_apm'

# Sentry integration
gem 'sentry-rails'
gem 'sentry-ruby'
gem "sentry-sidekiq"

# sidekiq for background jobs
gem 'sidekiq'
gem 'sidekiq-cron', github: 'ondrejbartas/sidekiq-cron', ref: '6a0aeff6c900f3b7246734282f6869c61e1d5b4e'
gem 'sidekiq-enqueuer'
gem 'sidekiq-failures'
gem 'sidekiq-status'
gem 'sidekiq-unique-jobs'

# Version Rails RESTful APIs
gem 'versionist'

# Pagination
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

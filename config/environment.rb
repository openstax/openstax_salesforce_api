# Load the Rails application.
require_relative 'application'
require 'pardot/patches'
require 'rescue_from_unless_local'
require 'errors'
require 'sidekiq/web'
require 'sidekiq/cron/web'


# Initialize the Rails application.
Rails.application.initialize!

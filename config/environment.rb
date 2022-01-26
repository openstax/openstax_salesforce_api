# Load the Rails application.
require_relative 'application'

Rails.application.reloader.to_prepare do
  require 'pardot/patches'
  require 'rescue_from_unless_local'
  require 'errors'
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
end

# Initialize the Rails application.
Rails.application.initialize!

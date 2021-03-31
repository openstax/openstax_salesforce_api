# Load the Rails application.
require_relative 'application'
require 'pardot/patches'
require 'rescue_from_unless_local'
require 'errors'
require 'salesforce/client'
require 'sidekiq/web'

# Initialize the Rails application.
Rails.application.initialize!

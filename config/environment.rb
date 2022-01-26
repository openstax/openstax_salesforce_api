# Load the Rails application.
require_relative 'application'
require 'pardot/patches'
require 'rescue_from_unless_local'
require 'errors'

# Initialize the Rails application.
Rails.application.initialize!

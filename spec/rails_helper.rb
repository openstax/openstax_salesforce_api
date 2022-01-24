ENV['RAILS_ENV'] ||= 'test'

require 'simplecov_helper'
require File.expand_path('../config/environment', __dir__)
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
require 'openstax/salesforce/spec_helpers'
require 'rspec/rails'
require 'parallel_tests'
require 'spec_helper'

# https://github.com/colszowka/simplecov/issues/369#issuecomment-313493152
# Load rake tasks so they can be tested.
Rails.application.load_tasks unless defined?(Rake::Task) && Rake::Task.task_defined?('environment')

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Add additional requires below this line. Rails is not loaded until this point!
require 'support/factory_bot'
require 'database_cleaner/active_record'

require 'openstax/salesforce/spec_helpers'
include OpenStax::Salesforce::SpecHelpers

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # clean the database between test runs
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end

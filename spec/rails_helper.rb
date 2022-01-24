require 'simplecov'
require 'codecov'

# Deactivate automatic result merging, because we use custom result merging code
SimpleCov.use_merging false

# Custom result merging code to avoid the many partial merges that SimpleCov usually creates
# and send to codecov only once
SimpleCov.at_exit do
  # Store the result for later merging
  SimpleCov::ResultMerger.store_result(SimpleCov.result)

  # All processes except one will exit here
  next unless ParallelTests.last_process?

  # Wait for everyone else to finish
  ParallelTests.wait_for_other_processes_to_finish

  # Send merged result to codecov only if on CI (will generate HTML report by default locally)
  SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV['CI'] == 'true'

  # Merge coverage reports (and maybe send to codecov)
  SimpleCov::ResultMerger.merged_result.format!
end

# Start calculating code coverage
unless ENV['NO_COVERAGE']
  SimpleCov.start('rails') { merge_timeout 3600 }
end

ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

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

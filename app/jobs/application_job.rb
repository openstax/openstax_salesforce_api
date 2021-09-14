class ApplicationJob < ActiveJob::Base
  include Sidekiq::Status::Worker
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  BATCH_SIZE = 250
  SF_PACKAGE = 'OpenStax::Salesforce::Remote::'.freeze

end

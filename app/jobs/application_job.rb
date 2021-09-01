class ApplicationJob < ActiveJob::Base
  include Sidekiq::Status::Worker
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  BATCH_SIZE = 250
  SF_PACKAGE = 'OpenStax::Salesforce::Remote::'.freeze

  def delete_objects_not_in_salesforce(name)
    class_name = SF_PACKAGE + name
    sf_objs = class_name.constantize.all
    name.constantize.where.not(salesforce_id: sf_objs.map(&:id)).destroy_all
  end

end

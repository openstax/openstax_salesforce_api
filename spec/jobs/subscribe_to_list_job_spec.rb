require 'rails_helper'

RSpec.describe SubscribeToListJob, type: :job do
  describe '#perform_later' do
    it 'subscribes to a list' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        SubscribeToListJob.perform_later(1)
      }.to have_enqueued_job
    end
  end
end

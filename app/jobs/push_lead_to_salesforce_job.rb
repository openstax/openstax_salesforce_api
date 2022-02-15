class PushLeadToSalesforceJob < ApplicationJob
  queue_as :default

  def perform(lead)
    begin
      Lead.push_lead(lead)
    rescue => e
      Sentry.capture_exception(e)
    end
  end
end

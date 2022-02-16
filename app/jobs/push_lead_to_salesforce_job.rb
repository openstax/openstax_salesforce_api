class PushLeadToSalesforceJob < ApplicationJob
  queue_as :leads

  def perform(lead_id)
    begin
      lead = Lead.find(lead_id)
      Lead.push(lead)
    rescue => e
      Sentry.capture_exception(e)
    end
  end
end

class PushOpportunityToSalesforceJob < ApplicationJob
  queue_as :opportunities

  def perform(salesforce_id)
    opportunity = Opportunity.find_by_salesforce_id(salesforce_id)

    Opportunity.push_or_update(opportunity)
  end
end

class RetryFailedOpportunities

  def self.call
    new.retry_opportunities
  end

  def retry_opportunities
    opportunities = Opportunity.find(salesforce_updated: false)

    opportunities.each do |opportunity|
      push_opportunity = PushOpportunityToSalesforce.new
      success = push_opportunity.find_or_create_opportunity(opportunity.to_json)
      if success
        opportunity.salesforce_updated = true
        opportunity.save
      end
    end
  end
end

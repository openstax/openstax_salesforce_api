require 'push_opportunity_to_salesforce'

class RetryFailedOpportunities

  def self.call
    new.retry_opportunities
  end

  def retry_opportunities
    opportunities = Opportunity.where(salesforce_updated: false)

    opportunities.each do |opportunity|
      push_opportunity = PushOpportunityToSalesforce.new
      sf_opportunity = push_opportunity.find_or_create_opportunity(opportunity.as_json.symbolize_keys)
      if sf_opportunity.errors.none?
        opportunity.salesforce_updated = true
        opportunity.salesforce_id = sf_opportunity.id
        opportunity.save
      else
        Rails.logger.warn('[RetryFailedOpportunities] Error creating opportunity in salesforce:' + opportunity.id + ' ' + sf_opportunity.errors.inspect)
      end
    end
  end
end

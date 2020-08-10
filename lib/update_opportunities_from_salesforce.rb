class UpdateOpportunitiesFromSalesforce
  def self.call
    new.start_update
  end

  def start_update
    sf_opportunities = retrieve_salesforce_data
    update_opportunities(sf_opportunities)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::Opportunity
        .select(:id, :term_year, :book_name, :contact_id, :new )
        .to_a
  end

  def update_opportunities(sf_opportunities)
    sf_opportunities.each do |sf_opportunity|
      opportunity_to_update = Opportunity.find_or_initialize_by(salesforce_id: sf_opportunity.id)
      opportunity_to_update.salesforce_id = sf_opportunity.id
      opportunity_to_update.term_year = sf_opportunity.term_year
      opportunity_to_update.book_name = sf_opportunity.book_name
      opportunity_to_update.contact_id = sf_opportunity.contact_id
      opportunity_to_update.new = sf_opportunity.new

      opportunity_to_update.save if opportunity_to_update.changed?
    end
  end
end

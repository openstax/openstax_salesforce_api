class User

  def initialize(uuid)
    @uuid = uuid
    Sentry.set_user(id: @uuid)
  end

  def contact
    @contact ||= Contact.find_or_fetch_by_uuid(@uuid)
  end

  def opportunities
    @opportunities ||= Opportunity.find_or_fetch_by_uuid(@uuid)
  end

  def leads
    @leads ||= Lead.find_or_fetch_by_uuid(@uuid)
  end

  def schools
    @school ||= AccountContactRelation.where(contact_id: @contact.salesforce_id) unless @contact.nil?
  end

  def subscriptions
    @subscriptions ||= Subscription.where(contact_id: @contact.id) unless @contact.nil?
  end
end

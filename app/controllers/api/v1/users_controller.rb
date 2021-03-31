class Api::V1::UsersController < Api::V1::BaseController
  def index
    opportunities = Opportunity.where(os_accounts_id: sso_cookie_field('id'))
    leads = Lead.where(os_accounts_id: sso_cookie_field('id'))

    list_subscriptions = []
    # Add all the lists to the subscriptions array, we update subscribed to true below if the user is subscribed.
    # This reduces calls to the API by providing all available lists in the users API.
    List.all.each do |list|
      list_subscriptions.push({ id: list.pardot_id,
                                title: list.title,
                                description: list.description,
                                subscribed: current_contact&.subscriptions.any? { |subscription| subscription.list == list } })
    end

    render json: {
      opportunity: opportunities,
      contact: current_contact,
      lead: leads,
      subscriptions: list_subscriptions
    }
  end
end

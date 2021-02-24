class Api::V1::UsersController < ApplicationController
  def index
    sso_cookie = cookie_data
    return return_bad_request('User') if sso_cookie.blank?

    # get opportunity
    opportunity = Opportunity.where(os_accounts_id: sso_cookie.dig('sub', 'id'))
    # get contact
    contact = Contact.where(salesforce_id: sso_cookie.dig('sub', 'salesforce_contact_id'))
    # get leads
    lead = Lead.where(os_accounts_id: sso_cookie.dig('sub', 'id'))

    # fetch local pardot subscriptions, if they exist, otherwise get them from Pardot
    user_email_lists = []

    if Subscription.exists?(contact: contact)
      Subscription.where(contact: contact).each do |subscription|
        user_email_lists.push({ id: subscription.list.pardot_id, title: subscription.list.title, description: subscription.list.description })
      end

    else
      #TODO: move this somewhere shared, so it can also be used in update rake task
      @client = Pardot::Client.client
      @prospect = @client.prospects.read_by_fid(contact.salesforce_id)

      @prospect['lists']['list_subscription'].each do |subscription|
        next unless subscription['list']['is_public'] == 'true'

        user_email_lists.push({ id: subscription['list']['id'], title: subscription['list']['name'], description: subscription['list']['description'] })

        list = List.where(pardot_id: subscription['list']['id']).first_or_create do |plist|
          plist.title = subscription['list']['title']
          plist.description = subscription['list']['description']
        end

        Subscription.create list: list, contact: contact

      end
    end

    render json: {
      opportunity: opportunity,
      contact: contact,
      lead: lead,
      subscriptions: user_email_lists
    }
  end

end

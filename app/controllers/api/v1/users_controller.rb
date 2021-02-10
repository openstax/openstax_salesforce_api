require 'pardot/pardot'

class Api::V1::UsersController < ApplicationController
  include Pardot
  before_action :pardot_client

  def index
    sso_cookie = cookie_data
    return return_bad_request('User') if sso_cookie.blank?

    # get opportunity
    opportunity = Opportunity.where(os_accounts_id: sso_cookie.dig('sub', 'id'))
    # get contact
    contact = Contact.where(salesforce_id: sso_cookie.dig('sub', 'salesforce_contact_id'))
    # get leads
    lead = Lead.where(os_accounts_id: sso_cookie.dig('sub', 'id'))

    # add currently subscribed pardot lists
    user_email_lists = []
    begin
      @prospect = @client.prospects.read_by_fid(sso_cookie.dig('sub', 'salesforce_contact_id'))

      @prospect['lists']['list_subscription'].each do |list|
        if list['list']['is_public'] == 'true'
          user_email_lists.push({ id: list['list']['id'], title: list['list']['name'], description: list['list']['description'] })
        end
      end
    rescue Pardot::ResponseError
      Rails.logger.info 'no pardot record for this user'
    end

    render json: {
      opportunity: opportunity,
      contact: contact,
      lead: lead,
      lists: user_email_lists
    }
  end

end

require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::Base
  USE_SSO = Rails.configuration.sso['use_sso'].freeze

  def verify_sso_cookie(sf_object)
    unless USE_SSO
      return
    end

    decrypt = OpenStax::Auth::Strategy2.decrypt(request)
    cookie_uuid = decrypt.dig('sub', 'uuid')
    results = JSON.parse(OpenStax::Accounts::Api.search_accounts("uuid:#{cookie_uuid}", options = {}).body)
    contact_id = results['items'][0]['salesforce_contact_id'] unless results['items'].blank?
    if contact_id.blank?
      doorkeeper_authorize!
    else
      contact = Contact.where(salesforce_id: contact_id)
      if contact.blank?
        return_bad_request(sf_object) unless doorkeeper_token
      end
    end
  end

  def cookie_data
    unless USE_SSO
      return
    end

    OpenStax::Auth::Strategy2.decrypt(request)
  end

  def return_bad_request(sf_object)
    render :json => {:request_object => "#{sf_object}", :status => "bad request"}.to_json, :status => :bad_request
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "Not authorized" } }
  end
end

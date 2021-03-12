require 'openstax/auth/strategy_2'

class ApplicationController < ActionController::Base
  USE_SSO = Rails.configuration.sso['use_sso'].freeze

  def verify_sso_cookie(sf_object)
    unless USE_SSO
      return
    end

    decrypt = OpenStax::Auth::Strategy2.decrypt(request)
    cookie_id = decrypt.dig('sub', 'salesforce_contact_id')
    cookie_uuid = decrypt.dig('sub', 'uuid')
    puts '***UUID: ' + cookie_uuid.inspect
    results = OpenStax::Accounts::Api.search_accounts("uuid:0c490f72-ef4c-4716-ba7a-f3bea3987900", options = {})
    contact_id = results.body
    puts '*** Contact Id: ' + contact_id.inspect
    puts '***Results: ' + results.inspect
    if cookie_id.blank?
      doorkeeper_authorize!
    else
      contact = Contact.where(salesforce_id: cookie_id)
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
